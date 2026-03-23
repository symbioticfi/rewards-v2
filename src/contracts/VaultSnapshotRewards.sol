// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import {CuratorFees} from "./CuratorFees.sol";

import {IFeeRegistry} from "../interfaces/IFeeRegistry.sol";
import {IProtocolFees} from "../interfaces/IProtocolFees.sol";
import {IRewardsBase} from "../interfaces/IRewardsBase.sol";
import {IRewards} from "../interfaces/IRewards.sol";
import {IUniversalDelegator} from "../interfaces/IUniversalDelegator.sol";
import {IVaultSnapshotRewards} from "../interfaces/IVaultSnapshotRewards.sol";
import {IVaultV2, VAULT_V2_VERSION} from "../interfaces/IVaultV2.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IBaseDelegator} from "@symbioticfi/core/src/interfaces/delegator/IBaseDelegator.sol";
import {IMigratableEntity} from "@symbioticfi/core/src/interfaces/common/IMigratableEntity.sol";
import {INetworkMiddlewareService} from "@symbioticfi/core/src/interfaces/service/INetworkMiddlewareService.sol";
import {INetworkRestakeDelegator} from "@symbioticfi/core/src/interfaces/delegator/INetworkRestakeDelegator.sol";
import {
    IOperatorNetworkSpecificDelegator
} from "@symbioticfi/core/src/interfaces/delegator/IOperatorNetworkSpecificDelegator.sol";
import {IOperatorSpecificDelegator} from "@symbioticfi/core/src/interfaces/delegator/IOperatorSpecificDelegator.sol";
import {IRegistry} from "@symbioticfi/core/src/interfaces/common/IRegistry.sol";
import {Subnetwork} from "@symbioticfi/core/src/contracts/libraries/Subnetwork.sol";

