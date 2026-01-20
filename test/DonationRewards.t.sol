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

import {MockVaultV2} from "./mocks/MockVaultV2.sol";
import {Token} from "@symbioticfi/core/test/mocks/Token.sol";
import {SimpleRegistry} from "@symbioticfi/core/test/mocks/SimpleRegistry.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

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

contract DonationRewardsTest is Test {
    TestableDonationRewards donationRewards;
    Rewards rewards;
    FeeRegistry feeRegistry;
    CuratorRegistry curatorRegistry;
    SimpleRegistry vaultFactory;
    MockVaultV2 vault;
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
        vault = new MockVaultV2(address(token), owner);

        vm.prank(address(vault));
        vaultFactory.register();

        vm.prank(owner);
        curatorRegistry.setCurator(address(vault), curator);

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
    }

    function test_DistributeDonationRewards_AccountsFeesAndDeposits() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(vault), curatorFee);

        token.approve(address(donationRewards), amount);
        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 curatorFeeAmount = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedDeposit = afterProtocol - curatorFeeAmount;

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(vault), address(token), expectedDeposit);

        donationRewards.distributeDonationRewards(address(vault), amount);

        assertEq(vault.lastCaller(), address(donationRewards));
        assertEq(vault.lastOnBehalfOf(), address(0));
        assertEq(vault.lastAmount(), expectedDeposit);
        assertEq(donationRewards.protocolFees(address(token)), amount - afterProtocol);
        assertEq(donationRewards.curatorFees(address(vault), address(token)), curatorFeeAmount);
    }

    function test_DistributeDonationRewards_RevertWhen_NotVault() public {
        vm.expectRevert(IRewardsErrors.NotVault.selector);
        donationRewards.distributeDonationRewards(address(0xdeadbeef), 1);
    }

    function test_DistributeDonationRewards_RevertWhen_InsufficientReward() public {
        vm.expectRevert(IRewardsErrors.InsufficientReward.selector);
        donationRewards.distributeDonationRewards(address(vault), 0);
    }

    function test_Donate_DistributesDonationRewards() public {
        uint256 amount = 1000 ether;
        uint256 protocolFee = 100_000; // 10%
        uint256 curatorFee = 50_000; // 5%

        _setProtocolFee(protocolFee);

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(vault), curatorFee);

        token.transfer(address(vault), amount);
        vm.prank(address(vault));
        token.approve(address(rewards), amount);

        uint256 afterProtocol = amount - (amount * protocolFee / MAX_FEE);
        uint256 curatorFeeAmount = afterProtocol * curatorFee / MAX_FEE;
        uint256 expectedDeposit = afterProtocol - curatorFeeAmount;

        vm.expectEmit(true, true, true, true);
        emit IDonationRewards.DistributeDonationRewards(address(vault), address(token), expectedDeposit);

        vm.prank(address(vault));
        rewards.distributeDonationRewards(address(vault), amount);

        assertEq(vault.lastCaller(), address(rewards));
        assertEq(vault.lastOnBehalfOf(), address(0));
        assertEq(vault.lastAmount(), expectedDeposit);
        assertEq(rewards.protocolFees(address(token)), amount - afterProtocol);
        assertEq(rewards.curatorFees(address(vault), address(token)), curatorFeeAmount);
    }

    function test_ClaimCuratorFees_Success() public {
        uint256 amount = 500 ether;
        uint256 curatorFee = 100_000; // 10%

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(vault), curatorFee);

        token.approve(address(donationRewards), amount);
        donationRewards.distributeDonationRewards(address(vault), amount);

        uint256 expectedCuratorFee = amount * curatorFee / MAX_FEE;

        vm.expectEmit(true, true, true, true);
        emit ICuratorFees.ClaimCuratorFees(address(vault), address(token), expectedCuratorFee);

        vm.prank(curator);
        donationRewards.claimCuratorFees(recipient, address(vault), address(token));

        assertEq(token.balanceOf(recipient), expectedCuratorFee);
        assertEq(donationRewards.curatorFees(address(vault), address(token)), 0);
    }

    function test_ClaimCuratorFees_RevertWhen_NotCurator() public {
        uint256 amount = 500 ether;
        uint256 curatorFee = 100_000;

        vm.prank(curator);
        feeRegistry.setCuratorFee(address(vault), curatorFee);

        token.approve(address(donationRewards), amount);
        donationRewards.distributeDonationRewards(address(vault), amount);

        vm.expectRevert(IRewardsErrors.NotCurator.selector);
        vm.prank(nonCurator);
        donationRewards.claimCuratorFees(recipient, address(vault), address(token));
    }

    function _setProtocolFee(uint256 fee) internal {
        bytes32 feeId = keccak256(abi.encode("rewards", uint64(IRewards.RewardsType.DONATION)));
        vm.prank(owner);
        feeRegistry.setProtocolFee(feeId, true, fee);
    }
}
