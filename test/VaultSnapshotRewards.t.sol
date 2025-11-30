// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {RewardsV2TestBase} from "./RewardsV2TestBase.sol";
import {VaultSnapshotRewards} from "../src/contracts/VaultSnapshotRewards.sol";
import {CuratorRegistry} from "../src/contracts/CuratorRegistry.sol";
import {FeeRegistry} from "../src/contracts/FeeRegistry.sol";
import {ProtocolFees} from "../src/contracts/ProtocolFees.sol";
import {IVaultSnapshotRewards} from "../src/interfaces/IVaultSnapshotRewards.sol";

import {Subnetwork} from "@symbioticfi/core/src/contracts/libraries/Subnetwork.sol";
import {IVault} from "@symbioticfi/core/src/interfaces/vault/IVault.sol";
import {IVaultConfigurator} from "@symbioticfi/core/src/interfaces/IVaultConfigurator.sol";
import {IVaultTokenized} from "@symbioticfi/core/src/interfaces/vault/IVaultTokenized.sol";
import {IBaseDelegator} from "@symbioticfi/core/src/interfaces/delegator/IBaseDelegator.sol";
import {INetworkRestakeDelegator} from "@symbioticfi/core/src/interfaces/delegator/INetworkRestakeDelegator.sol";
import {
    IOperatorNetworkSpecificDelegator
} from "@symbioticfi/core/src/interfaces/delegator/IOperatorNetworkSpecificDelegator.sol";
import {IOperatorSpecificDelegator} from "@symbioticfi/core/src/interfaces/delegator/IOperatorSpecificDelegator.sol";
import {IFullRestakeDelegator} from "@symbioticfi/core/src/interfaces/delegator/IFullRestakeDelegator.sol";

/// @title TestableVaultSnapshotRewards
/// @notice Contract for testing the VaultSnapshotRewards logic.
contract TestableVaultSnapshotRewards is VaultSnapshotRewards {
    constructor(
        address vaultFactory,
        address networkRegistry,
        address networkMiddlewareService,
        address curatorRegistry,
        address feeRegistry
    )
        VaultSnapshotRewards(vaultFactory, networkRegistry, networkMiddlewareService, curatorRegistry)
        ProtocolFees(feeRegistry)
    {}
}