/// @title VaultSnapshotRewards
/// @notice Contract for managing vault snapshot-based rewards distributions.
/// @dev The protocol fee is deducted from the distribution amount.
abstract contract VaultSnapshotRewards is CuratorFees, IVaultSnapshotRewards {
    using SafeERC20 for IERC20;
    using Math for uint256;
    using Subnetwork for bytes32;
    using Subnetwork for address;

    /* IMMUTABLES */

    /// @inheritdoc IVaultSnapshotRewards
    address public immutable VAULT_FACTORY;

    /// @inheritdoc IVaultSnapshotRewards
    address public immutable NETWORK_REGISTRY;

    /// @inheritdoc IVaultSnapshotRewards
    address public immutable NETWORK_MIDDLEWARE_SERVICE;

    /* STORAGE */

    /// @custom:storage-location erc7201:symbiotic.rewards.VaultSnapshotRewards
    struct VaultSnapshotRewardsStorage {
        mapping(
            address vault => mapping(address network => mapping(address token => RewardDistribution[] rewards_))
        ) _rewards;
        mapping(
            address account
                => mapping(address vault => mapping(address network => mapping(address token => uint256 rewardIndex)))
        ) _lastUnclaimedReward;
        mapping(
            address account
                => mapping(address vault => mapping(address network => mapping(address token => uint256 rewardIndex)))
        ) _lastUnclaimedOperatorReward;
        mapping(address vault => mapping(uint48 timestamp => uint256 amount)) _activeSharesCache;
        // 32 bytes gap for CuratorFees
        bytes32 __gap;
        mapping(address vault => mapping(bytes32 subnetwork => mapping(uint48 timestamp => uint256 amount)))
            _totalOperatorNetworkSharesCache;
        mapping(address vault => mapping(bytes32 subnetwork => mapping(uint48 timestamp => uint256 amount)))
            _subnetworkFilledCache;
        mapping(address vault => mapping(uint48 timestamp => uint256 amount)) _activeWithdrawalSharesCache;
    }

    // keccak256(abi.encode(uint256(keccak256("symbiotic.rewards.VaultSnapshotRewards")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant VAULT_SNAPSHOT_REWARDS_STORAGE_POSITION =
        0xea7ec811d4da20f680ecf87dbad2b956cc74e833cd99b5f63865df6b3d6b6800;

    function _vaultSnapshotRewardsStorage() private pure returns (VaultSnapshotRewardsStorage storage $) {
        assembly {
            $.slot := VAULT_SNAPSHOT_REWARDS_STORAGE_POSITION
        }
    }

    /* CONSTRUCTOR */

    constructor(address vaultFactory, address networkRegistry, address networkMiddlewareService) {
        VAULT_FACTORY = vaultFactory;
        NETWORK_REGISTRY = networkRegistry;
        NETWORK_MIDDLEWARE_SERVICE = networkMiddlewareService;
    }

    /* PUBLIC FUNCTIONS */

    /// @inheritdoc IProtocolFees
    function distributionToTotalAmount(
        uint64,
        /*rewardsType*/
        address network,
        uint256 distributionAmount
    )
        public
        view
        virtual
        override
        returns (uint256)
    {
        return distributionAmount > 0
            ? (distributionAmount - 1)
                .mulDiv(MAX_FEE, MAX_FEE - protocolFee(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), network)) + 1
            : 0;
    }

    /// @inheritdoc IProtocolFees
    function totalToDistributionAmount(
        uint64,
        /*rewardsType*/
        address network,
        uint256 totalDistributionAmount
    )
        public
        view
        virtual
        override
        returns (uint256)
    {
        return totalDistributionAmount
            - totalDistributionAmount.mulDiv(protocolFee(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), network), MAX_FEE);
    }

    /// @inheritdoc IVaultSnapshotRewards
    function rewardsLength(address vault, address network, address token) public view returns (uint256) {
        return _vaultSnapshotRewardsStorage()._rewards[vault][network][token].length;
    }

    /// @inheritdoc IVaultSnapshotRewards
    function rewards(address vault, address network, address token, uint256 index)
        public
        view
        returns (RewardDistribution memory)
    {
        return _vaultSnapshotRewardsStorage()._rewards[vault][network][token][index];
    }

    /// @inheritdoc IVaultSnapshotRewards
    function lastUnclaimedReward(address account, address vault, address network, address token)
        public
        view
        returns (uint256)
    {
        return _vaultSnapshotRewardsStorage()._lastUnclaimedReward[account][vault][network][token];
    }

    /// @inheritdoc IVaultSnapshotRewards
    function lastUnclaimedOperatorReward(address account, address vault, address network, address token)
        public
        view
        returns (uint256)
    {
        return _vaultSnapshotRewardsStorage()._lastUnclaimedOperatorReward[account][vault][network][token];
    }

    /// @inheritdoc IVaultSnapshotRewards
    function distributeVaultSnapshotRewards(
        bytes32 subnetwork,
        address token,
        address vault,
        uint256 amount,
        uint48 timestamp,
        bytes calldata hints
    ) public nonReentrant {
        DistributeVaultSnapshotRewardsHints memory distributeVaultSnapshotRewardsHints;
        if (hints.length > 0) {
            distributeVaultSnapshotRewardsHints = abi.decode(hints, (DistributeVaultSnapshotRewardsHints));
        }

        address network = subnetwork.network();
        if (
            !IRegistry(NETWORK_REGISTRY).isEntity(network)
                || (network != msg.sender
                    && INetworkMiddlewareService(NETWORK_MIDDLEWARE_SERVICE).middleware(network) != msg.sender)
        ) {
            revert NotNetworkOrMiddleware();
        }

        if (!IRegistry(VAULT_FACTORY).isEntity(vault)) {
            revert NotVault();
        }

        if (timestamp >= block.timestamp) {
            revert InvalidRewardTimestamp();
        }

        uint64 vaultVersion = IMigratableEntity(vault).version();
        bool isVaultV2 = vaultVersion >= VAULT_V2_VERSION;
        bool isDonation = token == address(0);

        // Get token to distribute or cache total shares.
        address rewardToken = token;
        if (isDonation) {
            if (!isVaultV2) {
                revert NoDonationSupport();
            }
            rewardToken = IVaultV2(vault).collateral();
        } else if (_vaultSnapshotRewardsStorage()._activeSharesCache[vault][timestamp] == 0) {
            uint256 activeShares =
                IVaultV2(vault).activeSharesAt(timestamp, distributeVaultSnapshotRewardsHints.activeSharesHint);
            uint256 activeWithdrawalShares = isVaultV2 ? IVaultV2(vault).activeWithdrawalSharesAt(timestamp) : 0;

            if (activeShares == 0 && activeWithdrawalShares == 0) {
                revert InvalidRewardTimestamp();
            }

            _vaultSnapshotRewardsStorage()._activeSharesCache[vault][timestamp] = activeShares;
            _vaultSnapshotRewardsStorage()._activeWithdrawalSharesCache[vault][timestamp] = activeWithdrawalShares;
        }

        // Get real transferred amount for fee-on-transfer tokens.
        uint256 balanceBefore = IERC20(rewardToken).balanceOf(address(this));
        IERC20(rewardToken).safeTransferFrom(msg.sender, address(this), amount);
        amount = IERC20(rewardToken).balanceOf(address(this)) - balanceBefore;

        if (amount == 0) {
            revert InsufficientReward();
        }

        // Support legacy delegator.
        address delegator = IVaultV2(vault).delegator();
        uint64 delegatorType = IBaseDelegator(delegator).TYPE();
        if (delegatorType == uint64(DelegatorType.UNIVERSAL)) {
            address oldDelegator = IUniversalDelegator(delegator).oldDelegator();
            if (oldDelegator != address(0) && timestamp < IUniversalDelegator(delegator).migrateTimestamp()) {
                delegator = oldDelegator;
                delegatorType = IBaseDelegator(delegator).TYPE();
            }
        }

        // Calculate protocol and operator fees.
        uint256 distributionAmount =
            _subProtocolFeesFromTotal(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), network, rewardToken, amount);
        uint256 operatorsFees = distributionAmount.mulDiv(
            IFeeRegistry(FEE_REGISTRY)
                .getOperatorsFeeAt(vault, network, timestamp, distributeVaultSnapshotRewardsHints.operatorsFeeHint),
            MAX_FEE
        );

        // Leave operator fees only if needed.
        if (delegatorType == uint64(DelegatorType.NETWORK_RESTAKE)) {
            uint256 totalOperatorNetworkShares = INetworkRestakeDelegator(delegator)
                .totalOperatorNetworkSharesAt(
                    subnetwork, timestamp, distributeVaultSnapshotRewardsHints.totalOperatorNetworkSharesHint
                );
            if (totalOperatorNetworkShares == 0) {
                operatorsFees = 0;
            } else {
                _vaultSnapshotRewardsStorage()._totalOperatorNetworkSharesCache[vault][subnetwork][timestamp] =
                totalOperatorNetworkShares;
            }
        } else if (delegatorType == uint64(DelegatorType.FULL_RESTAKE)) {
            operatorsFees = 0;
        } else if (delegatorType == uint64(DelegatorType.UNIVERSAL)) {
            uint96 subnetworkIndex = IUniversalDelegator(delegator).getSlotOfNetworkAt(subnetwork, timestamp);
            uint256 subnetworkFilled = IUniversalDelegator(delegator).getFilledAt(subnetworkIndex, 0, timestamp);
            if (subnetworkIndex == 0 || subnetworkFilled == 0) {
                operatorsFees = 0;
            } else {
                _vaultSnapshotRewardsStorage()._subnetworkFilledCache[vault][subnetwork][timestamp] = subnetworkFilled;
            }
        } else if (delegatorType > uint64(type(DelegatorType).max)) {
            revert InvalidDelegatorType();
        }

        // Subtract curator and operator fees from distribution amount.
        distributionAmount = _subCuratorFeesAtFromDistribution(
            uint64(IRewards.RewardsType.VAULT_SNAPSHOT),
            vault,
            network,
            rewardToken,
            distributionAmount,
            timestamp,
            distributeVaultSnapshotRewardsHints.curatorFeeHint
        );
        distributionAmount -= operatorsFees;

        // Create a snapshot distribution request only if needed.
        if ((distributionAmount > 0 && !isDonation) || operatorsFees > 0) {
            RewardDistribution storage distribution =
                _vaultSnapshotRewardsStorage()._rewards[vault][network][rewardToken].push();
            distribution.subnetworkId = subnetwork.identifier();
            distribution.delegator = delegator;
            distribution.delegatorType = delegatorType;
            distribution.timestamp = timestamp;

            if (distributionAmount > 0 && !isDonation) {
                if (isVaultV2) {
                    uint256 activeWithdrawals = IVaultV2(vault).activeWithdrawalsAt(timestamp);
                    distribution.amountToWithdrawals = distributionAmount.mulDiv(
                        activeWithdrawals,
                        IVaultV2(vault).activeStakeAt(timestamp, distributeVaultSnapshotRewardsHints.activeSharesHint)
                            + activeWithdrawals
                    );
                    distribution.amountToDeposits = distributionAmount - distribution.amountToWithdrawals;
                } else {
                    distribution.amountToDeposits = distributionAmount;
                }
            }

            if (operatorsFees > 0) {
                distribution.operatorsFees = operatorsFees;
            }
        }

        // Donate only if needed.
        if (distributionAmount > 0 && isDonation) {
            IERC20(rewardToken).forceApprove(vault, distributionAmount);
            IVaultV2(vault).donate(distributionAmount);
        }

        emit DistributeVaultSnapshotRewards(
            network, token, vault, subnetwork.identifier(), timestamp, distributionAmount, operatorsFees
        );
    }

    /// @inheritdoc IVaultSnapshotRewards
    function claimVaultSnapshotRewards(
        address recipient,
        address network,
        address token,
        address vault,
        uint256 lastUnclaimedRewards,
        uint256 firstRewardToClaim,
        uint256 rewardsToClaim,
        bytes[] memory activeSharesHints
    ) public nonReentrant {
        if (recipient == address(0)) {
            revert InvalidRecipient();
        }

        // Check lastUnclaimedRewards vs on-chain for reorgs
        if (lastUnclaimedRewards != lastUnclaimedReward(msg.sender, vault, network, token)) {
            revert InvalidLastUnclaimedReward();
        }

        RewardDistribution[] storage rewardsByTokenNetwork =
            _vaultSnapshotRewardsStorage()._rewards[vault][network][token];

        firstRewardToClaim = firstRewardToClaim > lastUnclaimedRewards ? firstRewardToClaim : lastUnclaimedRewards;
        if (firstRewardToClaim > rewardsByTokenNetwork.length) {
            revert NoRewardsToClaim();
        }

        rewardsToClaim = Math.min(rewardsToClaim, rewardsByTokenNetwork.length - firstRewardToClaim);
        if (rewardsToClaim == 0) {
            revert NoRewardsToClaim();
        }

        if (activeSharesHints.length == 0) {
            activeSharesHints = new bytes[](rewardsToClaim);
        }

        uint256 amount;
        for (uint256 i; i < rewardsToClaim; ++i) {
            RewardDistribution storage reward;
            unchecked {
                reward = rewardsByTokenNetwork[firstRewardToClaim + i];
            }

            uint48 timestamp = reward.timestamp;
            uint256 amountToDeposits = reward.amountToDeposits;
            if (amountToDeposits > 0) {
                amount += IVaultV2(vault).activeSharesOfAt(msg.sender, timestamp, activeSharesHints[i])
                    .mulDiv(amountToDeposits, _vaultSnapshotRewardsStorage()._activeSharesCache[vault][timestamp]);
            }
            uint256 amountToWithdrawals = reward.amountToWithdrawals;
            if (amountToWithdrawals > 0) {
                amount += IVaultV2(vault).activeWithdrawalSharesOfAt(msg.sender, timestamp)
                    .mulDiv(
                        amountToWithdrawals,
                        _vaultSnapshotRewardsStorage()._activeWithdrawalSharesCache[vault][timestamp]
                    );
            }
        }

        _vaultSnapshotRewardsStorage()._lastUnclaimedReward[msg.sender][vault][network][token] =
            firstRewardToClaim + rewardsToClaim;

        if (amount > 0) {
            IERC20(token).safeTransfer(recipient, amount);
        }

        emit ClaimVaultSnapshotRewards(msg.sender, network, token, vault, amount, firstRewardToClaim, rewardsToClaim);
    }

    /// @inheritdoc IVaultSnapshotRewards
    function claimOperatorFees(
        address recipient,
        address network,
        address token,
        address vault,
        uint256 lastUnclaimedRewards,
        uint256 firstRewardToClaim,
        uint256 rewardsToClaim,
        bytes calldata extraData
    ) public nonReentrant {
        if (recipient == address(0)) {
            revert InvalidRecipient();
        }

        // Check lastUnclaimedRewards vs on-chain for reorgs
        if (lastUnclaimedRewards != lastUnclaimedOperatorReward(msg.sender, vault, network, token)) {
            revert InvalidLastUnclaimedReward();
        }

        RewardDistribution[] storage rewardsByTokenNetwork =
            _vaultSnapshotRewardsStorage()._rewards[vault][network][token];

        firstRewardToClaim = firstRewardToClaim > lastUnclaimedRewards ? firstRewardToClaim : lastUnclaimedRewards;
        if (firstRewardToClaim > rewardsByTokenNetwork.length) {
            revert NoRewardsToClaim();
        }

        rewardsToClaim = Math.min(rewardsToClaim, rewardsByTokenNetwork.length - firstRewardToClaim);
        if (rewardsToClaim == 0) {
            revert NoRewardsToClaim();
        }

        (bytes[] memory operatorNetworkSharesHints,) = extraData.length > 0
            ? abi.decode(extraData, (bytes[], bytes[]))
            : (new bytes[](rewardsToClaim), new bytes[](0));

        uint256 amount;
        uint256 networkRestakeDelegatorCounter;
        for (uint256 i; i < rewardsToClaim; ++i) {
            RewardDistribution storage reward;
            unchecked {
                reward = rewardsByTokenNetwork[firstRewardToClaim + i];
            }
            if (reward.operatorsFees > 0) {
                if (reward.delegatorType == uint64(DelegatorType.NETWORK_RESTAKE)) {
                    amount += INetworkRestakeDelegator(reward.delegator)
                        .operatorNetworkSharesAt(
                            network.subnetwork(reward.subnetworkId),
                            msg.sender,
                            reward.timestamp,
                            operatorNetworkSharesHints[networkRestakeDelegatorCounter]
                        )
                        .mulDiv(
                            reward.operatorsFees,
                            _vaultSnapshotRewardsStorage()
                            ._totalOperatorNetworkSharesCache[
                                vault
                            ][network.subnetwork(reward.subnetworkId)][reward.timestamp]
                        );
                    unchecked {
                        ++networkRestakeDelegatorCounter;
                    }
                } else if (reward.delegatorType == uint64(DelegatorType.FULL_RESTAKE)) {
                    revert InvalidDelegatorType();
                } else if (reward.delegatorType == uint64(DelegatorType.OPERATOR_SPECIFIC)) {
                    if (IOperatorSpecificDelegator(reward.delegator).operator() != msg.sender) {
                        revert NotOperator();
                    }
                    amount += reward.operatorsFees;
                } else if (reward.delegatorType == uint64(DelegatorType.OPERATOR_NETWORK_SPECIFIC)) {
                    if (IOperatorNetworkSpecificDelegator(reward.delegator).operator() != msg.sender) {
                        revert NotOperator();
                    }
                    amount += reward.operatorsFees;
                } else {
                    amount += IUniversalDelegator(reward.delegator)
                        .getAllocatedAt(network.subnetwork(reward.subnetworkId), msg.sender, 0, reward.timestamp)
                        .mulDiv(
                            reward.operatorsFees,
                            _vaultSnapshotRewardsStorage()
                            ._subnetworkFilledCache[vault][network.subnetwork(reward.subnetworkId)][reward.timestamp]
                        );
                }
            }
        }

        _vaultSnapshotRewardsStorage()._lastUnclaimedOperatorReward[msg.sender][vault][network][token] =
            firstRewardToClaim + rewardsToClaim;

        if (amount > 0) {
            IERC20(token).safeTransfer(recipient, amount);
        }

        emit ClaimOperatorFees(msg.sender, network, token, vault, amount, firstRewardToClaim, rewardsToClaim);
    }

    /// @inheritdoc IRewardsBase
    function claimRewards(address recipient, address token, bytes calldata data) public virtual {
        (
            address network,
            address vault,
            uint256 lastUnclaimedRewards,
            uint256 firstRewardToClaim,
            uint256 maxRewards,
            bytes[] memory activeSharesOfHints
        ) = abi.decode(data, (address, address, uint256, uint256, uint256, bytes[]));
        claimVaultSnapshotRewards(
            recipient, network, token, vault, lastUnclaimedRewards, firstRewardToClaim, maxRewards, activeSharesOfHints
        );
    }
}
