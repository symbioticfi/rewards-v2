// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {RewardsV2TestBase} from "./RewardsV2TestBase.sol";
import {VaultSnapshotRewards} from "../src/contracts/VaultSnapshotRewards.sol";
import {CuratorFees} from "../src/contracts/CuratorFees.sol";
import {ProtocolFees} from "../src/contracts/ProtocolFees.sol";
import {IVaultSnapshotRewards} from "../src/interfaces/IVaultSnapshotRewards.sol";
import {IVaultV2, VAULT_V2_VERSION} from "../src/interfaces/IVaultV2.sol";
import {ICuratorFees} from "../src/interfaces/ICuratorFees.sol";
import {IRewards} from "../src/interfaces/IRewards.sol";
import {IRewardsErrors} from "../src/interfaces/IRewardsErrors.sol";

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
import {Token} from "@symbioticfi/core/test/mocks/Token.sol";
import {ReentrantERC20} from "./mocks/ReentrantERC20.sol";
import {ReentrancyGuardTransient} from "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";

contract InvalidDelegatorTypeMock {
    function TYPE() external pure returns (uint64) {
        return uint64(type(IVaultSnapshotRewards.DelegatorType).max) + 1;
    }
}

interface IVaultHints {
    function activeSharesHint(address vault, uint48 timestamp) external view returns (bytes memory);

    function activeSharesOfHint(address vault, address account, uint48 timestamp) external view returns (bytes memory);
}

interface IBaseDelegatorHints {
    function NETWORK_RESTAKE_DELEGATOR_HINTS() external view returns (address);
}

interface INetworkRestakeDelegatorHints {
    function operatorNetworkSharesHint(address delegator, bytes32 subnetwork, address operator, uint48 timestamp)
        external
        view
        returns (bytes memory);

    function totalOperatorNetworkSharesHint(address delegator, bytes32 subnetwork, uint48 timestamp)
        external
        view
        returns (bytes memory);
}

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
        VaultSnapshotRewards(vaultFactory, networkRegistry, networkMiddlewareService)
        CuratorFees(curatorRegistry)
        ProtocolFees(feeRegistry)
    {}
}

