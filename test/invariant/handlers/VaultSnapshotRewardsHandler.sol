// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SymbioticCoreInit} from "@symbioticfi/core/test/integration/SymbioticCoreInit.sol";
import {VaultSnapshotRewards} from "../../../src/contracts/VaultSnapshotRewards.sol";
import {CuratorFees} from "../../../src/contracts/CuratorFees.sol";
import {ProtocolFees} from "../../../src/contracts/ProtocolFees.sol";
import {CuratorRegistry} from "../../../src/contracts/CuratorRegistry.sol";
import {FeeRegistry} from "../../../src/contracts/FeeRegistry.sol";
import {RewardsV2TestBase} from "../../RewardsV2TestBase.sol";
import {Token} from "@symbioticfi/core/test/mocks/Token.sol";
import {Subnetwork} from "@symbioticfi/core/src/contracts/libraries/Subnetwork.sol";
import {IVault} from "@symbioticfi/core/src/interfaces/vault/IVault.sol";
import {IVaultTokenized} from "@symbioticfi/core/src/interfaces/vault/IVaultTokenized.sol";
import {IVaultConfigurator} from "@symbioticfi/core/src/interfaces/IVaultConfigurator.sol";
import {IBaseDelegator} from "@symbioticfi/core/src/interfaces/delegator/IBaseDelegator.sol";
import {INetworkRestakeDelegator} from "@symbioticfi/core/src/interfaces/delegator/INetworkRestakeDelegator.sol";
import {IRewards} from "../../../src/interfaces/IRewards.sol";
import {VAULT_V2_VERSION} from "../../../src/interfaces/IVaultV2.sol";
import {IVaultSnapshotRewards} from "../../../src/interfaces/IVaultSnapshotRewards.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract TestableVaultSnapshotRewards is VaultSnapshotRewards {
    constructor(
        address vaultFactory,
        address networkRegistry,
        address networkMiddlewareService,
        address curatorRegistry,
        address feeRegistry
    )
        VaultSnapshotRewards(vaultFactory, networkRegistry, networkMiddlewareService)
        CuratorFees(curatorRegistry)
        ProtocolFees(feeRegistry)
    {}

    function initialize(address owner) external initializer {
        __ProtocolFees_init(owner);
    }
}

