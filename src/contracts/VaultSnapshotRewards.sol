// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import {ProtocolFees} from "./ProtocolFees.sol";

import {ICuratorRegistry} from "../interfaces/ICuratorRegistry.sol";
import {IFeeRegistry} from "../interfaces/IFeeRegistry.sol";
import {IProtocolFees} from "../interfaces/IProtocolFees.sol";
import {IRewardsBase} from "../interfaces/IRewardsBase.sol";
import {IRewards} from "../interfaces/IRewards.sol";
import {IVaultSnapshotRewards} from "../interfaces/IVaultSnapshotRewards.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {ReentrancyGuardTransient} from "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IBaseDelegator} from "@symbioticfi/core/src/interfaces/delegator/IBaseDelegator.sol";
import {INetworkMiddlewareService} from "@symbioticfi/core/src/interfaces/service/INetworkMiddlewareService.sol";
import {INetworkRestakeDelegator} from "@symbioticfi/core/src/interfaces/delegator/INetworkRestakeDelegator.sol";
import {
    IOperatorNetworkSpecificDelegator
} from "@symbioticfi/core/src/interfaces/delegator/IOperatorNetworkSpecificDelegator.sol";
import {IOperatorSpecificDelegator} from "@symbioticfi/core/src/interfaces/delegator/IOperatorSpecificDelegator.sol";
import {IRegistry} from "@symbioticfi/core/src/interfaces/common/IRegistry.sol";
import {IVault} from "@symbioticfi/core/src/interfaces/vault/IVault.sol";
import {Subnetwork} from "@symbioticfi/core/src/contracts/libraries/Subnetwork.sol";

