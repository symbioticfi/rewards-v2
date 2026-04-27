// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

import {DonationRewards} from "../src/contracts/DonationRewards.sol";
import {CuratorFees} from "../src/contracts/CuratorFees.sol";
import {ProtocolFees} from "../src/contracts/ProtocolFees.sol";
import {Rewards} from "../src/contracts/Rewards.sol";
import {CuratorRegistry} from "../src/contracts/CuratorRegistry.sol";
import {FeeRegistry} from "../src/contracts/FeeRegistry.sol";
import {IDonationRewards} from "../src/interfaces/IDonationRewards.sol";
import {ICuratorFees} from "../src/interfaces/ICuratorFees.sol";
import {IRewards} from "../src/interfaces/IRewards.sol";
import {IRewardsErrors} from "../src/interfaces/IRewardsErrors.sol";
import {IVaultV2 as LocalIVaultV2} from "../src/interfaces/IVaultV2.sol";
import {VaultV2 as CoreMirrorVaultV2} from "@symbioticfi/core/src/contracts/vault/VaultV2.sol";
import {
    IVaultV2 as CoreMirrorIVaultV2,
    VAULT_V2_VERSION as CORE_MIRROR_VAULT_V2_VERSION
} from "@symbioticfi/core/src/interfaces/vault/IVaultV2.sol";

import {Token} from "@symbioticfi/core/test/mocks/Token.sol";
import {SimpleRegistry} from "@symbioticfi/core/test/mocks/SimpleRegistry.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract TestableDonationRewards is DonationRewards {
    constructor(address vaultFactory, address curatorRegistry, address feeRegistry)
        DonationRewards(vaultFactory)
        CuratorFees(curatorRegistry)
        ProtocolFees(feeRegistry)
    {}

    function initialize(address owner) external initializer {
        __ProtocolFees_init(owner);
    }

    function claimRewards(address, address, bytes calldata) external pure override {
        revert("DonationRewards: claimRewards not supported");
    }
}

contract MockLegacyVault {
    address public immutable vaultOwner;

    constructor(address owner_) {
        vaultOwner = owner_;
    }

    function owner() external view returns (address) {
        return vaultOwner;
    }

    function version() external pure returns (uint64) {
        return 1;
    }
}

