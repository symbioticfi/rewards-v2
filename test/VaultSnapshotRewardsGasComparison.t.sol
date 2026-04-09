// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {RewardsV2TestBase} from "./RewardsV2TestBase.sol";

import {DefaultStakerRewards} from "./legacy/defaultStakerRewards/DefaultStakerRewards.sol";
import {IDefaultStakerRewards} from "./legacy/interfaces/defaultStakerRewards/IDefaultStakerRewards.sol";
import {VaultSnapshotRewards} from "../src/contracts/VaultSnapshotRewards.sol";
import {CuratorFees} from "../src/contracts/CuratorFees.sol";
import {ProtocolFees} from "../src/contracts/ProtocolFees.sol";
import {IVaultSnapshotRewards} from "../src/interfaces/IVaultSnapshotRewards.sol";

import {Subnetwork} from "@symbioticfi/core/src/contracts/libraries/Subnetwork.sol";
import {IBaseDelegator} from "@symbioticfi/core/src/interfaces/delegator/IBaseDelegator.sol";
import {INetworkRestakeDelegator} from "@symbioticfi/core/src/interfaces/delegator/INetworkRestakeDelegator.sol";
import {IVault} from "@symbioticfi/core/src/interfaces/vault/IVault.sol";
import {IVaultConfigurator} from "@symbioticfi/core/src/interfaces/IVaultConfigurator.sol";
import {IVaultTokenized} from "@symbioticfi/core/src/interfaces/vault/IVaultTokenized.sol";

interface IVaultHints {
    function activeSharesHint(address vault, uint48 timestamp) external view returns (bytes memory);

    function activeSharesOfHint(address vault, address account, uint48 timestamp) external view returns (bytes memory);

    function activeStakeHint(address vault, uint48 timestamp) external view returns (bytes memory);
}

/// @notice Minimal concrete VaultSnapshotRewards for testing.
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