/// @title VaultSnapshotRewards
/// @notice Contract for managing vault snapshot-based rewards distributions.
/// @dev The protocol fee is deducted from the distribution amount.
abstract contract VaultSnapshotRewards is ProtocolFees, ReentrancyGuardTransient, IVaultSnapshotRewards {
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

    /// @inheritdoc IVaultSnapshotRewards
    address public immutable CURATOR_REGISTRY;

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
        mapping(address vault => mapping(address token => uint256 fee)) _curatorFees;
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

    constructor(
        address vaultFactory,
        address networkRegistry,
        address networkMiddlewareService,
        address curatorRegistry
    ) {
        VAULT_FACTORY = vaultFactory;
        NETWORK_REGISTRY = networkRegistry;
        NETWORK_MIDDLEWARE_SERVICE = networkMiddlewareService;
        CURATOR_REGISTRY = curatorRegistry;
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
    function curatorFees(address vault, address token) public view returns (uint256) {
        return _vaultSnapshotRewardsStorage()._curatorFees[vault][token];
    }

    /// @inheritdoc IVaultSnapshotRewards
    function distributeVaultSnapshotRewards(
        bytes32 subnetwork,
        address token,
        address vault,
        uint256 amount,
        uint48 timestamp,
        DistributeVaultSnapshotRewardsHints calldata hints
    ) public nonReentrant {
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

        if (_vaultSnapshotRewardsStorage()._activeSharesCache[vault][timestamp] == 0) {
            uint256 activeShares = IVault(vault).activeSharesAt(timestamp, hints.activeSharesHint);
            if (activeShares == 0) {
                revert InvalidRewardTimestamp();
            }

            _vaultSnapshotRewardsStorage()._activeSharesCache[vault][timestamp] = activeShares;
        }

        uint256 balanceBefore = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        amount = IERC20(token).balanceOf(address(this)) - balanceBefore;

        if (amount == 0) {
            revert InsufficientReward();
        }

        uint256 distributionAmount =
            _subProtocolFeesFromTotal(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), network, token, amount);
        uint256 curatorFees = distributionAmount.mulDiv(
            IFeeRegistry(FEE_REGISTRY).getCuratorFeeAt(vault, network, timestamp, hints.curatorFeeHint), MAX_FEE
        );
        uint256 operatorsFees = distributionAmount.mulDiv(
            IFeeRegistry(FEE_REGISTRY).getOperatorsFeeAt(vault, network, timestamp, hints.operatorsFeeHint), MAX_FEE
        );

        distributionAmount -= curatorFees + operatorsFees;

        _vaultSnapshotRewardsStorage()._curatorFees[vault][token] += curatorFees;

        _vaultSnapshotRewardsStorage()
        ._rewards[vault][network][token].push(
            RewardDistribution({
                subnetworkId: subnetwork.identifier(),
                delegator: IVault(vault).delegator(),
                delegatorType: IBaseDelegator(IVault(vault).delegator()).TYPE(),
                timestamp: timestamp,
                amount: distributionAmount,
                operatorsFees: operatorsFees
            })
        );

        emit DistributeVaultSnapshotRewards(
            network, token, vault, subnetwork.identifier(), timestamp, distributionAmount, curatorFees, operatorsFees
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

            amount += IVault(vault).activeSharesOfAt(msg.sender, reward.timestamp, activeSharesHints[i])
                .mulDiv(reward.amount, _vaultSnapshotRewardsStorage()._activeSharesCache[vault][reward.timestamp]);
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

        (bytes[] memory operatorNetworkSharesHints, bytes[] memory totalOperatorNetworkSharesHint) = extraData.length
            > 0
            ? abi.decode(extraData, (bytes[], bytes[]))
            : (new bytes[](rewardsToClaim), new bytes[](rewardsToClaim));

        uint256 amount;
        uint256 networkRestakeDelegatorCounter;
        for (uint256 i; i < rewardsToClaim; ++i) {
            RewardDistribution storage reward;
            unchecked {
                reward = rewardsByTokenNetwork[firstRewardToClaim + i];
            }
            bytes32 subnetwork = network.subnetwork(reward.subnetworkId);
            if (reward.delegatorType == 0) {
                uint256 totalOperatorNetworkShares = INetworkRestakeDelegator(reward.delegator)
                    .totalOperatorNetworkSharesAt(
                        subnetwork, reward.timestamp, totalOperatorNetworkSharesHint[networkRestakeDelegatorCounter]
                    );
                if (totalOperatorNetworkShares > 0) {
                    amount += INetworkRestakeDelegator(reward.delegator)
                        .operatorNetworkSharesAt(
                            subnetwork,
                            msg.sender,
                            reward.timestamp,
                            operatorNetworkSharesHints[networkRestakeDelegatorCounter]
                        ).mulDiv(reward.operatorsFees, totalOperatorNetworkShares);
                }
                unchecked {
                    ++networkRestakeDelegatorCounter;
                }
            } else if (reward.delegatorType == 1) {
                // pass
            } else if (reward.delegatorType == 2) {
                if (IOperatorSpecificDelegator(reward.delegator).operator() != msg.sender) {
                    revert NotOperator();
                }
                amount += reward.operatorsFees;
            } else if (reward.delegatorType == 3) {
                if (IOperatorNetworkSpecificDelegator(reward.delegator).operator() != msg.sender) {
                    revert NotOperator();
                }
                amount += reward.operatorsFees;
            } else {
                revert InvalidDelegatorType();
            }
        }

        _vaultSnapshotRewardsStorage()._lastUnclaimedOperatorReward[msg.sender][vault][network][token] =
            firstRewardToClaim + rewardsToClaim;

        if (amount > 0) {
            IERC20(token).safeTransfer(recipient, amount);
        }

        emit ClaimOperatorFees(msg.sender, network, token, vault, amount, firstRewardToClaim, rewardsToClaim);
    }

    /// @inheritdoc IVaultSnapshotRewards
    function claimCuratorFees(address recipient, address vault, address token) public nonReentrant {
        if (ICuratorRegistry(CURATOR_REGISTRY).getCurator(vault) != msg.sender) {
            revert NotCurator();
        }

        uint256 claimableFee = curatorFees(vault, token);
        if (claimableFee == 0) {
            revert NoRewardsToClaim();
        }

        _vaultSnapshotRewardsStorage()._curatorFees[vault][token] = 0;
        IERC20(token).safeTransfer(recipient, claimableFee);

        emit ClaimCuratorFees(vault, token, claimableFee);
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