contract DonationRewardsTest is Test {
    using Math for uint256;

    TestableDonationRewards donationRewards;
    Rewards rewards;
    FeeRegistry feeRegistry;
    CuratorRegistry curatorRegistry;
    SimpleRegistry vaultFactory;
    CoreMirrorVaultV2 donationVault;
    CoreMirrorVaultV2 rewardsVault;
    Token token;

    address owner;
    address curator;
    address nonCurator;
    address recipient;

    uint256 constant MAX_FEE = 1_000_000;

    function setUp() public {
        owner = makeAddr("owner");
        curator = makeAddr("curator");
        nonCurator = makeAddr("nonCurator");
        recipient = makeAddr("recipient");

        vaultFactory = new SimpleRegistry();

        curatorRegistry = new CuratorRegistry(address(vaultFactory));
        curatorRegistry = CuratorRegistry(
            address(
                new TransparentUpgradeableProxy(
                    address(curatorRegistry), address(this), abi.encodeCall(curatorRegistry.initialize, ())
                )
            )
        );

        feeRegistry = new FeeRegistry(address(curatorRegistry));
        feeRegistry = FeeRegistry(
            address(
                new TransparentUpgradeableProxy(
                    address(feeRegistry), address(this), abi.encodeCall(feeRegistry.initialize, (owner))
                )
            )
        );

        token = new Token("DonationToken");

        donationRewards =
            new TestableDonationRewards(address(vaultFactory), address(curatorRegistry), address(feeRegistry));
        donationRewards = TestableDonationRewards(
            address(
                new TransparentUpgradeableProxy(
                    address(donationRewards), address(this), abi.encodeCall(donationRewards.initialize, (owner))
                )
            )
        );

        rewards =
            new Rewards(address(vaultFactory), address(0), address(0), address(curatorRegistry), address(feeRegistry));
        rewards = Rewards(
            address(
                new TransparentUpgradeableProxy(
                    address(rewards), address(this), abi.encodeCall(rewards.initialize, (owner))
                )
            )
        );

        donationVault = _deployVault(address(donationRewards));
        rewardsVault = _deployVault(address(rewards));
    }

    function test_DistributeDonationRewards_AccountsFeesAndDeposits() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(donationVault), curatorFee);

        _seedVault(donationVault, 1 ether);

        token.approve(address(donationRewards), amount);
        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 curatorFeeAmount = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedDeposit = afterProtocol - curatorFeeAmount;
        uint256 stakeBefore = donationVault.totalStake();

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(this), address(donationVault), expectedDeposit);

        donationRewards.distributeDonationRewards(address(donationVault), amount);

        assertEq(donationVault.totalStake(), stakeBefore + expectedDeposit);
        assertEq(donationRewards.protocolFees(address(token)), amount - afterProtocol);
        assertEq(donationRewards.curatorFees(address(donationVault), address(token)), curatorFeeAmount);
    }

    function test_DistributeDonationRewards_UsesAdapterSpecificProtocolFee() public {
        uint256 amount = 1000 ether;
        uint256 defaultProtocolFee = 100_000; // 10%
        uint256 adapterProtocolFee = 200_000; // 20%

        _setProtocolFee(defaultProtocolFee);
        _setProtocolFee(address(this), adapterProtocolFee);

        _seedVault(donationVault, 1 ether);

        token.approve(address(donationRewards), amount);
        uint256 expectedDeposit = amount - (amount * adapterProtocolFee / MAX_FEE);
        uint256 stakeBefore = donationVault.totalStake();

        donationRewards.distributeDonationRewards(address(donationVault), amount);

        assertEq(donationVault.totalStake(), stakeBefore + expectedDeposit);
        assertEq(donationRewards.protocolFees(address(token)), amount - expectedDeposit);
    }

    function test_DistributeDonationRewards_UsesAdapterSpecificCuratorFee() public {
        uint256 amount = 1000 ether;
        uint256 defaultCuratorFee = 50_000; // 5%
        uint256 adapterCuratorFee = 100_000; // 10%

        vm.startPrank(curator);
        feeRegistry.setCuratorFee(address(donationVault), defaultCuratorFee);
        feeRegistry.setCuratorNetworkFee(address(donationVault), address(this), true, adapterCuratorFee);
        vm.stopPrank();

        _seedVault(donationVault, 1 ether);

        token.approve(address(donationRewards), amount);
        uint256 expectedCuratorFee = amount * adapterCuratorFee / MAX_FEE;
        uint256 expectedDeposit = amount - expectedCuratorFee;
        uint256 stakeBefore = donationVault.totalStake();

        donationRewards.distributeDonationRewards(address(donationVault), amount);

        assertEq(donationVault.totalStake(), stakeBefore + expectedDeposit);
        assertEq(donationRewards.curatorFees(address(donationVault), address(token)), expectedCuratorFee);
    }

    function test_DistributeDonationRewards_EmptyVault_AccountsNetAmountAsProtocolFees() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(donationVault), curatorFee);

        token.approve(address(donationRewards), amount);
        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 expectedCuratorFee = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedProtocolFee = amount - expectedCuratorFee;

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(this), address(donationVault), 0);

        donationRewards.distributeDonationRewards(address(donationVault), amount);

        assertEq(donationVault.totalStake(), 0);
        assertEq(donationRewards.protocolFees(address(token)), expectedProtocolFee);
        assertEq(donationRewards.curatorFees(address(donationVault), address(token)), expectedCuratorFee);
        assertEq(token.balanceOf(address(donationRewards)), amount);
    }

    function test_DistributeDonationRewards_ActiveStakeWithoutShares_DonatesWhenVaultHasStake() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%
        uint256 seedAmount = 1 ether;

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(donationVault), curatorFee);

        _seedVault(donationVault, seedAmount);
        _mockCurrentVaultState(donationVault, seedAmount, 0, 0, 0);

        token.approve(address(donationRewards), amount);
        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 expectedCuratorFee = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedProtocolFee = amount - afterProtocol;
        uint256 expectedDeposit = afterProtocol - expectedCuratorFee;
        uint256 stakeBefore = donationVault.totalStake();

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(this), address(donationVault), expectedDeposit);

        donationRewards.distributeDonationRewards(address(donationVault), amount);

        assertEq(donationVault.totalStake(), stakeBefore + expectedDeposit);
        assertEq(donationRewards.protocolFees(address(token)), expectedProtocolFee);
        assertEq(donationRewards.curatorFees(address(donationVault), address(token)), expectedCuratorFee);
        assertEq(token.balanceOf(address(donationRewards)), expectedProtocolFee + expectedCuratorFee);
    }

    function test_DistributeDonationRewards_ActiveWithdrawalsWithoutShares_DonatesWhenVaultHasStake() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%
        uint256 withdrawAmount = 1 ether;

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(donationVault), curatorFee);

        _seedVault(donationVault, withdrawAmount);
        donationVault.withdraw(address(this), withdrawAmount);
        _mockCurrentVaultState(donationVault, 0, 0, withdrawAmount, 0);

        token.approve(address(donationRewards), amount);
        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 expectedCuratorFee = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedProtocolFee = amount - afterProtocol;
        uint256 expectedDeposit = afterProtocol - expectedCuratorFee;
        uint256 stakeBefore = donationVault.totalStake();

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(this), address(donationVault), expectedDeposit);

        donationRewards.distributeDonationRewards(address(donationVault), amount);

        assertEq(donationVault.totalStake(), stakeBefore + expectedDeposit);
        assertEq(donationRewards.protocolFees(address(token)), expectedProtocolFee);
        assertEq(donationRewards.curatorFees(address(donationVault), address(token)), expectedCuratorFee);
        assertEq(token.balanceOf(address(donationRewards)), expectedProtocolFee + expectedCuratorFee);
    }

    function test_DistributionAmountConversions_UseAdapterSpecificProtocolFee() public {
        uint256 distributionAmount = 800 ether;
        uint256 defaultProtocolFee = 100_000; // 10%
        uint256 adapterProtocolFee = 200_000; // 20%

        _setProtocolFee(defaultProtocolFee);
        _setProtocolFee(address(this), adapterProtocolFee);

        uint256 expectedTotal = (distributionAmount - 1).mulDiv(MAX_FEE, MAX_FEE - adapterProtocolFee) + 1;
        uint256 totalAmount = donationRewards.distributionToTotalAmount(0, address(this), distributionAmount);

        assertEq(totalAmount, expectedTotal);
        assertEq(donationRewards.totalToDistributionAmount(0, address(this), totalAmount), distributionAmount);
        assertEq(donationRewards.distributionToTotalAmount(0, address(this), 0), 0);
    }

    function test_DistributeDonationRewards_RevertWhen_NotVault() public {
        vm.expectRevert(IRewardsErrors.NotVault.selector);
        donationRewards.distributeDonationRewards(address(0xdeadbeef), 1);
    }

    function test_DistributeDonationRewards_RevertWhen_NoDonationSupport() public {
        MockLegacyVault legacyVault = new MockLegacyVault(owner);

        vm.prank(address(legacyVault));
        vaultFactory.register();

        vm.expectRevert(IRewardsErrors.NoDonationSupport.selector);
        donationRewards.distributeDonationRewards(address(legacyVault), 1);
    }

    function test_DistributeDonationRewards_RevertWhen_InsufficientReward() public {
        vm.expectRevert(IRewardsErrors.InsufficientReward.selector);
        donationRewards.distributeDonationRewards(address(donationVault), 0);
    }

    function test_Donate_DistributesDonationRewards() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(rewardsVault), curatorFee);

        _seedVault(rewardsVault, 1 ether);

        token.transfer(address(rewardsVault), amount);
        vm.prank(address(rewardsVault));
        token.approve(address(rewards), amount);

        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 curatorFeeAmount = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedDeposit = afterProtocol - curatorFeeAmount;
        uint256 stakeBefore = rewardsVault.totalStake();

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(rewardsVault), address(rewardsVault), expectedDeposit);

        vm.prank(address(rewardsVault));
        rewards.distributeDonationRewards(address(rewardsVault), amount);

        assertEq(rewardsVault.totalStake(), stakeBefore + expectedDeposit);
        assertEq(rewards.protocolFees(address(token)), amount - afterProtocol);
        assertEq(rewards.curatorFees(address(rewardsVault), address(token)), curatorFeeAmount);
    }

    function test_Donate_ToEmptyVault_AccountsNetAmountAsProtocolFees() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(rewardsVault), curatorFee);

        token.transfer(address(rewardsVault), amount);
        vm.prank(address(rewardsVault));
        token.approve(address(rewards), amount);

        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 expectedCuratorFee = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedProtocolFee = amount - expectedCuratorFee;

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(rewardsVault), address(rewardsVault), 0);

        vm.prank(address(rewardsVault));
        rewards.distributeDonationRewards(address(rewardsVault), amount);

        assertEq(rewardsVault.totalStake(), 0);
        assertEq(rewards.protocolFees(address(token)), expectedProtocolFee);
        assertEq(rewards.curatorFees(address(rewardsVault), address(token)), expectedCuratorFee);
        assertEq(token.balanceOf(address(rewards)), amount);
    }

    function test_Donate_ActiveStakeWithoutShares_DonatesWhenVaultHasStake() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%
        uint256 seedAmount = 1 ether;

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(rewardsVault), curatorFee);

        _seedVault(rewardsVault, seedAmount);
        _mockCurrentVaultState(rewardsVault, seedAmount, 0, 0, 0);

        token.transfer(address(rewardsVault), amount);
        vm.prank(address(rewardsVault));
        token.approve(address(rewards), amount);

        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 expectedCuratorFee = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedProtocolFee = amount - afterProtocol;
        uint256 expectedDeposit = afterProtocol - expectedCuratorFee;
        uint256 stakeBefore = rewardsVault.totalStake();

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(rewardsVault), address(rewardsVault), expectedDeposit);

        vm.prank(address(rewardsVault));
        rewards.distributeDonationRewards(address(rewardsVault), amount);

        assertEq(rewardsVault.totalStake(), stakeBefore + expectedDeposit);
        assertEq(rewards.protocolFees(address(token)), expectedProtocolFee);
        assertEq(rewards.curatorFees(address(rewardsVault), address(token)), expectedCuratorFee);
        assertEq(token.balanceOf(address(rewards)), expectedProtocolFee + expectedCuratorFee);
    }

    function test_ClaimCuratorFees_Success() public {
        uint256 amount = 500 ether;
        uint256 curatorFee = 100_000; // 10%

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(donationVault), curatorFee);

        token.approve(address(donationRewards), amount);
        donationRewards.distributeDonationRewards(address(donationVault), amount);

        uint256 expectedCuratorFee = amount * curatorFee / MAX_FEE;

        vm.expectEmit(true, true, true, true);
        emit ICuratorFees.ClaimCuratorFees(address(donationVault), address(token), expectedCuratorFee);

        vm.prank(curator);
        donationRewards.claimCuratorFees(recipient, address(donationVault), address(token));

        assertEq(token.balanceOf(recipient), expectedCuratorFee);
        assertEq(donationRewards.curatorFees(address(donationVault), address(token)), 0);
    }

    function test_ClaimCuratorFees_RevertWhen_NotCurator() public {
        uint256 amount = 500 ether;
        uint256 curatorFee = 100_000;

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(donationVault), curatorFee);

        token.approve(address(donationRewards), amount);
        donationRewards.distributeDonationRewards(address(donationVault), amount);

        vm.expectRevert(IRewardsErrors.NotCurator.selector);
        vm.prank(nonCurator);
        donationRewards.claimCuratorFees(recipient, address(donationVault), address(token));
    }

    function _deployVault(address rewards_) internal returns (CoreMirrorVaultV2 vault_) {
        CoreMirrorVaultV2 implementation = new CoreMirrorVaultV2(
            address(0), address(0), address(vaultFactory), address(feeRegistry), rewards_, address(0), address(0)
        );

        vault_ = CoreMirrorVaultV2(
            address(
                new TransparentUpgradeableProxy(
                    address(implementation),
                    address(this),
                    abi.encodeWithSignature(
                        "initialize(uint64,address,bytes)",
                        CORE_MIRROR_VAULT_V2_VERSION,
                        owner,
                        abi.encode(
                            CoreMirrorIVaultV2.InitParams({
                                name: "Donation Vault",
                                symbol: "dVLT",
                                collateral: address(token),
                                burner: address(0xdead),
                                epochDuration: 1 days,
                                depositWhitelist: false,
                                depositorToWhitelist: owner,
                                isDepositLimit: false,
                                depositLimit: type(uint256).max,
                                defaultAdminRoleHolder: owner,
                                depositWhitelistSetRoleHolder: owner,
                                depositorWhitelistRoleHolder: owner,
                                isDepositLimitSetRoleHolder: owner,
                                depositLimitSetRoleHolder: owner,
                                setAdapterLimitRoleHolder: owner,
                                swapAdaptersRoleHolder: owner,
                                allocateAdapterRoleHolder: owner,
                                deallocateAdapterRoleHolder: owner
                            })
                        )
                    )
                )
            )
        );

        vm.prank(address(vault_));
        vaultFactory.register();

        vm.prank(owner);
        curatorRegistry.setCurator(address(vault_), curator);
    }

    function _seedVault(CoreMirrorVaultV2 vault_, uint256 amount) internal {
        token.approve(address(vault_), amount);
        vault_.deposit(address(this), amount);
    }

    function _mockCurrentVaultState(
        CoreMirrorVaultV2 vault_,
        uint256 activeStake,
        uint256 activeShares,
        uint256 activeWithdrawals,
        uint256 activeWithdrawalShares
    ) internal {
        uint48 currentTimestamp = uint48(block.timestamp);

        vm.mockCall(
            address(vault_),
            abi.encodeWithSelector(LocalIVaultV2.activeStakeAt.selector, currentTimestamp, new bytes(0)),
            abi.encode(activeStake)
        );
        vm.mockCall(
            address(vault_),
            abi.encodeWithSelector(LocalIVaultV2.activeSharesAt.selector, currentTimestamp, new bytes(0)),
            abi.encode(activeShares)
        );
        vm.mockCall(
            address(vault_),
            abi.encodeWithSelector(LocalIVaultV2.activeWithdrawalsAt.selector, currentTimestamp),
            abi.encode(activeWithdrawals)
        );
        vm.mockCall(
            address(vault_),
            abi.encodeWithSelector(LocalIVaultV2.activeWithdrawalSharesAt.selector, currentTimestamp),
            abi.encode(activeWithdrawalShares)
        );
    }

    function _setProtocolFee(uint256 fee) internal {
        _setProtocolFee(address(0), fee);
    }

    function _setProtocolFee(address adapter, uint256 fee) internal {
        bytes32 feeId = adapter == address(0)
            ? keccak256(abi.encode("rewards", uint64(IRewards.RewardsType.DONATION)))
            : keccak256(abi.encode("rewards", uint64(IRewards.RewardsType.DONATION), adapter));
        vm.prank(owner);
        feeRegistry.setProtocolFee(feeId, true, fee);
    }
}