contract VaultSnapshotRewardsGasComparisonTest is RewardsV2TestBase {
    DefaultStakerRewards legacyRewards;
    TestableVaultSnapshotRewards snapshotRewards;

    IVault vault;
    INetworkRestakeDelegator networkRestakeDelegator;

    address network = makeAddr("network");
    address middleware = makeAddr("middleware");
    address staker = makeAddr("staker");
    address recipient = makeAddr("recipient");
    address operator = makeAddr("operator");
    address otherOperator = makeAddr("otherOperator");

    uint256 constant REWARD_AMOUNT = 1000 * 10 ** 18;
    uint256 constant STAKE_AMOUNT = 1000 * 10 ** 18;
    uint256 constant DISTRIBUTION_DEPOSIT = 1 * 10 ** 18;
    uint256 constant NUM_DISTRIBUTIONS = 10;
    uint96 constant SUBNETWORK_ID = 0x123;
    uint64 constant NETWORK_RESTAKE_TYPE = 0;
    string constant TOKENIZED_VAULT_NAME = "VaultSnapshotRewardsGas";
    string constant TOKENIZED_VAULT_SYMBOL = "VSG";

    uint64 vaultVersion;
    uint48 rewardStartTimestamp;

    function setUp() public override {
        _deployRewardsInfra(address(this));

        vaultVersion = symbioticCore.vaultFactory.lastVersion();

        uint256 distributionBudget = REWARD_AMOUNT * NUM_DISTRIBUTIONS * 2;
        rewardsToken.transfer(middleware, distributionBudget);
        rewardsToken.transfer(network, distributionBudget);
        rewardsToken.transfer(staker, STAKE_AMOUNT + DISTRIBUTION_DEPOSIT * NUM_DISTRIBUTIONS);
        rewardsToken.transfer(operator, STAKE_AMOUNT);
        rewardsToken.transfer(otherOperator, STAKE_AMOUNT);

        vm.prank(network);
        symbioticCore.networkRegistry.registerNetwork();
        vm.prank(operator);
        symbioticCore.operatorRegistry.registerOperator();
        vm.prank(otherOperator);
        symbioticCore.operatorRegistry.registerOperator();

        (vault, networkRestakeDelegator) = _createNetworkRestakeVault();

        vm.prank(operator);
        symbioticCore.operatorVaultOptInService.optIn(address(vault));
        vm.prank(otherOperator);
        symbioticCore.operatorVaultOptInService.optIn(address(vault));
        vm.prank(operator);
        symbioticCore.operatorNetworkOptInService.optIn(network);
        vm.prank(otherOperator);
        symbioticCore.operatorNetworkOptInService.optIn(network);

        rewardStartTimestamp = uint48(block.timestamp + 25);
        vm.warp(rewardStartTimestamp);

        _deposit(address(vault), staker, STAKE_AMOUNT);

        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        vm.startPrank(network);
        networkRestakeDelegator.setMaxNetworkLimit(SUBNETWORK_ID, STAKE_AMOUNT * 2);
        networkRestakeDelegator.setNetworkLimit(subnetwork, STAKE_AMOUNT * 2);
        networkRestakeDelegator.setOperatorNetworkShares(subnetwork, operator, STAKE_AMOUNT);
        networkRestakeDelegator.setOperatorNetworkShares(subnetwork, otherOperator, STAKE_AMOUNT);
        symbioticCore.networkMiddlewareService.setMiddleware(middleware);
        vm.stopPrank();

        vm.warp(uint256(rewardStartTimestamp) + 1);

        snapshotRewards = new TestableVaultSnapshotRewards(
            address(symbioticCore.vaultFactory),
            address(symbioticCore.networkRegistry),
            address(symbioticCore.networkMiddlewareService),
            address(curatorRegistry),
            address(feeRegistry)
        );

        legacyRewards = new DefaultStakerRewards(
            address(symbioticCore.vaultFactory), address(symbioticCore.networkMiddlewareService)
        );
        legacyRewards.initialize(
            IDefaultStakerRewards.InitParams({
                vault: address(vault),
                adminFee: 0,
                defaultAdminRoleHolder: address(this),
                adminFeeClaimRoleHolder: address(this),
                adminFeeSetRoleHolder: address(this)
            })
        );

        vm.startPrank(middleware);
        rewardsToken.approve(address(snapshotRewards), type(uint256).max);
        rewardsToken.approve(address(legacyRewards), type(uint256).max);
        vm.stopPrank();
    }

    function test_LegacyDefaultStakerRewards_Claim50Distributions_Gas() public {
        _distributeLegacyRewards(NUM_DISTRIBUTIONS);

        vm.prank(staker);
        legacyRewards.claimRewards(
            recipient, address(rewardsToken), abi.encode(network, NUM_DISTRIBUTIONS, new bytes[](0))
        );
    }

    function test_LegacyDefaultStakerRewards_Claim50Distributions_WithHints_Gas() public {
        _distributeLegacyRewards(NUM_DISTRIBUTIONS);

        bytes[] memory activeSharesHints = new bytes[](NUM_DISTRIBUTIONS);
        for (uint256 i; i < NUM_DISTRIBUTIONS; ++i) {
            activeSharesHints[i] = abi.encode(i);
        }

        vm.prank(staker);
        legacyRewards.claimRewards(
            recipient, address(rewardsToken), abi.encode(network, NUM_DISTRIBUTIONS, activeSharesHints)
        );
    }

    function test_VaultSnapshotRewards_Claim50Distributions_Gas() public {
        _distributeSnapshotRewards(NUM_DISTRIBUTIONS);

        vm.prank(staker);
        snapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(rewardsToken), address(vault), 0, 0, NUM_DISTRIBUTIONS, new bytes[](0)
        );
    }

    function test_VaultSnapshotRewards_Claim50Distributions_WithHints_Gas() public {
        _distributeSnapshotRewards(NUM_DISTRIBUTIONS);

        bytes[] memory activeSharesHints = new bytes[](NUM_DISTRIBUTIONS);
        for (uint256 i; i < NUM_DISTRIBUTIONS; ++i) {
            activeSharesHints[i] = abi.encode(i);
        }

        vm.prank(staker);
        snapshotRewards.claimVaultSnapshotRewards(
            recipient, network, address(rewardsToken), address(vault), 0, 0, NUM_DISTRIBUTIONS, activeSharesHints
        );
    }

    function _distributionTimestamp(uint256 index) internal view returns (uint48) {
        return rewardStartTimestamp + 1 + uint48(index);
    }

    function _distributeLegacyRewards(uint256 distributions) internal {
        uint256 adminFeeBase = legacyRewards.ADMIN_FEE_BASE();
        for (uint256 i; i < distributions; ++i) {
            uint48 timestamp = _distributionTimestamp(i);
            vm.warp(timestamp);
            _deposit(address(vault), staker, DISTRIBUTION_DEPOSIT);
            vm.warp(uint256(timestamp) + 1);
            vm.prank(middleware);
            legacyRewards.distributeRewards(
                network,
                address(rewardsToken),
                REWARD_AMOUNT,
                abi.encode(timestamp, adminFeeBase, new bytes(0), new bytes(0))
            );
        }
    }

    function _distributeSnapshotRewards(uint256 distributions) internal {
        bytes32 subnetwork = Subnetwork.subnetwork(network, SUBNETWORK_ID);
        for (uint256 i; i < distributions; ++i) {
            uint48 timestamp = _distributionTimestamp(i);
            vm.warp(timestamp);
            _deposit(address(vault), staker, DISTRIBUTION_DEPOSIT);
            vm.warp(uint256(timestamp) + 1);
            vm.prank(middleware);
            snapshotRewards.distributeVaultSnapshotRewards(
                subnetwork,
                address(rewardsToken),
                address(vault),
                REWARD_AMOUNT,
                timestamp,
                abi.encode(
                    IVaultSnapshotRewards.DistributeVaultSnapshotRewardsHints({
                        activeSharesHint: new bytes(0),
                        activeStakeHint: new bytes(0),
                        curatorFeeHint: "",
                        operatorsFeeHint: "",
                        totalOperatorNetworkSharesHint: ""
                    })
                )
            );
        }
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

    function _deposit(address vault_, address depositor, uint256 amount) internal {
        vm.startPrank(depositor);
        rewardsToken.approve(vault_, type(uint256).max);
        IVault(vault_).deposit(depositor, amount);
        vm.stopPrank();
    }
}