contract VaultSnapshotRewardsHandler is RewardsV2TestBase {
    uint256 public constant MAX_DEPOSIT_AMOUNT = 100_000 * 10 ** 18;
    uint256 public constant INITIAL_STAKE_AMOUNT = 1000 * 10 ** 18;
    uint96 public constant SUBNETWORK_ID = 1;
    string public constant REWARDS_FEE_ID = "rewards";

    uint256 public totalDepositedAmount;
    uint256 public totalReceivedAmount;
    uint256 public totalRewardsClaimedAmount;
    uint256 public totalFeesClaimedAmount;
    uint256 public totalCuratorFeesClaimedAmount;
    uint256 public totalOperatorFeesClaimedAmount;
    uint256 public totalProtocolFeesClaimedAmount;
    uint256 public totalProtocolFeesAccrued;
    uint256 public totalCuratorFeesAccrued;
    uint256 public totalOperatorFeesAccrued;
    uint256 public totalNetRewardsAccrued;
    uint256 public totalDonatedAmount;

    TestableVaultSnapshotRewards public vaultSnapshotRewards;
    IVault public vault;
    INetworkRestakeDelegator public networkRestakeDelegator;

    address public network;
    address public curator;
    address public middleware;
    bytes32 public subnetwork;
    uint64 public vaultVersion;
    uint48 public lastStakeTimestamp;

    address[] public stakers;
    address[] public operators;
    mapping(address => uint256) internal trackedStakerCursors;
    mapping(address => uint256) internal trackedOperatorCursors;

    modifier adjustTimestamp(uint256 timeJumpSeed) {
        uint256 timeJump = _bound(timeJumpSeed, 2 minutes, 1 days);
        vm.warp(block.timestamp + timeJump);
        _;
    }

    constructor() {
        _initialize();
    }

    function stakeTokens(uint256 seed) public adjustTimestamp(seed) {
        if (address(vault) == address(0)) {
            return;
        }

        uint256 amount = _bound(seed, 1 * 10 ** 18, INITIAL_STAKE_AMOUNT * 5);
        address staker;
        bool createNew = stakers.length == 0 || seed % 5 == 0;

        if (createNew) {
            staker = _randomAddress("extra-staker", stakers.length + seed % uint256(type(uint160).max));
            stakers.push(staker);
        } else {
            staker = stakers[seed % stakers.length];
        }

        _stake(staker, amount);
    }

    function claim(uint256 seed) public adjustTimestamp(seed) {
        if (stakers.length == 0) {
            return;
        }

        address staker = stakers[seed % stakers.length];
        uint256 balanceBefore = rewardsToken.balanceOf(staker);
        uint256 lastUnclaimed =
            vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken));
        assertEq(lastUnclaimed, trackedStakerCursors[staker]);
        uint256 rewardCount = vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken));
        if (lastUnclaimed >= rewardCount) {
            return;
        }

        uint256 remainingRewards = rewardCount - lastUnclaimed;
        uint256 rewardsToClaim = _bound(seed, 1, remainingRewards);
        uint256 expectedCursor = lastUnclaimed + rewardsToClaim;

        vm.startPrank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            staker,
            network,
            address(rewardsToken),
            address(vault),
            lastUnclaimed,
            lastUnclaimed,
            rewardsToClaim,
            new bytes[](0)
        );
        vm.stopPrank();

        totalRewardsClaimedAmount += rewardsToken.balanceOf(staker) - balanceBefore;
        assertEq(
            vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken)),
            expectedCursor
        );
        trackedStakerCursors[staker] = expectedCursor;
    }

    function distributeRewards(uint256 seed) public adjustTimestamp(seed) {
        uint256 amount = _bound(seed, 1 * 10 ** 18, MAX_DEPOSIT_AMOUNT);
        address distributor = seed % 2 == 0 ? network : middleware;
        _ensureBalance(distributor, amount);

        uint256 distributorBalanceBefore = rewardsToken.balanceOf(distributor);
        uint256 balanceBefore = rewardsToken.balanceOf(address(vaultSnapshotRewards));
        uint256 protocolFeesBefore = vaultSnapshotRewards.protocolFees(address(rewardsToken));
        uint256 curatorFeesBefore = vaultSnapshotRewards.curatorFees(address(vault), address(rewardsToken));
        uint256 rewardsLengthBefore = vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken));
        vm.prank(distributor);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), amount, lastStakeTimestamp, _distributionHints()
        );
        uint256 balanceAfter = rewardsToken.balanceOf(address(vaultSnapshotRewards));
        if (balanceAfter > balanceBefore) {
            totalDepositedAmount += balanceAfter - balanceBefore;
        }
        _trackDistributionAccounting(
            distributorBalanceBefore - rewardsToken.balanceOf(distributor),
            protocolFeesBefore,
            curatorFeesBefore,
            rewardsLengthBefore
        );
    }

    function donateRewards(uint256 seed) public adjustTimestamp(seed) {
        if (vaultVersion < VAULT_V2_VERSION) {
            return;
        }

        uint256 amount = _bound(seed, 1 * 10 ** 18, MAX_DEPOSIT_AMOUNT);
        address distributor = seed % 2 == 0 ? network : middleware;
        _ensureBalance(distributor, amount);

        uint256 distributorBalanceBefore = rewardsToken.balanceOf(distributor);
        uint256 balanceBefore = rewardsToken.balanceOf(address(vaultSnapshotRewards));
        uint256 protocolFeesBefore = vaultSnapshotRewards.protocolFees(address(rewardsToken));
        uint256 curatorFeesBefore = vaultSnapshotRewards.curatorFees(address(vault), address(rewardsToken));
        uint256 rewardsLengthBefore = vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken));
        vm.prank(distributor);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(0), address(vault), amount, lastStakeTimestamp, _distributionHints()
        );
        uint256 balanceAfter = rewardsToken.balanceOf(address(vaultSnapshotRewards));
        if (balanceAfter > balanceBefore) {
            totalDepositedAmount += balanceAfter - balanceBefore;
        }
        _trackDistributionAccounting(
            distributorBalanceBefore - rewardsToken.balanceOf(distributor),
            protocolFeesBefore,
            curatorFeesBefore,
            rewardsLengthBefore
        );
    }

    function staleClaimAttempt(uint256 seed) public adjustTimestamp(seed) {
        if (stakers.length == 0) {
            return;
        }

        address staker = stakers[seed % stakers.length];
        uint256 lastUnclaimed =
            vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken));
        uint256 wrongLastUnclaimed = lastUnclaimed + 1;
        uint256 trackedBefore = trackedStakerCursors[staker];

        vm.startPrank(staker);
        try vaultSnapshotRewards.claimVaultSnapshotRewards(
            staker, network, address(rewardsToken), address(vault), wrongLastUnclaimed, 0, 1, new bytes[](0)
        ) {
            revert("stale claim should revert");
        } catch {}
        vm.stopPrank();

        assertEq(
            vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken)),
            lastUnclaimed
        );
        assertEq(trackedStakerCursors[staker], trackedBefore);
    }

    function claimCuratorFees(uint256 seed) public adjustTimestamp(seed) {
        uint256 balanceBefore = rewardsToken.balanceOf(curator);

        vm.startPrank(curator);
        vaultSnapshotRewards.claimCuratorFees(curator, address(vault), address(rewardsToken));
        vm.stopPrank();

        uint256 claimedAmount = rewardsToken.balanceOf(curator) - balanceBefore;
        totalFeesClaimedAmount += claimedAmount;
        totalCuratorFeesClaimedAmount += claimedAmount;
    }

    function claimOperatorFees(uint256 seed) public adjustTimestamp(seed) {
        address operator = operators[seed % operators.length];
        uint256 balanceBefore = rewardsToken.balanceOf(operator);
        uint256 lastUnclaimed =
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(rewardsToken));
        assertEq(lastUnclaimed, trackedOperatorCursors[operator]);
        uint256 rewardCount = vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken));
        if (lastUnclaimed >= rewardCount) {
            return;
        }

        uint256 remainingRewards = rewardCount - lastUnclaimed;
        uint256 rewardsToClaim = _bound(seed, 1, remainingRewards);
        uint256 expectedCursor = lastUnclaimed + rewardsToClaim;

        vm.startPrank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            operator,
            network,
            address(rewardsToken),
            address(vault),
            lastUnclaimed,
            lastUnclaimed,
            rewardsToClaim,
            new bytes(0)
        );
        vm.stopPrank();

        uint256 claimedAmount = rewardsToken.balanceOf(operator) - balanceBefore;
        totalFeesClaimedAmount += claimedAmount;
        totalOperatorFeesClaimedAmount += claimedAmount;
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(rewardsToken)),
            expectedCursor
        );
        trackedOperatorCursors[operator] = expectedCursor;
    }

    function staleOperatorClaimAttempt(uint256 seed) public adjustTimestamp(seed) {
        address operator = operators[seed % operators.length];
        uint256 lastUnclaimed =
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(rewardsToken));
        uint256 wrongLastUnclaimed = lastUnclaimed + 1;
        uint256 trackedBefore = trackedOperatorCursors[operator];

        vm.startPrank(operator);
        try vaultSnapshotRewards.claimOperatorFees(
            operator, network, address(rewardsToken), address(vault), wrongLastUnclaimed, 0, 1, new bytes(0)
        ) {
            revert("stale operator claim should revert");
        } catch {}
        vm.stopPrank();

        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(rewardsToken)),
            lastUnclaimed
        );
        assertEq(trackedOperatorCursors[operator], trackedBefore);
    }

    function claimProtocolFees(uint256 seed) public adjustTimestamp(seed) {
        uint256 balanceBefore = rewardsToken.balanceOf(address(this));
        vaultSnapshotRewards.claimProtocolFees(address(this), address(rewardsToken));
        uint256 claimedAmount = rewardsToken.balanceOf(address(this)) - balanceBefore;
        totalFeesClaimedAmount += claimedAmount;
        totalProtocolFeesClaimedAmount += claimedAmount;
    }

    function stakersLength() external view returns (uint256) {
        return stakers.length;
    }

    function stakerAt(uint256 index) external view returns (address) {
        return stakers[index];
    }

    function operatorsLength() external view returns (uint256) {
        return operators.length;
    }

    function operatorAt(uint256 index) external view returns (address) {
        return operators[index];
    }

    function trackedStakerCursor(address staker) external view returns (uint256) {
        return trackedStakerCursors[staker];
    }

    function trackedOperatorCursor(address operator) external view returns (uint256) {
        return trackedOperatorCursors[operator];
    }

    function _initialize() internal {
        vm.warp(1000 days);
        _deployRewardsInfra(address(this));

        network = makeAddr("network");
        curator = makeAddr("curator");
        middleware = makeAddr("middleware");

        vaultSnapshotRewards = new TestableVaultSnapshotRewards(
            address(symbioticCore.vaultFactory),
            address(symbioticCore.networkRegistry),
            address(symbioticCore.networkMiddlewareService),
            address(curatorRegistry),
            address(feeRegistry)
        );
        vaultSnapshotRewards = TestableVaultSnapshotRewards(
            address(
                new TransparentUpgradeableProxy(
                    address(vaultSnapshotRewards),
                    address(this),
                    abi.encodeCall(TestableVaultSnapshotRewards.initialize, (address(this)))
                )
            )
        );

        vm.prank(network);
        symbioticCore.networkRegistry.registerNetwork();

        vm.prank(network);
        symbioticCore.networkMiddlewareService.setMiddleware(middleware);

        vaultVersion = symbioticCore.vaultFactory.lastVersion();
        if (vaultVersion >= VAULT_V2_VERSION) {
            vaultVersion = VAULT_V2_VERSION - 1;
        }
        (vault, networkRestakeDelegator) = _createNetworkRestakeVault();

        curatorRegistry.setCurator(address(vault), curator);
        vm.startPrank(curator);
        feeRegistry.setCuratorFee(address(vault), 50_000);
        feeRegistry.setOperatorsFee(address(vault), 30_000);
        vm.stopPrank();

        vm.prank(address(this));
        feeRegistry.setProtocolFee(
            keccak256(abi.encode(REWARDS_FEE_ID, uint64(IRewards.RewardsType.VAULT_SNAPSHOT), network)), true, 10_000
        );

        subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(network);
        networkRestakeDelegator.setMaxNetworkLimit(SUBNETWORK_ID, 1_000_000 * 10 ** 18);
        vm.prank(network);
        networkRestakeDelegator.setNetworkLimit(subnetwork, 1_000_000 * 10 ** 18);

        _createRandomOperators(10);
        _createRandomStakers(10);

        _ensureBalance(network, MAX_DEPOSIT_AMOUNT * 100);
        _ensureBalance(middleware, MAX_DEPOSIT_AMOUNT * 100);

        vm.prank(network);
        rewardsToken.approve(address(vaultSnapshotRewards), type(uint256).max);
        vm.prank(middleware);
        rewardsToken.approve(address(vaultSnapshotRewards), type(uint256).max);
    }

    function _createRandomStakers(uint256 count) internal {
        for (uint256 i; i < count; ++i) {
            address staker = _randomAddress("staker", i);
            stakers.push(staker);
            _stake(staker, INITIAL_STAKE_AMOUNT + i * 100 * 10 ** 18);
        }
    }

    function _createRandomOperators(uint256 count) internal {
        for (uint256 i; i < count; ++i) {
            address operator = _randomAddress("operator", i);
            operators.push(operator);

            vm.prank(operator);
            symbioticCore.operatorRegistry.registerOperator();

            vm.prank(operator);
            symbioticCore.operatorVaultOptInService.optIn(address(vault));

            vm.prank(operator);
            symbioticCore.operatorNetworkOptInService.optIn(network);

            vm.prank(network);
            networkRestakeDelegator.setOperatorNetworkShares(subnetwork, operator, (i + 1) * 1_000_000);
        }
    }

    function _createNetworkRestakeVault() internal returns (IVault vault_, INetworkRestakeDelegator delegator_) {
        (address vaultAddr, address delegatorAddr,) = symbioticCore.vaultConfigurator
            .create(
                IVaultConfigurator.InitParams({
                    version: vaultVersion,
                    owner: address(this),
                    vaultParams: _vaultParams(),
                    delegatorIndex: 0,
                    delegatorParams: abi.encode(
                        INetworkRestakeDelegator.InitParams({
                            baseParams: IBaseDelegator.BaseParams({
                                defaultAdminRoleHolder: address(this),
                                hook: address(0),
                                hookSetRoleHolder: address(this)
                            }),
                            networkLimitSetRoleHolders: _toSingletonArray(network),
                            operatorNetworkSharesSetRoleHolders: _toSingletonArray(network)
                        })
                    ),
                    withSlasher: false,
                    slasherIndex: 0,
                    slasherParams: ""
                })
            );

        vault_ = IVault(vaultAddr);
        delegator_ = INetworkRestakeDelegator(delegatorAddr);
    }

    function _vaultInitParams() internal view returns (IVault.InitParams memory) {
        return IVault.InitParams({
            collateral: address(rewardsToken),
            burner: address(0xdEaD),
            epochDuration: 7 days,
            depositWhitelist: false,
            isDepositLimit: false,
            depositLimit: 0,
            defaultAdminRoleHolder: address(this),
            depositWhitelistSetRoleHolder: address(this),
            depositorWhitelistRoleHolder: address(this),
            isDepositLimitSetRoleHolder: address(this),
            depositLimitSetRoleHolder: address(this)
        });
    }

    function _vaultParams() internal view returns (bytes memory) {
        IVault.InitParams memory baseParams = _vaultInitParams();
        if (vaultVersion <= 1) {
            return abi.encode(baseParams);
        }
        return abi.encode(
            IVaultTokenized.InitParamsTokenized({baseParams: baseParams, name: "VaultSnapshotRewards", symbol: "VSR"})
        );
    }

    function _stake(address staker, uint256 amount) internal {
        if (amount == 0) {
            return;
        }
        _ensureBalance(staker, amount);
        vm.startPrank(staker);
        rewardsToken.approve(address(vault), type(uint256).max);
        vault.deposit(staker, amount);
        vm.stopPrank();
        vm.warp(block.timestamp + 1);
        lastStakeTimestamp = uint48(block.timestamp);
    }

    function _ensureBalance(address account, uint256 amount) internal {
        uint256 balance = rewardsToken.balanceOf(account);
        if (balance < amount) {
            deal(address(rewardsToken), account, amount, true);
        }
    }

    function _randomAddress(string memory prefix, uint256 index) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encodePacked(prefix, index)))));
    }

    function _toSingletonArray(address value) internal pure returns (address[] memory array) {
        array = new address[](1);
        array[0] = value;
    }

    function _distributionHints() internal pure returns (bytes memory) {
        return abi.encode(new bytes(0), new bytes(0), new bytes(0), new bytes(0), new bytes(0));
    }

    function _trackDistributionAccounting(
        uint256 actualReceivedAmount,
        uint256 protocolFeesBefore,
        uint256 curatorFeesBefore,
        uint256 rewardsLengthBefore
    ) internal {
        totalReceivedAmount += actualReceivedAmount;

        uint256 protocolFeesDelta = vaultSnapshotRewards.protocolFees(address(rewardsToken)) - protocolFeesBefore;
        uint256 curatorFeesDelta =
            vaultSnapshotRewards.curatorFees(address(vault), address(rewardsToken)) - curatorFeesBefore;
        uint256 rewardsLengthAfter = vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken));

        totalProtocolFeesAccrued += protocolFeesDelta;
        totalCuratorFeesAccrued += curatorFeesDelta;

        uint256 operatorsFees;
        uint256 netRewards;
        if (rewardsLengthAfter > rewardsLengthBefore) {
            IVaultSnapshotRewards.RewardDistribution memory reward =
                vaultSnapshotRewards.rewards(address(vault), network, address(rewardsToken), rewardsLengthAfter - 1);
            operatorsFees = reward.operatorsFees;
            netRewards = reward.amountToDeposits + reward.amountToWithdrawals;
        }

        totalOperatorFeesAccrued += operatorsFees;
        totalNetRewardsAccrued += netRewards;
        totalDonatedAmount += actualReceivedAmount - protocolFeesDelta - curatorFeesDelta - operatorsFees - netRewards;
    }
}
