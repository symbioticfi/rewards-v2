// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SymbioticCoreInit} from "@symbioticfi/core/test/integration/SymbioticCoreInit.sol";
import {VaultSnapshotRewards} from "../../../src/contracts/VaultSnapshotRewards.sol";
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

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

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
    uint256 public totalRewardsClaimedAmount;
    uint256 public totalFeesClaimedAmount;

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

        vm.startPrank(staker);
        vaultSnapshotRewards.claimVaultSnapshotRewards(
            staker, network, address(rewardsToken), address(vault), lastUnclaimed, 0, type(uint256).max, new bytes[](0)
        );
        vm.stopPrank();

        totalRewardsClaimedAmount += rewardsToken.balanceOf(staker) - balanceBefore;
    }

    function distributeRewards(uint256 seed) public adjustTimestamp(seed) {
        uint256 amount = _bound(seed, 1 * 10 ** 18, MAX_DEPOSIT_AMOUNT);
        address distributor = seed % 2 == 0 ? network : middleware;
        _ensureBalance(distributor, amount);

        uint256 balanceBefore = rewardsToken.balanceOf(address(vaultSnapshotRewards));
        vm.prank(distributor);
        vaultSnapshotRewards.distributeVaultSnapshotRewards(
            subnetwork, address(rewardsToken), address(vault), amount, lastStakeTimestamp, new bytes(0)
        );
        uint256 balanceAfter = rewardsToken.balanceOf(address(vaultSnapshotRewards));
        if (balanceAfter > balanceBefore) {
            totalDepositedAmount += balanceAfter - balanceBefore;
        }
    }

    function claimCuratorFee(uint256 seed) public adjustTimestamp(seed) {
        uint256 balanceBefore = rewardsToken.balanceOf(curator);

        vm.startPrank(curator);
        vaultSnapshotRewards.claimCuratorFee(curator, address(vault), address(rewardsToken));
        vm.stopPrank();

        totalFeesClaimedAmount += rewardsToken.balanceOf(curator) - balanceBefore;
    }

    function claimOperatorFee(uint256 seed) public adjustTimestamp(seed) {
        address operator = operators[seed % operators.length];
        uint256 balanceBefore = rewardsToken.balanceOf(operator);
        uint256 lastUnclaimed =
            vaultSnapshotRewards.lastUnclaimedOperatorReward(operator, address(vault), network, address(rewardsToken));

        vm.startPrank(operator);
        vaultSnapshotRewards.claimOperatorFee(
            operator, network, address(rewardsToken), address(vault), lastUnclaimed, 0, type(uint256).max, new bytes(0)
        );
        vm.stopPrank();

        totalFeesClaimedAmount += rewardsToken.balanceOf(operator) - balanceBefore;
    }

    function claimProtocolFees(uint256 seed) public adjustTimestamp(seed) {
        uint256 balanceBefore = rewardsToken.balanceOf(address(this));
        vaultSnapshotRewards.claimProtocolFees(address(this), address(rewardsToken));
        totalFeesClaimedAmount += rewardsToken.balanceOf(address(this)) - balanceBefore;
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
}