contract VaultSnapshotRewardsTest is RewardsV2TestBase {
    TestableVaultSnapshotRewards vaultSnapshotRewards;
    IVault vault;
    IVault operatorSpecificVault;
    IVault operatorNetworkVault;
    IVault fullRestakeVault;
    INetworkRestakeDelegator networkRestakeDelegator;
    IOperatorSpecificDelegator operatorSpecificDelegator;
    IOperatorNetworkSpecificDelegator operatorNetworkSpecificDelegator;
    IFullRestakeDelegator fullRestakeDelegator;
    Token snapshotToken;

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
    uint256 constant MAX_FEE = 1_000_000;
    uint256 constant DEFAULT_CURATOR_FEE = 50_000;
    uint256 constant DEFAULT_OPERATORS_FEE = 30_000;
    uint64 vaultVersion;

    bytes32 constant VAULT_SNAPSHOT_REWARDS_STORAGE_POSITION =
        0xea7ec811d4da20f680ecf87dbad2b956cc74e833cd99b5f63865df6b3d6b6800;

    function setUp() public override {
        _deployRewardsInfra(address(this));

        vaultVersion = symbioticCore.vaultFactory.lastVersion();
        if (vaultVersion >= VAULT_V2_VERSION) {
            vaultVersion = VAULT_V2_VERSION - 1;
        }

        uint256 allocation = 150_000 * 10 ** 18;
        rewardsToken.transfer(network, allocation);
        rewardsToken.transfer(middleware, allocation);
        rewardsToken.transfer(staker, allocation);
        rewardsToken.transfer(curator, allocation);
        rewardsToken.transfer(operator, allocation);
        rewardsToken.transfer(otherOperator, allocation);
        snapshotToken = new Token("SnapshotToken");
        snapshotToken.transfer(network, allocation);
        snapshotToken.transfer(middleware, allocation);
        snapshotToken.transfer(staker, allocation);
        snapshotToken.transfer(curator, allocation);
        snapshotToken.transfer(operator, allocation);
        snapshotToken.transfer(otherOperator, allocation);

        vm.prank(network);
        symbioticCore.networkRegistry.registerNetwork();
        vm.prank(operator);
        symbioticCore.operatorRegistry.registerOperator();
        vm.prank(otherOperator);
        symbioticCore.operatorRegistry.registerOperator();

        (vault, networkRestakeDelegator) = _createNetworkRestakeVault();
        (operatorSpecificVault, operatorSpecificDelegator) = _createOperatorSpecificVault(operator);
        (operatorNetworkVault, operatorNetworkSpecificDelegator) = _createOperatorNetworkVault(operator);
        (fullRestakeVault, fullRestakeDelegator) = _createFullRestakeVault();

        _configureCuratorAndFees(address(vault));
        _configureCuratorAndFees(address(operatorSpecificVault));
        _configureCuratorAndFees(address(operatorNetworkVault));
        _configureCuratorAndFees(address(fullRestakeVault));

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
        _deposit(address(fullRestakeVault), curator, 1000 * 10 ** 18);

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
        vm.prank(network);
        snapshotToken.approve(address(vaultSnapshotRewards), type(uint256).max);

        vm.prank(middleware);
        rewardsToken.approve(address(vaultSnapshotRewards), type(uint256).max);
        vm.prank(middleware);
        snapshotToken.approve(address(vaultSnapshotRewards), type(uint256).max);
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
        feeRegistry.setCuratorFee(vault_, DEFAULT_CURATOR_FEE);
        feeRegistry.setOperatorsFee(vault_, DEFAULT_OPERATORS_FEE);
        vm.stopPrank();
    }

    function _afterProtocol(uint256 amount) internal pure returns (uint256) {
        return amount - (amount * DEFAULT_VAULT_SNAPSHOT_FEE / MAX_FEE);
    }

    function _feeAmount(uint256 amount, uint256 fee) internal pure returns (uint256) {
        return amount * fee / MAX_FEE;
    }

    function _splitFees(uint256 total, uint256 curatorFee, uint256 operatorsFee)
        internal
        pure
        returns (uint256 distributionAmount, uint256 curatorFees, uint256 operatorsFees, uint256 netAmount)
    {
        distributionAmount = _afterProtocol(total);
        curatorFees = _feeAmount(distributionAmount, curatorFee);
        operatorsFees = _feeAmount(distributionAmount, operatorsFee);
        netAmount = distributionAmount - curatorFees - operatorsFees;
    }

    function _splitDefaultFees(uint256 total)
        internal
        pure
        returns (uint256 distributionAmount, uint256 curatorFees, uint256 operatorsFees, uint256 netAmount)
    {
        return _splitFees(total, DEFAULT_CURATOR_FEE, DEFAULT_OPERATORS_FEE);
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

    function _distributionHints(
        bytes memory activeSharesHint,
        bytes memory activeStakeHint,
        bytes memory curatorFeeHint,
        bytes memory operatorsFeeHint,
        bytes memory totalOperatorNetworkSharesHint
    ) internal pure returns (bytes memory) {
        return abi.encode(
            activeSharesHint, operatorsFeeHint, totalOperatorNetworkSharesHint, curatorFeeHint, activeStakeHint
        );
    }

    function _emptyDistributionHints() internal pure returns (bytes memory) {
        return _distributionHints("", "", "", "", "");
    }

    function _distributeVaultSnapshotRewards(
        bytes32 subnetwork,
        address token,
        address vault_,
        uint256 amount,
        uint48 timestamp,
        bytes memory activeSharesHint
    ) internal {
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork,
            token,
            vault_,
            amount,
            timestamp,
            _distributionHints(activeSharesHint, activeSharesHint, "", "", "")
        );
    }

    function _mockCurrentDelegatorAsUniversal(bytes32 subnetwork, uint48 timestamp, uint96 slot, uint256 filled)
        internal
    {
        vm.mockCall(
            address(networkRestakeDelegator),
            abi.encodeWithSignature("TYPE()"),
            abi.encode(uint64(IVaultSnapshotRewards.DelegatorType.UNIVERSAL))
        );
        vm.mockCall(address(networkRestakeDelegator), abi.encodeWithSignature("oldDelegator()"), abi.encode(address(0)));
        vm.mockCall(
            address(networkRestakeDelegator), abi.encodeWithSignature("migrateTimestamp()"), abi.encode(uint48(0))
        );
        vm.mockCall(
            address(networkRestakeDelegator),
            abi.encodeWithSignature("getSlotOfNetworkAt(bytes32,uint48)", subnetwork, timestamp),
            abi.encode(slot)
        );
        vm.mockCall(
            address(networkRestakeDelegator),
            abi.encodeWithSignature("getFilledAt(uint96,uint48,uint48)", slot, uint48(0), timestamp),
            abi.encode(filled)
        );
    }

    /* DISTRIBUTE VAULT SNAPSHOT REWARDS TESTS */

    function test_DistributeVaultSnapshotRewards_Success() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        (,, uint256 operatorsFees, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);

        vm.expectEmit(true, true, true, true);
        emit IVaultSnapshotRewards.DistributeVaultSnapshotRewards(
            network,
            address(snapshotToken),
            address(vault),
            SUBNETWORK_ID,
            TIMESTAMP,
            netAmount, // After fees
            operatorsFees
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Check rewards length
        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(snapshotToken)), 1);

        // Check reward distribution
        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        assertEq(reward.subnetworkId, SUBNETWORK_ID);
        assertEq(reward.delegator, address(networkRestakeDelegator));
        assertEq(reward.delegatorType, 0);
        assertEq(reward.timestamp, TIMESTAMP);
        assertEq(reward.amountToDeposits, netAmount);
        assertEq(reward.operatorsFees, operatorsFees);
    }

    function test_DistributeVaultSnapshotRewards_ZeroNetAmount_SkipsRequest() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        bytes32 feeId = keccak256(abi.encode(REWARDS_PROTOCOL_FEE_ID, IRewards.RewardsType.VAULT_SNAPSHOT, network));

        vm.mockCall(
            address(feeRegistry), abi.encodeWithSignature("getProtocolFee(bytes32)", feeId), abi.encode(true, MAX_FEE)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(snapshotToken)), 0);

        vm.expectRevert(IRewardsErrors.NoRewardsToClaim.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, new bytes[](0)
        );

        assertEq(snapshotToken.balanceOf(recipient), 0);
        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(snapshotToken)), 0);
    }

    function test_DistributeVaultSnapshotRewards_CollateralToken_IsNotDonation() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint256 vaultBalanceBefore = rewardsToken.balanceOf(address(vault));

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(rewardsToken), 0);

        (
            uint256 distributionAmount,
            uint256 expectedCuratorFees,
            uint256 expectedOperatorFees,
            uint256 expectedAmount
        ) = _splitFees(REWARD_AMOUNT, DEFAULT_CURATOR_FEE, DEFAULT_OPERATORS_FEE);

        assertEq(reward.amountToDeposits, expectedAmount);
        assertEq(reward.operatorsFees, expectedOperatorFees);
        assertEq(vaultSnapshotRewards.curatorFees(address(vault), address(rewardsToken)), expectedCuratorFees);
        assertEq(rewardsToken.balanceOf(address(vault)), vaultBalanceBefore);
    }

    function test_DistributeVaultSnapshotRewards_Donation_RevertWhen_NoDonationSupport() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION - 1)));
        vm.expectCall(address(vault), abi.encodeWithSignature("version()"));

        vm.expectRevert(IRewardsErrors.NoDonationSupport.selector);
        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(0), address(vault), REWARD_AMOUNT, TIMESTAMP, _emptyDistributionHints()
        );
    }

    function test_DistributeVaultSnapshotRewards_Donation_UsesVaultCollateralAndSkipsStakerClaim() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        (, uint256 expectedCuratorFees, uint256 expectedOperatorFees, uint256 expectedDonationAmount) =
            _splitDefaultFees(REWARD_AMOUNT);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION)));
        vm.expectCall(address(vault), abi.encodeWithSignature("version()"));
        vm.mockCall(
            address(vault), abi.encodeWithSelector(IVaultV2.donate.selector, expectedDonationAmount), abi.encode()
        );
        vm.expectCall(address(vault), abi.encodeWithSelector(IVaultV2.donate.selector, expectedDonationAmount));

        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(0), address(vault), REWARD_AMOUNT, TIMESTAMP, _emptyDistributionHints()
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(rewardsToken), 0);

        assertEq(reward.amountToDeposits, 0);
        assertEq(reward.amountToWithdrawals, 0);
        assertEq(reward.operatorsFees, expectedOperatorFees);
        assertEq(vaultSnapshotRewards.curatorFees(address(vault), address(rewardsToken)), expectedCuratorFees);

        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(rewardsToken), address(vault), 0, 0, 1, new bytes[](0)
        );

        assertEq(rewardsToken.balanceOf(recipient), 0);
        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(rewardsToken)), 1);
    }

    function test_DistributeVaultSnapshotRewards_VaultV2_SplitsRewardsBetweenDepositsAndWithdrawals() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint48 rewardTimestamp = uint48(block.timestamp + 1);

        vm.warp(rewardTimestamp);
        vm.prank(staker);
        vault.withdraw(staker, 100 * 10 ** 18);

        vm.warp(uint256(rewardTimestamp) + 1);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION)));
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalsAt.selector, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesAt.selector, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (,, uint256 expectedOperatorFees, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmountToWithdrawals = netAmount * 100 * 10 ** 18 / (1000 * 10 ** 18);

        assertEq(reward.amountToDeposits, netAmount - expectedAmountToWithdrawals);
        assertEq(reward.amountToWithdrawals, expectedAmountToWithdrawals);
        assertEq(reward.operatorsFees, expectedOperatorFees);
    }

    function test_DistributeVaultSnapshotRewards_VaultV2_AllowsWithdrawalsWithoutActiveDeposits() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint48 rewardTimestamp = uint48(block.timestamp + 1);

        vm.warp(rewardTimestamp);
        vm.prank(staker);
        vault.withdraw(staker, 100 * 10 ** 18);
        vm.prank(curator);
        vault.withdraw(curator, 900 * 10 ** 18);

        vm.warp(uint256(rewardTimestamp) + 1);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION)));
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalsAt.selector, rewardTimestamp),
            abi.encode(1000 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesAt.selector, rewardTimestamp),
            abi.encode(1000 * 10 ** 18)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (,, uint256 expectedOperatorFees, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);

        assertEq(reward.amountToDeposits, 0);
        assertEq(reward.amountToWithdrawals, netAmount);
        assertEq(reward.operatorsFees, expectedOperatorFees);
    }

    function test_DistributeVaultSnapshotRewards_UsesHistoricalFeesAtTimestamp() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        // Update fees after the reward timestamp to ensure historical lookup is used
        vm.prank(curator);
        feeRegistry.setCuratorFee(address(vault), 10_000);
        vm.prank(curator);
        feeRegistry.setOperatorsFee(address(vault), 20_000);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (
            uint256 distributionAmount,
            uint256 expectedCuratorFees,
            uint256 expectedOperatorFees,
            uint256 expectedAmount
        ) = _splitDefaultFees(REWARD_AMOUNT);

        assertEq(reward.amountToDeposits, expectedAmount);
        assertEq(reward.operatorsFees, expectedOperatorFees);
        assertEq(vaultSnapshotRewards.curatorFees(address(vault), address(snapshotToken)), expectedCuratorFees);

        // Confirm new fee checkpoints are not applied to the historical timestamp
        assertTrue(expectedOperatorFees != _feeAmount(distributionAmount, 20_000));
        assertTrue(expectedCuratorFees != _feeAmount(distributionAmount, 10_000));
    }

    function test_Audit_CuratorFeesCollideWithActiveSharesCacheForLowValuedRewardTokens() public {
        uint48 collisionTimestamp = 0x1000;
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        address lowTokenAddress = address(uint160(collisionTimestamp));
        uint256 totalAmount = 2000e18;

        ReentrantERC20 tokenTemplate = new ReentrantERC20();
        vm.etch(lowTokenAddress, address(tokenTemplate).code);

        ReentrantERC20 lowToken = ReentrantERC20(lowTokenAddress);
        lowToken.mint(network, totalAmount);

        vm.prank(network);
        lowToken.approve(address(vaultSnapshotRewards), type(uint256).max);

        vm.warp(uint256(collisionTimestamp) + 1);

        uint256 expectedActiveShares = IVaultV2(address(vault)).activeSharesAt(collisionTimestamp, new bytes(0));
        (, uint256 expectedCuratorFees,,) = _splitDefaultFees(totalAmount);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, lowTokenAddress, address(vault), totalAmount, collisionTimestamp, ""
        );

        uint256 inflatedCuratorFees = vaultSnapshotRewards.curatorFees(address(vault), lowTokenAddress);
        assertEq(inflatedCuratorFees, expectedActiveShares + expectedCuratorFees);
        assertGt(inflatedCuratorFees, expectedCuratorFees);

        uint256 curatorBalanceBefore = lowToken.balanceOf(recipient);
        vm.prank(curator);
        vaultSnapshotRewards.claimCuratorFees(recipient, address(vault), lowTokenAddress);
        assertEq(lowToken.balanceOf(recipient) - curatorBalanceBefore, inflatedCuratorFees);

        vm.expectRevert();
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            staker, network, lowTokenAddress, address(vault), 0, 0, 1, new bytes[](0)
        );
    }

    function test_DistributeVaultSnapshotRewards_OperatorSpecificDelegator_StoresOperatorsFees() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(operatorSpecificVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(operatorSpecificVault), network, address(snapshotToken), 0);

        (,, uint256 expectedOperatorFees, uint256 expectedAmount) = _splitDefaultFees(REWARD_AMOUNT);

        assertEq(reward.delegator, address(operatorSpecificDelegator));
        assertEq(reward.delegatorType, OPERATOR_SPECIFIC_TYPE);
        assertEq(reward.operatorsFees, expectedOperatorFees);
        assertEq(reward.amountToDeposits, expectedAmount);
    }

    function test_DistributeVaultSnapshotRewards_UniversalDelegator_StoresOperatorsFees() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        _mockCurrentDelegatorAsUniversal(subnetwork, TIMESTAMP, 1, 200 * 10 ** 18);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (,, uint256 expectedOperatorFees, uint256 expectedAmount) = _splitDefaultFees(REWARD_AMOUNT);

        assertEq(reward.delegator, address(networkRestakeDelegator));
        assertEq(reward.delegatorType, uint64(IVaultSnapshotRewards.DelegatorType.UNIVERSAL));
        assertEq(reward.operatorsFees, expectedOperatorFees);
        assertEq(reward.amountToDeposits, expectedAmount);
    }

    function test_DistributeVaultSnapshotRewards_UniversalDelegator_ZeroSubnetworkIndex_ZeroesOperatorsFees() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        _mockCurrentDelegatorAsUniversal(subnetwork, TIMESTAMP, 0, 200 * 10 ** 18);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (,,, uint256 expectedAmount) = _splitFees(REWARD_AMOUNT, DEFAULT_CURATOR_FEE, 0);

        assertEq(reward.delegator, address(networkRestakeDelegator));
        assertEq(reward.delegatorType, uint64(IVaultSnapshotRewards.DelegatorType.UNIVERSAL));
        assertEq(reward.operatorsFees, 0);
        assertEq(reward.amountToDeposits, expectedAmount);
    }

    function test_DistributeVaultSnapshotRewards_UniversalDelegator_ZeroSubnetworkFilled_ZeroesOperatorsFees() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        _mockCurrentDelegatorAsUniversal(subnetwork, TIMESTAMP, 1, 0);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (,,, uint256 expectedAmount) = _splitFees(REWARD_AMOUNT, DEFAULT_CURATOR_FEE, 0);

        assertEq(reward.delegator, address(networkRestakeDelegator));
        assertEq(reward.delegatorType, uint64(IVaultSnapshotRewards.DelegatorType.UNIVERSAL));
        assertEq(reward.operatorsFees, 0);
        assertEq(reward.amountToDeposits, expectedAmount);
    }

    function test_DistributeVaultSnapshotRewards_UsesOldDelegatorBeforeMigration() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        address oldDelegator = makeAddr("oldDelegator");

        vm.mockCall(
            address(networkRestakeDelegator),
            abi.encodeWithSignature("TYPE()"),
            abi.encode(uint64(IVaultSnapshotRewards.DelegatorType.UNIVERSAL))
        );
        vm.mockCall(
            address(networkRestakeDelegator), abi.encodeWithSignature("oldDelegator()"), abi.encode(oldDelegator)
        );
        vm.mockCall(
            address(networkRestakeDelegator), abi.encodeWithSignature("migrateTimestamp()"), abi.encode(TIMESTAMP + 1)
        );
        vm.mockCall(oldDelegator, abi.encodeWithSignature("TYPE()"), abi.encode(NETWORK_RESTAKE_TYPE));
        vm.mockCall(
            oldDelegator,
            abi.encodeWithSelector(
                INetworkRestakeDelegator.totalOperatorNetworkSharesAt.selector, subnetwork, TIMESTAMP, bytes("")
            ),
            abi.encode(200 * 10 ** 18)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        assertEq(reward.delegator, oldDelegator);
        assertEq(reward.delegatorType, NETWORK_RESTAKE_TYPE);
    }

    function test_DistributeVaultSnapshotRewards_OperatorNetworkSpecificDelegator_StoresOperatorsFees() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(operatorNetworkVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(operatorNetworkVault), network, address(snapshotToken), 0);

        (,, uint256 expectedOperatorFees, uint256 expectedAmount) = _splitDefaultFees(REWARD_AMOUNT);

        assertEq(reward.delegator, address(operatorNetworkSpecificDelegator));
        assertEq(reward.delegatorType, OPERATOR_NETWORK_SPECIFIC_TYPE);
        assertEq(reward.operatorsFees, expectedOperatorFees);
        assertEq(reward.amountToDeposits, expectedAmount);
    }

    function test_DistributeVaultSnapshotRewards_RevertsOnReentrancy() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        ReentrantERC20 reentrantToken = new ReentrantERC20();
        reentrantToken.mint(network, REWARD_AMOUNT);

        bytes memory reenterData = abi.encodeCall(
            VaultSnapshotRewards.distributeVaultSnapshotRewards,
            (subnetwork, address(reentrantToken), address(vault), 1, TIMESTAMP, _emptyDistributionHints())
        );
        reentrantToken.setHook(address(vaultSnapshotRewards), reenterData);

        vm.prank(network);
        reentrantToken.approve(address(vaultSnapshotRewards), REWARD_AMOUNT);

        vm.expectRevert(ReentrancyGuardTransient.ReentrancyGuardReentrantCall.selector);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(reentrantToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );
    }

    function test_ClaimVaultSnapshotRewards_RevertsOnReentrancy() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        ReentrantERC20 reentrantToken = new ReentrantERC20();
        reentrantToken.mint(network, REWARD_AMOUNT);

        vm.prank(network);
        reentrantToken.approve(address(vaultSnapshotRewards), REWARD_AMOUNT);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(reentrantToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        bytes memory reenterData = abi.encodeCall(
            VaultSnapshotRewards.claimVaultSnapshotRewards,
            (staker, network, address(reentrantToken), address(vault), 0, 0, 1, new bytes[](0))
        );
        reentrantToken.setHook(address(vaultSnapshotRewards), reenterData);

        vm.prank(staker);
        reentrantToken.approve(address(vaultSnapshotRewards), REWARD_AMOUNT);

        vm.expectRevert(ReentrancyGuardTransient.ReentrancyGuardReentrantCall.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            staker, network, address(reentrantToken), address(vault), 0, 0, 1, new bytes[](0)
        );
    }

    function test_DistributeVaultSnapshotRewards_FullRestakeDelegator_SetsOperatorsFeesToZero() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(fullRestakeVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(fullRestakeVault), network, address(snapshotToken), 0);

        (, uint256 expectedCuratorFees,, uint256 expectedAmount) = _splitFees(REWARD_AMOUNT, DEFAULT_CURATOR_FEE, 0);

        assertEq(reward.delegator, address(fullRestakeDelegator));
        assertEq(reward.delegatorType, FULL_RESTAKE_TYPE);
        assertEq(reward.operatorsFees, 0);
        assertEq(reward.amountToDeposits, expectedAmount);
        assertEq(
            vaultSnapshotRewards.curatorFees(address(fullRestakeVault), address(snapshotToken)), expectedCuratorFees
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_DelegatorTypeAboveMax() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        // Override delegator code to return an unsupported type > enum max
        InvalidDelegatorTypeMock invalidDelegator = new InvalidDelegatorTypeMock();
        vm.etch(address(networkRestakeDelegator), address(invalidDelegator).code);

        vm.expectRevert();
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_NotNetworkOrMiddleware() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IRewardsErrors.NotNetworkOrMiddleware.selector);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_NotVault() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IRewardsErrors.NotVault.selector);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork,
            address(snapshotToken),
            address(0), // Invalid vault
            REWARD_AMOUNT,
            TIMESTAMP,
            new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_NotVault_FromMiddleware() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IRewardsErrors.NotVault.selector);
        vm.prank(middleware);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(0xdeadbeef), REWARD_AMOUNT, TIMESTAMP, _emptyDistributionHints()
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_InvalidRewardTimestamp() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IRewardsErrors.InvalidRewardTimestamp.selector);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork,
            address(snapshotToken),
            address(vault),
            REWARD_AMOUNT,
            uint48(block.timestamp), // Future timestamp
            new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_NoActiveStakeOrWithdrawals() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        uint48 emptyTimestamp = TIMESTAMP - 1;

        vm.expectRevert(IRewardsErrors.InvalidRewardTimestamp.selector);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, emptyTimestamp, new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_VaultV2_RoutesRewardsToWithdrawalsWhenActiveStakeHasNoShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint48 rewardTimestamp = uint48(block.timestamp + 1);

        vm.warp(rewardTimestamp);
        vm.prank(staker);
        vault.withdraw(staker, 100 * 10 ** 18);

        vm.warp(uint256(rewardTimestamp) + 1);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION)));
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeSharesAt.selector, rewardTimestamp, new bytes(0)),
            abi.encode(0)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesAt.selector, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeStakeAt.selector, rewardTimestamp, new bytes(0)),
            abi.encode(900 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalsAt.selector, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (, uint256 expectedCuratorFees, uint256 expectedOperatorFees, uint256 netAmount) =
            _splitDefaultFees(REWARD_AMOUNT);

        assertEq(reward.amountToDeposits, 0);
        assertEq(reward.amountToWithdrawals, netAmount);
        assertEq(reward.operatorsFees, expectedOperatorFees);
        assertEq(vaultSnapshotRewards.curatorFees(address(vault), address(snapshotToken)), expectedCuratorFees);
    }

    function test_DistributeVaultSnapshotRewards_VaultV2_RoutesRewardsToDepositsWhenWithdrawalsHaveNoShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION)));
        vm.mockCall(
            address(vault), abi.encodeWithSelector(IVaultV2.activeWithdrawalsAt.selector, TIMESTAMP), abi.encode(1)
        );
        vm.mockCall(
            address(vault), abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesAt.selector, TIMESTAMP), abi.encode(0)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (, uint256 expectedCuratorFees, uint256 expectedOperatorFees, uint256 netAmount) =
            _splitDefaultFees(REWARD_AMOUNT);

        assertEq(reward.amountToDeposits, netAmount);
        assertEq(reward.amountToWithdrawals, 0);
        assertEq(reward.operatorsFees, expectedOperatorFees);
        assertEq(vaultSnapshotRewards.curatorFees(address(vault), address(snapshotToken)), expectedCuratorFees);
    }

    function test_DistributeVaultSnapshotRewards_RevertWhen_InsufficientReward() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.expectRevert(IRewardsErrors.InsufficientReward.selector);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork,
            address(snapshotToken),
            address(vault),
            0, // Zero amount
            TIMESTAMP,
            new bytes(0)
        );
    }

    function test_DistributeVaultSnapshotRewards_WithMiddleware() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(middleware);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(snapshotToken)), 1);
    }

    function test_DistributeVaultSnapshotRewards_WithActiveSharesHint() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        bytes memory activeSharesHint = abi.encode(0);
        assertGt(activeSharesHint.length, 0);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, activeSharesHint
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (,,, uint256 expectedAmount) = _splitDefaultFees(REWARD_AMOUNT);
        assertEq(reward.timestamp, TIMESTAMP);
        assertEq(reward.amountToDeposits, expectedAmount);
    }

    function test_DistributeVaultSnapshotRewards_WithIndependentActiveStakeHint() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        bytes memory activeSharesHint = new bytes(0);
        bytes memory activeStakeHint = abi.encode(0);

        vm.expectCall(
            address(vault), abi.encodeWithSelector(IVaultV2.activeSharesAt.selector, TIMESTAMP, activeSharesHint)
        );
        vm.expectCall(
            address(vault), abi.encodeWithSelector(IVaultV2.activeStakeAt.selector, TIMESTAMP, activeStakeHint)
        );

        vm.prank(network);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork,
            address(snapshotToken),
            address(vault),
            REWARD_AMOUNT,
            TIMESTAMP,
            _distributionHints(activeSharesHint, activeStakeHint, "", "", "")
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        (,,, uint256 expectedAmount) = _splitDefaultFees(REWARD_AMOUNT);
        assertEq(reward.timestamp, TIMESTAMP);
        assertEq(reward.amountToDeposits, expectedAmount);
    }

    /* CLAIM VAULT SNAPSHOT REWARDS TESTS */

    function test_ClaimVaultSnapshotRewards_Success() public {
        // First distribute rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        (,,, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmount = (100 * 10 ** 18 * netAmount) / (1000 * 10 ** 18);

        vm.expectEmit(true, true, true, true);
        emit IVaultSnapshotRewards.ClaimVaultSnapshotRewards(
            staker, network, address(snapshotToken), address(vault), expectedAmount, 0, 1
        );

        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(snapshotToken),
            address(vault),
            0, // lastUnclaimedRewards
            0, // firstRewardToClaim
            1, // maxRewards
            new bytes[](0) // activeSharesHints
        );

        assertEq(snapshotToken.balanceOf(recipient), expectedAmount);
        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(snapshotToken)), 1);
    }

    function test_ClaimVaultSnapshotRewards_WithHints() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        bytes memory activeSharesHint = abi.encode(0);
        assertGt(activeSharesHint.length, 0);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, activeSharesHint
        );

        bytes[] memory activeSharesHints = new bytes[](1);
        activeSharesHints[0] = abi.encode(0);
        assertGt(activeSharesHints[0].length, 0);

        (,,, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmount = (100 * 10 ** 18 * netAmount) / (1000 * 10 ** 18);

        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, activeSharesHints
        );

        assertEq(snapshotToken.balanceOf(recipient), expectedAmount);
    }

    function test_ClaimVaultSnapshotRewards_VaultV2_RoutesAllRewardsToWithdrawalsWhenActiveStakeHasNoShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint48 rewardTimestamp = uint48(block.timestamp + 1);

        vm.warp(rewardTimestamp);
        vm.prank(staker);
        vault.withdraw(staker, 100 * 10 ** 18);

        vm.warp(uint256(rewardTimestamp) + 1);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION)));
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeSharesAt.selector, rewardTimestamp, new bytes(0)),
            abi.encode(0)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeStakeAt.selector, rewardTimestamp, new bytes(0)),
            abi.encode(900 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalsAt.selector, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesAt.selector, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesOfAt.selector, staker, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );

        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, new bytes[](0)
        );

        (,,, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);
        assertEq(snapshotToken.balanceOf(recipient), netAmount);
    }

    function test_ClaimVaultSnapshotRewards_VaultV2_RoutesAllRewardsToDepositsWhenWithdrawalsHaveNoShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION)));
        vm.mockCall(
            address(vault), abi.encodeWithSelector(IVaultV2.activeWithdrawalsAt.selector, TIMESTAMP), abi.encode(1)
        );
        vm.mockCall(
            address(vault), abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesAt.selector, TIMESTAMP), abi.encode(0)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, new bytes[](0)
        );

        (,,, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmount = netAmount * 100 * 10 ** 18 / (1000 * 10 ** 18);

        assertEq(snapshotToken.balanceOf(recipient), expectedAmount);
    }

    function test_ClaimVaultSnapshotRewards_RevertWhen_InvalidRecipient() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IRewardsErrors.InvalidRecipient.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            address(0), // Invalid recipient
            network,
            address(snapshotToken),
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
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IRewardsErrors.InvalidLastUnclaimedReward.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(snapshotToken),
            address(vault),
            1, // Wrong lastUnclaimedRewards
            0,
            1,
            new bytes[](0)
        );
    }

    function test_ClaimVaultSnapshotRewards_RevertWhen_NoRewardsToClaim() public {
        vm.expectRevert(IRewardsErrors.NoRewardsToClaim.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, new bytes[](0)
        );
    }

    function test_ClaimVaultSnapshotRewards_RevertWhen_RewardIndexExceedsAvailableRewards() public {
        // First distribute some rewards to create a rewards array with length > 0
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Now try to claim with a reward index that exceeds the available rewards
        // rewardsByTokenNetwork.length will be 1, but we're trying to access index 2
        vm.expectRevert(IRewardsErrors.NoRewardsToClaim.selector);
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(snapshotToken),
            address(vault),
            0, // lastUnclaimedRewards
            2, // firstRewardToClaim - this will make rewardIndex = 2, which > rewardsByTokenNetwork.length (1)
            1,
            new bytes[](0)
        );
    }

    /* CLAIM CURATOR FEES TESTS */

    function test_ClaimCuratorFees_Success() public {
        // First distribute rewards to generate curator fees
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        (, uint256 expectedCuratorFee,,) = _splitDefaultFees(REWARD_AMOUNT);

        vm.expectEmit(true, true, true, true);
        emit ICuratorFees.ClaimCuratorFees(address(vault), address(snapshotToken), expectedCuratorFee);

        vm.prank(curator);
        vaultSnapshotRewards.claimCuratorFees(recipient, address(vault), address(snapshotToken));

        assertEq(snapshotToken.balanceOf(recipient), expectedCuratorFee);
    }

    function test_ClaimCuratorFees_RevertWhen_InvalidRecipient() public {
        vm.prank(curator);
        vm.expectRevert(IRewardsErrors.InvalidRecipient.selector);
        vaultSnapshotRewards.claimCuratorFees(address(0), address(vault), address(snapshotToken));
    }

    function test_ClaimCuratorFees_RevertWhen_NotCurator() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IRewardsErrors.NotCurator.selector);
        vm.prank(staker); // Not the curator
        vaultSnapshotRewards.claimCuratorFees(recipient, address(vault), address(snapshotToken));
    }

    function test_ClaimCuratorFees_RevertWhen_NoRewardsToClaim() public {
        vm.expectRevert(IRewardsErrors.NoRewardsToClaim.selector);
        vm.prank(curator);
        vaultSnapshotRewards.claimCuratorFees(recipient, address(vault), address(snapshotToken));
    }

    /* CLAIM OPERATOR FEES TESTS */

    function test_ClaimOperatorFees_NetworkRestakeDelegator_Success() public {
        // First distribute rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertGt(networkRestakeDelegator.totalOperatorNetworkShares(Subnetwork.subnetwork(network, SUBNETWORK_ID)), 0);
        assertGt(
            networkRestakeDelegator.totalOperatorNetworkSharesAt(
                Subnetwork.subnetwork(network, SUBNETWORK_ID), TIMESTAMP, new bytes(0)
            ),
            0
        );

        (,, uint256 operatorsFees,) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmount = ((50 * 10 ** 18 * operatorsFees) / (200 * 10 ** 18)) * 2;

        bytes[] memory operatorNetworkSharesHints = new bytes[](2);
        operatorNetworkSharesHints[0] = abi.encode(0);
        operatorNetworkSharesHints[1] = abi.encode(0);
        bytes[] memory totalOperatorNetworkSharesHint = new bytes[](2);
        totalOperatorNetworkSharesHint[0] = abi.encode(0);
        totalOperatorNetworkSharesHint[1] = abi.encode(0);
        bytes memory extraData = abi.encode(operatorNetworkSharesHints, totalOperatorNetworkSharesHint);

        vm.expectEmit(true, true, true, true);
        emit IVaultSnapshotRewards.ClaimOperatorFees(
            operator, network, address(snapshotToken), address(vault), expectedAmount, 0, 2
        );

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 2, extraData
        );

        assertEq(snapshotToken.balanceOf(recipient), expectedAmount);
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(snapshotToken)),
            2
        );
    }

    function test_ClaimOperatorFees_NetworkRestakeDelegator_ZeroTotalShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.startPrank(network);
        networkRestakeDelegator.setOperatorNetworkShares(subnetwork, operator, 0);
        networkRestakeDelegator.setOperatorNetworkShares(subnetwork, otherOperator, 0);
        uint48 rewardTimestamp = uint48(block.timestamp + 5);
        vm.warp(rewardTimestamp + 1);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );
        vm.stopPrank();

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);
        assertEq(reward.operatorsFees, 0);

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, new bytes(0)
        );

        assertEq(snapshotToken.balanceOf(recipient), 0);
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(snapshotToken)),
            1
        );
    }

    function test_ClaimOperatorFees_NetworkRestakeDelegator_WithHints() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        bytes memory activeSharesHint = abi.encode(0);
        assertGt(activeSharesHint.length, 0);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, activeSharesHint
        );

        bytes[] memory operatorNetworkSharesHints = new bytes[](1);
        operatorNetworkSharesHints[0] = abi.encode(0);
        assertGt(operatorNetworkSharesHints[0].length, 0);

        bytes[] memory totalOperatorNetworkSharesHints = new bytes[](1);
        totalOperatorNetworkSharesHints[0] = abi.encode(0);
        assertGt(totalOperatorNetworkSharesHints[0].length, 0);

        bytes memory extraData = abi.encode(operatorNetworkSharesHints, totalOperatorNetworkSharesHints);

        (,, uint256 operatorsFees,) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmount = (50 * 10 ** 18 * operatorsFees) / (200 * 10 ** 18);

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, extraData
        );

        assertEq(snapshotToken.balanceOf(recipient), expectedAmount);
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(snapshotToken)),
            1
        );
    }

    function test_ClaimOperatorFees_FullRestakeDelegator_ZeroFees() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(fullRestakeVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(fullRestakeVault), network, address(snapshotToken), 0);
        assertEq(reward.operatorsFees, 0);

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(fullRestakeVault), 0, 0, 1, new bytes(0)
        );

        assertEq(snapshotToken.balanceOf(recipient), 0);
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(
                operator, address(fullRestakeVault), network, address(snapshotToken)
            ),
            1
        );
    }

    function test_ClaimOperatorFees_OperatorSpecificDelegator_Success() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(operatorSpecificVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        (,, uint256 operatorsFees,) = _splitDefaultFees(REWARD_AMOUNT);

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(operatorSpecificVault), 0, 0, 1, new bytes(0)
        );

        assertEq(snapshotToken.balanceOf(recipient), operatorsFees);
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(
                operator, address(operatorSpecificVault), network, address(snapshotToken)
            ),
            1
        );
    }

    function test_ClaimOperatorFees_UniversalDelegator_Success() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint256 operatorAllocation = 50 * 10 ** 18;
        uint256 subnetworkFilled = 200 * 10 ** 18;

        _mockCurrentDelegatorAsUniversal(subnetwork, TIMESTAMP, 1, subnetworkFilled);
        vm.mockCall(
            address(networkRestakeDelegator),
            abi.encodeWithSignature(
                "getAllocatedAt(bytes32,address,uint48,uint48)", subnetwork, operator, uint48(0), TIMESTAMP
            ),
            abi.encode(operatorAllocation)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        (,, uint256 operatorsFees,) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmount = operatorAllocation * operatorsFees / subnetworkFilled;

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, new bytes(0)
        );

        assertEq(snapshotToken.balanceOf(recipient), expectedAmount);
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(snapshotToken)),
            1
        );
    }

    function test_ClaimOperatorFees_OperatorNetworkSpecificDelegator_Success() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(operatorNetworkVault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        (,, uint256 operatorsFees,) = _splitDefaultFees(REWARD_AMOUNT);

        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(operatorNetworkVault), 0, 0, 1, new bytes(0)
        );

        assertEq(snapshotToken.balanceOf(recipient), operatorsFees);
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(
                operator, address(operatorNetworkVault), network, address(snapshotToken)
            ),
            1
        );
    }

    function test_ClaimOperatorFees_RevertWhen_InvalidRecipient() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IRewardsErrors.InvalidRecipient.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            address(0), // Invalid recipient
            network,
            address(snapshotToken),
            address(vault),
            0,
            0,
            1,
            new bytes(0)
        );
    }

    function test_ClaimOperatorFees_RevertWhen_InvalidLastUnclaimedReward() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        vm.expectRevert(IRewardsErrors.InvalidLastUnclaimedReward.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient,
            network,
            address(snapshotToken),
            address(vault),
            1, // Wrong lastUnclaimedRewards
            0,
            1,
            new bytes(0)
        );
    }

    function test_ClaimOperatorFees_RevertWhen_NoRewardsToClaim() public {
        vm.expectRevert(IRewardsErrors.NoRewardsToClaim.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, new bytes(0)
        );
    }

    function test_ClaimOperatorFees_RevertWhen_RewardIndexExceedsAvailableRewards() public {
        // First distribute some rewards to create a rewards array with length > 0
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Now try to claim with a reward index that exceeds the available rewards
        // rewardsByTokenNetwork.length will be 1, but we're trying to access index 2
        vm.expectRevert(IRewardsErrors.NoRewardsToClaim.selector);
        vm.prank(operator);
        vaultSnapshotRewards.claimOperatorFees(
            recipient,
            network,
            address(snapshotToken),
            address(vault),
            0, // lastUnclaimedRewards
            2, // firstRewardToClaim - this will make rewardIndex = 2, which > rewardsByTokenNetwork.length (1)
            1,
            new bytes(0)
        );
    }

    function test_ClaimOperatorFees_RevertWhen_NotOperator() public {
        address wrongOperator = address(0x999);
        (IVault operatorVault, uint48 rewardTimestamp) = _deployOperatorSpecificVault(wrongOperator);

        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(operatorVault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );

        vm.expectRevert(IRewardsErrors.NotOperator.selector);
        vm.prank(operator); // Wrong operator
        vaultSnapshotRewards.claimOperatorFees(
            recipient, network, address(snapshotToken), address(operatorVault), 0, 0, 1, new bytes(0)
        );
    }

    /* VIEW FUNCTION TESTS */

    function test_RewardsLength() public {
        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(snapshotToken)), 0);

        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(snapshotToken)), 1);
    }

    function test_Rewards() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        IVaultSnapshotRewards.RewardDistribution memory reward =
            vaultSnapshotRewards.rewards(address(vault), network, address(snapshotToken), 0);

        assertEq(reward.subnetworkId, SUBNETWORK_ID);
        assertEq(reward.delegator, address(networkRestakeDelegator));
        assertEq(reward.delegatorType, 0);
        assertEq(reward.timestamp, TIMESTAMP);
    }

    function test_LastUnclaimedReward() public {
        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(snapshotToken)), 0);
    }

    function test_LastUnclaimedOperatorReward() public {
        assertEq(
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(snapshotToken)),
            0
        );
    }

    /* CLAIM REWARDS TESTS */

    function test_ClaimRewards_Success() public {
        // First distribute rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
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
        vaultSnapshotRewards.claimRewards(recipient, address(snapshotToken), data);

        (,,, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmount = (100 * 10 ** 18 * netAmount) / (1000 * 10 ** 18);
        assertEq(snapshotToken.balanceOf(recipient), expectedAmount);
    }

    function test_ClaimRewardsMany_Success() public {
        // First distribute rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint256 N = 75;
        for (uint256 i; i < N; ++i) {
            vm.prank(network);
            _distributeVaultSnapshotRewards(
                subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, uint48(TIMESTAMP + i), new bytes(0)
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
        vaultSnapshotRewards.claimRewards(recipient, address(snapshotToken), data);
    }

    /* EDGE CASES AND ERROR CONDITIONS */

    function test_MultipleDistributions() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        // First distribution
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Second distribution
        uint48 secondTimestamp = TIMESTAMP + 1;
        vm.warp(uint256(secondTimestamp) + 1);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, secondTimestamp, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(snapshotToken)), 2);
    }

    function test_PartialClaim() public {
        // Distribute multiple rewards
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        uint48 secondTimestamp = TIMESTAMP + 1;
        vm.warp(uint256(secondTimestamp) + 1);
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, secondTimestamp, new bytes(0)
        );

        // Claim only first reward
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(snapshotToken),
            address(vault),
            0,
            0,
            1, // maxRewards = 1
            new bytes[](0)
        );

        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(snapshotToken)), 1);

        // Claim second reward
        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient,
            network,
            address(snapshotToken),
            address(vault),
            1, // lastUnclaimedRewards = 1
            0,
            1,
            new bytes[](0)
        );

        assertEq(vaultSnapshotRewards.lastUnclaimedReward(staker, address(vault), network, address(snapshotToken)), 2);
    }

    function test_ClaimVaultSnapshotRewards_VaultV2_RewardsActiveWithdrawals() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        uint48 rewardTimestamp = uint48(block.timestamp + 1);
        vm.warp(rewardTimestamp);

        vm.prank(staker);
        vault.withdraw(staker, 100 * 10 ** 18);

        vm.warp(uint256(rewardTimestamp) + 1);

        vm.mockCall(address(vault), abi.encodeWithSignature("version()"), abi.encode(uint64(VAULT_V2_VERSION)));
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalsAt.selector, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesAt.selector, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );
        vm.mockCall(
            address(vault),
            abi.encodeWithSelector(IVaultV2.activeWithdrawalSharesOfAt.selector, staker, rewardTimestamp),
            abi.encode(100 * 10 ** 18)
        );

        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, rewardTimestamp, new bytes(0)
        );

        vm.warp(uint256(rewardTimestamp) + 2);

        vm.prank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(snapshotToken), address(vault), 0, 0, 1, new bytes[](0)
        );

        (,,, uint256 netAmount) = _splitDefaultFees(REWARD_AMOUNT);
        uint256 expectedAmount = netAmount * 100 * 10 ** 18 / (1000 * 10 ** 18);

        assertEq(snapshotToken.balanceOf(recipient), expectedAmount);
    }

    function test_CachedActiveShares() public {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);

        // First distribution caches active shares
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        // Second distribution with same timestamp should use cached value
        vm.prank(network);
        _distributeVaultSnapshotRewards(
            subnetwork, address(snapshotToken), address(vault), REWARD_AMOUNT, TIMESTAMP, new bytes(0)
        );

        assertEq(vaultSnapshotRewards.rewardsLength(address(vault), network, address(snapshotToken)), 2);
    }
}