contract VaultSnapshotRewardsTest is RewardsV2TestBase {
    TestableVaultSnapshotRewards vaultSnapshotRewards;
    IVault vault;
    IVault operatorSpecificVault;
    IVault operatorNetworkVault;
    IVault invalidDelegatorVault;
    INetworkRestakeDelegator networkRestakeDelegator;
    IOperatorSpecificDelegator operatorSpecificDelegator;
    IOperatorNetworkSpecificDelegator operatorNetworkSpecificDelegator;
    IFullRestakeDelegator fullRestakeDelegator;

    address network = makeAddr("network");
    address curator = makeAddr("curator");
    address staker = makeAddr("staker");
    address operator = makeAddr("operator");
    address otherOperator = makeAddr("otherOperator");
    address recipient = makeAddr("recipient");
    address middleware = makeAddr("middleware");

    // Test constants
    uint256 constant REWARD_AMOUNT = 1000 * 10 ** 18;
    uint48 TIMESTAMP;
    uint96 constant SUBNETWORK_ID = 0x123;
    uint64 constant NETWORK_RESTAKE_TYPE = 0;
    uint64 constant FULL_RESTAKE_TYPE = 1;
    uint64 constant OPERATOR_SPECIFIC_TYPE = 2;
    uint64 constant OPERATOR_NETWORK_SPECIFIC_TYPE = 3;
    string constant TOKENIZED_VAULT_NAME = "VaultSnapshotRewards";
    string constant TOKENIZED_VAULT_SYMBOL = "VSR";
    uint64 vaultVersion;

    function setUp() public override {
        _deployRewardsInfra(address(this));

        vaultVersion = symbioticCore.vaultFactory.lastVersion();

        uint256 allocation = 150_000 * 10 ** 18;
        rewardsToken.transfer(network, allocation);
        rewardsToken.transfer(middleware, allocation);
        rewardsToken.transfer(staker, allocation);
        rewardsToken.transfer(curator, allocation);
        rewardsToken.transfer(operator, allocation);
        rewardsToken.transfer(otherOperator, allocation);

        vm.prank(network);
        symbioticCore.networkRegistry.registerNetwork();
        vm.prank(operator);
        symbioticCore.operatorRegistry.registerOperator();
        vm.prank(otherOperator);
        symbioticCore.operatorRegistry.registerOperator();

        (vault, networkRestakeDelegator) = _createNetworkRestakeVault();
        (operatorSpecificVault, operatorSpecificDelegator) = _createOperatorSpecificVault(operator);
        (operatorNetworkVault, operatorNetworkSpecificDelegator) = _createOperatorNetworkVault(operator);
        (invalidDelegatorVault, fullRestakeDelegator) = _createFullRestakeVault();

        _configureCuratorAndFees(address(vault));
        _configureCuratorAndFees(address(operatorSpecificVault));
        _configureCuratorAndFees(address(operatorNetworkVault));
        _configureCuratorAndFees(address(invalidDelegatorVault));

        vm.prank(operator);
        symbioticCore.operatorVaultOptInService.optIn(address(vault));
        vm.prank(otherOperator);
        symbioticCore.operatorVaultOptInService.optIn(address(vault));
        vm.prank(operator);
        symbioticCore.operatorVaultOptInService.optIn(address(operatorSpecificVault));
        vm.prank(operator);
        symbioticCore.operatorVaultOptInService.optIn(address(operatorNetworkVault));

        vm.prank(operator);
        symbioticCore.operatorNetworkOptInService.optIn(network);
        vm.prank(otherOperator);
        symbioticCore.operatorNetworkOptInService.optIn(network);

        TIMESTAMP = uint48(block.timestamp + 10);
        vm.warp(TIMESTAMP);

        _deposit(address(vault), staker, 100 * 10 ** 18);
        _deposit(address(vault), curator, 900 * 10 ** 18);
        _deposit(address(operatorSpecificVault), curator, 1000 * 10 ** 18);
        _deposit(address(operatorNetworkVault), curator, 1000 * 10 ** 18);
        _deposit(address(invalidDelegatorVault), curator, 1000 * 10 ** 18);

        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.startPrank(network);
        networkRestakeDelegator.setMaxNetworkLimit(SUBNETWORK_ID, 1000 * 10 ** 18);
        networkRestakeDelegator.setNetworkLimit(subnetwork, 1000 * 10 ** 18);
        networkRestakeDelegator.setOperatorNetworkShares(subnetwork, operator, 50 * 10 ** 18);
        networkRestakeDelegator.setOperatorNetworkShares(subnetwork, otherOperator, 150 * 10 ** 18);

        operatorSpecificDelegator.setMaxNetworkLimit(SUBNETWORK_ID, 1000 * 10 ** 18);
        operatorSpecificDelegator.setNetworkLimit(subnetwork, 1000 * 10 ** 18);

        operatorNetworkSpecificDelegator.setMaxNetworkLimit(SUBNETWORK_ID, 1000 * 10 ** 18);

        symbioticCore.networkMiddlewareService.setMiddleware(middleware);
        vm.stopPrank();

        vm.warp(TIMESTAMP + 1);

        vaultSnapshotRewards = new TestableVaultSnapshotRewards(
            address(symbioticCore.vaultFactory),
            address(symbioticCore.networkRegistry),
            address(symbioticCore.networkMiddlewareService),
            address(curatorRegistry),
            address(feeRegistry)
        );

        vm.prank(network);
        rewardsToken.approve(address(vaultSnapshotRewards), type(uint256).max);

        vm.prank(middleware);
        rewardsToken.approve(address(vaultSnapshotRewards), type(uint256).max);
    }

    function _baseParams() internal view returns (IBaseDelegator.BaseParams memory) {
        return IBaseDelegator.BaseParams({
            defaultAdminRoleHolder: address(this), hook: address(0), hookSetRoleHolder: address(this)
        });
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
            IVaultTokenized.InitParamsTokenized({
                baseParams: baseParams, name: TOKENIZED_VAULT_NAME, symbol: TOKENIZED_VAULT_SYMBOL
            })
        );
    }

    function _toSingletonArray(address value) internal pure returns (address[] memory array) {
        array = new address[](1);
        array[0] = value;
    }

    function _createNetworkRestakeVault() internal returns (IVault vault_, INetworkRestakeDelegator delegator_) {
        (address vaultAddr, address delegatorAddr,) = symbioticCore.vaultConfigurator
            .create(
                IVaultConfigurator.InitParams({
                    version: vaultVersion,
                    owner: address(this),
                    vaultParams: _vaultParams(),
                    delegatorIndex: NETWORK_RESTAKE_TYPE,
                    delegatorParams: abi.encode(
                        INetworkRestakeDelegator.InitParams({
                            baseParams: _baseParams(),
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

    function _createOperatorSpecificVault(address operator_)
        internal
        returns (IVault vault_, IOperatorSpecificDelegator delegator_)
    {
        (address vaultAddr, address delegatorAddr,) = symbioticCore.vaultConfigurator
            .create(
                IVaultConfigurator.InitParams({
                    version: vaultVersion,
                    owner: address(this),
                    vaultParams: _vaultParams(),
                    delegatorIndex: OPERATOR_SPECIFIC_TYPE,
                    delegatorParams: abi.encode(
                        IOperatorSpecificDelegator.InitParams({
                            baseParams: _baseParams(),
                            networkLimitSetRoleHolders: _toSingletonArray(network),
                            operator: operator_
                        })
                    ),
                    withSlasher: false,
                    slasherIndex: 0,
                    slasherParams: ""
                })
            );

        vault_ = IVault(vaultAddr);
        delegator_ = IOperatorSpecificDelegator(delegatorAddr);
    }

    function _createOperatorNetworkVault(address operator_)
        internal
        returns (IVault vault_, IOperatorNetworkSpecificDelegator delegator_)
    {
        (address vaultAddr, address delegatorAddr,) = symbioticCore.vaultConfigurator
            .create(
                IVaultConfigurator.InitParams({
                    version: vaultVersion,
                    owner: address(this),
                    vaultParams: _vaultParams(),
                    delegatorIndex: OPERATOR_NETWORK_SPECIFIC_TYPE,
                    delegatorParams: abi.encode(
                        IOperatorNetworkSpecificDelegator.InitParams({
                            baseParams: _baseParams(), network: network, operator: operator_
                        })
                    ),
                    withSlasher: false,
                    slasherIndex: 0,
                    slasherParams: ""
                })
            );

        vault_ = IVault(vaultAddr);
        delegator_ = IOperatorNetworkSpecificDelegator(delegatorAddr);
    }

    function _createFullRestakeVault() internal returns (IVault vault_, IFullRestakeDelegator delegator_) {
        (address vaultAddr, address delegatorAddr,) = symbioticCore.vaultConfigurator
            .create(
                IVaultConfigurator.InitParams({
                    version: vaultVersion,
                    owner: address(this),
                    vaultParams: _vaultParams(),
                    delegatorIndex: FULL_RESTAKE_TYPE,
                    delegatorParams: abi.encode(
                        IFullRestakeDelegator.InitParams({
                            baseParams: _baseParams(),
                            networkLimitSetRoleHolders: _toSingletonArray(network),
                            operatorNetworkLimitSetRoleHolders: _toSingletonArray(network)
                        })
                    ),
                    withSlasher: false,
                    slasherIndex: 0,
                    slasherParams: ""
                })
            );

        vault_ = IVault(vaultAddr);
        delegator_ = IFullRestakeDelegator(delegatorAddr);
    }

    function _deposit(address vault_, address depositor, uint256 amount) internal {
        vm.startPrank(depositor);
        rewardsToken.approve(vault_, type(uint256).max);
        IVault(vault_).deposit(depositor, amount);
        vm.stopPrank();
    }

    function _configureCuratorAndFees(address vault_) internal {
        curatorRegistry.setCurator(vault_, curator);

        vm.startPrank(curator);
        feeRegistry.setCuratorFee(vault_, 50_000);
        feeRegistry.setOperatorsFee(vault_, 30_000);
        vm.stopPrank();
    }

    function _deployOperatorSpecificVault(address operator_)
        internal
        returns (IVault newVault, uint48 rewardTimestamp)
    {
        if (!symbioticCore.operatorRegistry.isEntity(operator_)) {
            vm.prank(operator_);
            symbioticCore.operatorRegistry.registerOperator();
        }

        IOperatorSpecificDelegator newDelegator;
        (newVault, newDelegator) = _createOperatorSpecificVault(operator_);

        _configureCuratorAndFees(address(newVault));

        rewardTimestamp = uint48(block.timestamp + 1);
        vm.warp(rewardTimestamp);

        _deposit(address(newVault), curator, 1000 * 10 ** 18);

        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(network);
        newDelegator.setMaxNetworkLimit(SUBNETWORK_ID, 1000 * 10 ** 18);
        vm.prank(network);
        newDelegator.setNetworkLimit(subnetwork, 1000 * 10 ** 18);

        vm.prank(operator_);
        symbioticCore.operatorVaultOptInService.optIn(address(newVault));
        vm.prank(operator_);
        symbioticCore.operatorNetworkOptInService.optIn(network);

        vm.warp(uint256(rewardTimestamp) + 1);

        return (newVault, rewardTimestamp);
    }

    /* DISTRIBUTE VAULT SNAPSHOT REWARDS TESTS */

    function test_DistributeVaultSnapshotRewards_Success() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectEmit(true, true, true, true);
        emit IVaultSnapshotRewards.DistributeVaultSnapshotRewards(
            network,
            address(rewardsToken),
            address(vault),
            SUBNETWORK_ID,
            TIMESTAMP,
            REWARD_AMOUNT - (REWARD_AMOUNT * 50_000 / 1_000_000) - (REWARD_AMOUNT * 30_000 / 1_000_000), // After fees
            REWARD_AMOUNT * 50_000 / 1_000_000, // Curator fee
            REWARD_AMOUNT * 30_000 / 1_000_000 // Operators fee
        );

        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Check rewards length
        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken)), 1);

        // Check reward distribution
        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(rewardsToken), 0);

        assertEq(reward.subnetworkId, SUBNETWORK_ID);
        assertEq(reward.delegator, address(networkRestakeDelegator));
        assertEq(reward.delegatorType, 0);
        assertEq(reward.timestamp, TIMESTAMP);
        assertEq(
            reward.amount, REWARD_AMOUNT - (REWARD_AMOUNT * 50_000 / 1_000_000) - (REWARD_AMOUNT * 30_000 / 1_000_000)
        );
        assertEq(reward.operatorsFee, REWARD_AMOUNT * 30_000 / 1_000_000);
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_NotNetworkOrMiddleware() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IVaultSnapshotRewards.NotNetworkOrMiddleware.selector);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_InvalidVault() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IVaultSnapshotRewards.InvalidVault.selector);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork,
            address(rewardsToken),
            address(0), // Invalid vault
            REWARD_AMOUNT,
            TIMESTAMP,
            new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_InvalidRewardTimestamp() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IVaultSnapshotRewards.InvalidRewardTimestamp.selector);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork,
            address(rewardsToken),
            address(vault),
            REWARD_AMOUNT,
            uint48(block.timestamp), // Future timestamp
            new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_ZeroActiveShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        uint48 emptyTimestamp = TIMESTAMP - 1;

        vm.expectRevert(IVaultSnapshotRewards.InvalidRewardTimestamp.selector);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, emptyTimestamp, new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_InsufficientReward() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IVaultSnapshotRewards.InsufficientReward.selector);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork,
            address(rewardsToken),
            address(vault),
            0, // Zero amount
            TIMESTAMP,
            new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_WithMiddleware() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(middleware);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken)), 1);
    }

    /* CLAIM VAULT SNAPSHOT REWARDS TESTS */

    function test_ClaimVaultSnapshotRewards_Success() public {
        // First distribute rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        uint256 expectedAmount =
            (100
                    * 10
                    ** 18
                    * (REWARD_AMOUNT - (REWARD_AMOUNT * 50_000 / 1_000_000) - (REWARD_AMOUNT * 30_000 / 1_000_000)))
                / (1000 * 10 ** 18);

        vm.expectEmit(true, true, true, true);
        emit IVaultSnapshotRewards.ClaimVaultSnapshotRewards(
            staker, network, address(rewardsToken), address(vault), expectedAmount, 1
        );

        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(rewardsToken),
            address(vault),
            0, // lastUnclaimedRewards
            0, // firstRewardToClaim
            1, // maxRewards
            new bytes[](0) // activeSharesHints
        );

        assertEq(rewardsToken.balanceOf(recipient), expectedAmount);
        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken)), 1);
    }

    function test_ClaimVaultSnapshotRewards_RevertWhen_InvalidRecipient() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IVaultSnapshotRewards.InvalidRecipient.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            address(0), // Invalid recipient
            network,
            address(rewardsToken),
            address(vault),
            0,
            0,
            1,
            new bytes[](0)
        );
    }

    function test_ClaimVaultSnapshotRewards_RevertWhen_InvalidLastUnclaimedReward() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IVaultSnapshotRewards.InvalidLastUnclaimedReward.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(rewardsToken),
            address(vault),
            1, // Wrong lastUnclaimedRewards
            0,
            1,
            new bytes[](0)
        );
    }

    function test_ClaimVaultSnapshotRewards_RevertWhen_NoRewardsToClaim() public {
        vm.expectRevert(IVaultSnapshotRewards.NoRewardsToClaim.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(rewardsToken), address(vault), 0, 0, 1, new bytes[](0)
        );
    }

    function test_ClaimVaultSnapshotRewards_RevertWhen_RewardIndexExceedsAvailableRewards() public {
        // First distribute some rewards to create a rewards array with length > 0
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Now try to claim with a reward index that exceeds the available rewards
        // rewardsByTokenNetwork.length will be 1, but we're trying to access index 2
        vm.expectRevert(IVaultSnapshotRewards.NoRewardsToClaim.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(rewardsToken),
            address(vault),
            0, // lastUnclaimedRewards
            2, // firstRewardToClaim - this will make rewardIndex = 2, which > rewardsByTokenNetwork.length (1)
            1,
            new bytes[](0)
        );
    }

    /* CLAIM CURATOR FEE TESTS */

    function test_ClaimCuratorFee_Success() public {
        // First distribute rewards to generate curator fees
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        uint256 expectedCuratorFee = REWARD_AMOUNT * 50_000 / 1_000_000;

        vm.expectEmit(true, true, true, true);
        emit IVaultSnapshotRewards.ClaimCuratorFee(address(vault), address(rewardsToken), expectedCuratorFee);

        vm.prank(curator);
        vaultSnapshotRewards.claimCuratorFee(recipient, address(vault), address(rewardsToken));

        assertEq(rewardsToken.balanceOf(recipient), expectedCuratorFee);
    }

    function test_ClaimCuratorFee_RevertWhen_NotCurator() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IVaultSnapshotRewards.NotCurator.selector);
        vm.prank(staker); // Not the curator
        vaultSnapshotRewards.claimCuratorFee(recipient, address(vault), address(rewardsToken));
    }

    function test_ClaimCuratorFee_RevertWhen_NoRewardsToClaim() public {
        vm.expectRevert(IVaultSnapshotRewards.NoRewardsToClaim.selector);
        vm.prank(curator);
        vaultSnapshotRewards.claimCuratorFee(recipient, address(vault), address(rewardsToken));
    }

    /* CLAIM OPERATOR FEE TESTS */

    function test_ClaimOperatorFee_NetworkRestakeDelegator_Success() public {
        // First distribute rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertGt(networkRestakeDelegator.totalOperatorNetworkShares(Subnetwork.subnetwork(network, SUBNETWORK_ID)), 0);
        assertGt(
            networkRestakeDelegator.totalOperatorNetworkSharesAt(
                Subnetwork.subnetwork(network, SUBNETWORK_ID), TIMESTAMP, new bytes(0)
            ),
            0
        );

        uint256 operatorsFee = REWARD_AMOUNT * 30_000 / 1_000_000;
        uint256 expectedAmount = ((50 * 10 ** 18 * operatorsFee) / (200 * 10 ** 18)) * 2;

        bytes[] memory operatorNetworkSharesHints = new bytes[](2);
        operatorNetworkSharesHints[0] = abi.encode(0);
        operatorNetworkSharesHints[1] = abi.encode(0);
        bytes[] memory totalOperatorNetworkSharesHint = new bytes[](2);
        totalOperatorNetworkSharesHint[0] = abi.encode(0);
        totalOperatorNetworkSharesHint[1] = abi.encode(0);
        bytes memory extraData = abi.encode(operatorNetworkSharesHints, totalOperatorNetworkSharesHint);

        vm.expectEmit(true, true, true, true);
        emit IVaultSnapshotRewards.ClaimOperatorFee(
            operator, network, address(rewardsToken), address(vault), expectedAmount, 2
        );

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            recipient, network, address(rewardsToken), address(vault), 0, 0, 2, extraData
        );

        assertEq(rewardsToken.balanceOf(recipient), expectedAmount);
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(rewardsToken)),
            2
        );
    }

    function test_ClaimOperatorFee_OperatorSpecificDelegator_Success() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(operatorSpecificVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        uint256 operatorsFee = REWARD_AMOUNT * 30_000 / 1_000_000;

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            recipient, network, address(rewardsToken), address(operatorSpecificVault), 0, 0, 1, new bytes(0)
        );

        assertEq(rewardsToken.balanceOf(recipient), operatorsFee);
    }

    function test_ClaimOperatorFee_OperatorNetworkSpecificDelegator_Success() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(operatorNetworkVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        uint256 operatorsFee = REWARD_AMOUNT * 30_000 / 1_000_000;

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            recipient, network, address(rewardsToken), address(operatorNetworkVault), 0, 0, 1, new bytes(0)
        );

        assertEq(rewardsToken.balanceOf(recipient), operatorsFee);
    }

    function test_ClaimOperatorFee_RevertWhen_InvalidRecipient() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IVaultSnapshotRewards.InvalidRecipient.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            address(0), // Invalid recipient
            network,
            address(rewardsToken),
            address(vault),
            0,
            0,
            1,
            new bytes(0)
        );
    }

    function test_ClaimOperatorFee_RevertWhen_InvalidLastUnclaimedReward() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IVaultSnapshotRewards.InvalidLastUnclaimedReward.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            recipient,
            network,
            address(rewardsToken),
            address(vault),
            1, // Wrong lastUnclaimedRewards
            0,
            1,
            new bytes(0)
        );
    }

    function test_ClaimOperatorFee_RevertWhen_NoRewardsToClaim() public {
        vm.expectRevert(IVaultSnapshotRewards.NoRewardsToClaim.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            recipient, network, address(rewardsToken), address(vault), 0, 0, 1, new bytes(0)
        );
    }

    function test_ClaimOperatorFee_RevertWhen_RewardIndexExceedsAvailableRewards() public {
        // First distribute some rewards to create a rewards array with length > 0
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Now try to claim with a reward index that exceeds the available rewards
        // rewardsByTokenNetwork.length will be 1, but we're trying to access index 2
        vm.expectRevert(IVaultSnapshotRewards.NoRewardsToClaim.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            recipient,
            network,
            address(rewardsToken),
            address(vault),
            0, // lastUnclaimedRewards
            2, // firstRewardToClaim - this will make rewardIndex = 2, which > rewardsByTokenNetwork.length (1)
            1,
            new bytes(0)
        );
    }

    function test_ClaimOperatorFee_RevertWhen_InvalidDelegatorType() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(invalidDelegatorVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IVaultSnapshotRewards.InvalidDelegatorType.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            recipient, network, address(rewardsToken), address(invalidDelegatorVault), 0, 0, 1, new bytes(0)
        );
    }

    function test_ClaimOperatorFee_RevertWhen_NotOperator() public {
        address wrongOperator = address(0x999);
        (IVault operatorVault, uint48 rewardTimestamp) = _deployOperatorSpecificVault(wrongOperator);

        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(operatorVault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );

        vm.expectRevert(IVaultSnapshotRewards.NotOperator.selector);
        vm.prank(operator); // Wrong operator
        vaultSnapshotRewards.claimOperatorFee(
            recipient, network, address(rewardsToken), address(operatorVault), 0, 0, 1, new bytes(0)
        );
    }

    /* VIEW FUNCTION TESTS */

    function test_RewardsLength() public {
        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken)), 0);

        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken)), 1);
    }

    function test_Rewards() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(rewardsToken), 0);

        assertEq(reward.subnetworkId, SUBNETWORK_ID);
        assertEq(reward.delegator, address(networkRestakeDelegator));
        assertEq(reward.delegatorType, 0);
        assertEq(reward.timestamp, TIMESTAMP);
    }

    function test_LastUnclaimedReward() public {
        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken)), 0);
    }

    function test_LastUnclaimedOperatorReward() public {
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(rewardsToken)),
            0
        );
    }

    /* CLAIM REWARDS TESTS */

    function test_ClaimRewards_Success() public {
        // First distribute rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Encode claim data
        bytes[] memory activeSharesHints = new bytes[](1);
        activeSharesHints[0] = new bytes(0);

        bytes memory data = abi.encode(
            network,
            address(vault),
            uint256(0), // lastUnclaimedRewards
            uint256(0), // firstRewardToClaim
            uint256(1), // maxRewards
            activeSharesHints
        );

        vm.prank(staker);
        vaultSnapshotRewards.claimRewards(recipient, address(rewardsToken), data);

        uint256 expectedAmount =
            (100
                    * 10
                    ** 18
                    * (REWARD_AMOUNT - (REWARD_AMOUNT * 50_000 / 1_000_000) - (REWARD_AMOUNT * 30_000 / 1_000_000)))
                / (1000 * 10 ** 18);
        assertEq(rewardsToken.balanceOf(recipient), expectedAmount);
    }

    function test_ClaimRewardsMany_Success() public {
        // First distribute rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint256 N = 75;
        for (uint256 i; i < N; ++i) {
            vm.prank(network);
            vaultSnapshotRewards.distributeVaultSnapshotRewards(
                subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, uint48(TIMESTAMP + i), new bytes(0)
            );
            vm.warp(vm.getBlockTimestamp() + 1);
        }

        // Encode claim data
        bytes[] memory activeSharesHints = new bytes[](N);
        for (uint256 i; i < N; ++i) {
            activeSharesHints[i] = abi.encode(0);
        }

        bytes memory data = abi.encode(
            network,
            address(vault),
            uint256(0), // lastUnclaimedRewards
            uint256(0), // firstRewardToClaim
            uint256(10_000), // maxRewards
            activeSharesHints
        );

        vm.prank(staker);
        vaultSnapshotRewards.claimRewards(recipient, address(rewardsToken), data);
    }

    /* EDGE CASES AND ERROR CONDITIONS */

    function test_MultipleDistributions() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        // First distribution
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Second distribution
        uint48 secondTimestamp = TIMESTAMP + 1;
        vm.warp(uint256(secondTimestamp) + 1);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, secondTimestamp, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken)), 2);
    }

    function test_PartialClaim() public {
        // Distribute multiple rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        uint48 secondTimestamp = TIMESTAMP + 1;
        vm.warp(uint256(secondTimestamp) + 1);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, secondTimestamp, new bytes(0)
        );

        // Claim only first reward
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(rewardsToken),
            address(vault),
            0,
            0,
            1, // maxRewards = 1
            new bytes[](0)
        );

        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken)), 1);

        // Claim second reward
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(rewardsToken),
            address(vault),
            1, // lastUnclaimedRewards = 1
            0,
            1,
            new bytes[](0)
        );

        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken)), 2);
    }

    function test_ZeroStakerShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint48 rewardTimestamp = uint48(block.timestamp + 1);
        vm.warp(rewardTimestamp);

        vm.prank(staker);
        vault.withdraw(staker, 100 * 10 ** 18);

        vm.warp(uint256(rewardTimestamp) + 1);

        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );

        vm.warp(uint256(rewardTimestamp) + 2);

        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(rewardsToken), address(vault), 0, 0, 1, new bytes[](0)
        );

        // Should not transfer any tokens
        assertEq(rewardsToken.balanceOf(recipient), 0);
    }

    function test_CachedActiveShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        // First distribution caches active shares
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Second distribution with same timestamp should use cached value
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(rewardsToken)), 2);
    }
}
