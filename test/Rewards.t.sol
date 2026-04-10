// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Vm} from "forge-std/Vm.sol";

import {Rewards} from "../src/contracts/Rewards.sol";
import {CuratorRegistry} from "../src/contracts/CuratorRegistry.sol";
import {FeeRegistry} from "../src/contracts/FeeRegistry.sol";
import {IRewards} from "../src/interfaces/IRewards.sol";
import {ICumulativeMerkleRewards} from "../src/interfaces/ICumulativeMerkleRewards.sol";
import {IRewardsErrors} from "../src/interfaces/IRewardsErrors.sol";
import {IVaultV2} from "../src/interfaces/IVaultV2.sol";
import {IVaultSnapshotRewards} from "../src/interfaces/IVaultSnapshotRewards.sol";

import {RewardsV2TestBase} from "./RewardsV2TestBase.sol";
import {MerkleTreeUtils} from "./utils/MerkleTreeUtils.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Subnetwork} from "@symbioticfi/core/src/contracts/libraries/Subnetwork.sol";
import {IVault} from "@symbioticfi/core/src/interfaces/vault/IVault.sol";
import {IVaultTokenized} from "@symbioticfi/core/src/interfaces/vault/IVaultTokenized.sol";
import {IVaultConfigurator} from "@symbioticfi/core/src/interfaces/IVaultConfigurator.sol";
import {IBaseDelegator} from "@symbioticfi/core/src/interfaces/delegator/IBaseDelegator.sol";
import {INetworkRestakeDelegator} from "@symbioticfi/core/src/interfaces/delegator/INetworkRestakeDelegator.sol";
import {SimpleRegistry} from "@symbioticfi/core/test/mocks/SimpleRegistry.sol";

import {MockVaultV2} from "./mocks/MockVaultV2.sol";

contract RewardsTest is RewardsV2TestBase {
    struct SnapshotScenario {
        address network;
        address staker;
        address recipient;
        IVault vault;
        bytes32 subnetwork;
        uint48 rewardTimestamp;
        uint256 totalDistributionAmount;
        uint256 expectedClaimAmount;
    }

    struct CumulativeScenario {
        address network;
        address rewarder;
        address claimant;
        address recipient;
        ICumulativeMerkleRewards.CumulativeDistributionLeaf leaf;
        bytes32 root;
        bytes32[] proof;
        uint256 distributionAmount;
        uint256 totalDistributionAmount;
    }

    bytes32 internal constant TOKEN_AMOUNT_TYPEHASH =
        keccak256("TokenAmount(uint64 chainId,address token,uint256 amount)");
    bytes32 internal constant CUMULATIVE_DISTRIBUTION_PAYLOAD_TYPEHASH = keccak256(
        "CumulativeDistributionPayload(address network,uint48 timestamp,bytes32 merkleRoot,TokenAmount[] totalAmounts)TokenAmount(uint64 chainId,address token,uint256 amount)"
    );
    uint96 internal constant SNAPSHOT_SUBNETWORK_ID = 1;
    uint256 internal constant SNAPSHOT_STAKE_AMOUNT = 1000 ether;
    uint256 internal constant CUMULATIVE_PROTOCOL_KEY = 1;
    uint256 internal constant CUMULATIVE_REWARDER_KEY = 2;

    Rewards rewards;
    MerkleTreeUtils merkleUtils;

    address internal constant NETWORK = address(0x123);
    uint256 internal constant SNAPSHOT_FEE = 50_000; // 5%
    uint256 internal constant MERKLE_FEE = 70_000; // 7%

    function setUp() public override {
        _deployRewardsInfra(address(this));
        rewards = new Rewards(
            address(symbioticCore.vaultFactory),
            address(symbioticCore.networkRegistry),
            address(symbioticCore.networkMiddlewareService),
            address(curatorRegistry),
            address(feeRegistry)
        );

        rewards = Rewards(
            address(
                new TransparentUpgradeableProxy(
                    address(rewards), address(this), abi.encodeCall(rewards.initialize, (address(this)))
                )
            )
        );
        merkleUtils = new MerkleTreeUtils();
    }

    function test_Constructor() public {
        // Test constructor parameters are set correctly
        assertEq(address(rewards.VAULT_FACTORY()), address(symbioticCore.vaultFactory));
        assertEq(address(rewards.NETWORK_REGISTRY()), address(symbioticCore.networkRegistry));
        assertEq(address(rewards.NETWORK_MIDDLEWARE_SERVICE()), address(symbioticCore.networkMiddlewareService));
        assertEq(address(rewards.CURATOR_REGISTRY()), address(curatorRegistry));
    }

    function test_Initialize() public {
        // Create a new rewards contract for this test
        Rewards newRewards = new Rewards(
            address(symbioticCore.vaultFactory),
            address(symbioticCore.networkRegistry),
            address(symbioticCore.networkMiddlewareService),
            address(curatorRegistry),
            address(feeRegistry)
        );

        address newOwner = makeAddr("newOwner");

        newRewards = Rewards(
            address(
                new TransparentUpgradeableProxy(
                    address(newRewards), address(this), abi.encodeCall(newRewards.initialize, (newOwner))
                )
            )
        );

        assertEq(newRewards.owner(), newOwner);
        (, string memory name, string memory version,,,,) = newRewards.eip712Domain();
        assertEq(name, "CumulativeMerkleRewards");
        assertEq(version, "1");
    }

    function test_ClaimRewards_VaultSnapshot() public {
        // Prepare vault snapshot reward data
        bytes memory vaultSnapshotData =
            abi.encode(address(1), address(2), uint256(1000), uint256(0), uint256(0), new bytes[](1));

        // Encode reward type + data
        bytes memory data = abi.encodePacked(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), vaultSnapshotData);

        // We only test that the function routes correctly
        vm.expectRevert(IRewardsErrors.InvalidLastUnclaimedReward.selector); // This will revert due to missing setup, but shows routing works
        rewards.claimRewards(address(this), address(rewardsToken), data);
    }

    function test_ClaimRewards_CumulativeMerkle() public {
        ICumulativeMerkleRewards.CumulativeDistributionLeaf memory leaf;
        bytes32[] memory proof = new bytes32[](1);
        bytes memory cumulativeDistributionData = abi.encode(address(1), keccak256("root"), leaf, proof);

        // Encode reward type + data
        bytes memory data = abi.encodePacked(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), cumulativeDistributionData);

        // We only test that the function routes correctly
        vm.expectRevert(IRewardsErrors.InvalidToken.selector); // This will revert due to missing setup, but shows routing works
        rewards.claimRewards(address(this), address(rewardsToken), data);
    }

    function test_ClaimRewards_InvalidRewardType() public {
        // Create data with an unsupported reward type (e.g., 2)
        bytes memory invalidData = abi.encodePacked(uint64(2), "some data");

        // Expect the function to revert with InvalidRewardType error
        vm.expectRevert(IRewards.InvalidRewardType.selector);
        rewards.claimRewards(address(this), address(rewardsToken), invalidData);
    }

    function test_ClaimRewards_VaultSnapshot_EndToEnd() public {
        SnapshotScenario memory scenario = _setupSnapshotScenario(1000 ether);

        bytes memory data = abi.encodePacked(
            uint64(IRewards.RewardsType.VAULT_SNAPSHOT),
            abi.encode(scenario.network, address(scenario.vault), uint256(0), uint256(0), uint256(1), new bytes[](0))
        );

        uint256 balanceBefore = rewardsToken.balanceOf(scenario.recipient);

        vm.prank(scenario.staker);
        rewards.claimRewards(scenario.recipient, address(rewardsToken), data);

        assertEq(rewardsToken.balanceOf(scenario.recipient) - balanceBefore, scenario.expectedClaimAmount);
        assertEq(
            rewards.lastUnclaimedReward(
                scenario.staker, address(scenario.vault), scenario.network, address(rewardsToken)
            ),
            1
        );
    }

    function test_ClaimRewards_CumulativeMerkle_EndToEnd() public {
        CumulativeScenario memory scenario = _setupCumulativeScenario(makeAddr("cumulative-claimant"), 500 ether);

        bytes memory data = abi.encodePacked(
            uint64(IRewards.RewardsType.CUMULATIVE_MERKLE),
            abi.encode(scenario.network, scenario.root, scenario.leaf, scenario.proof)
        );

        uint256 balanceBefore = rewardsToken.balanceOf(scenario.recipient);

        vm.prank(scenario.claimant);
        rewards.claimRewards(scenario.recipient, address(rewardsToken), data);

        assertEq(rewardsToken.balanceOf(scenario.recipient) - balanceBefore, scenario.distributionAmount);
        assertEq(
            rewards.claimed(scenario.network, address(rewardsToken), scenario.claimant, scenario.leaf.rewardeeType),
            scenario.distributionAmount
        );
    }

    function test_ClaimRewards_VaultSnapshot_TruncatedPayloadReverts() public {
        SnapshotScenario memory scenario = _setupSnapshotScenario(1000 ether);
        uint256 recipientBalanceBefore = rewardsToken.balanceOf(scenario.recipient);
        uint256 lastUnclaimedBefore = rewards.lastUnclaimedReward(
            scenario.staker, address(scenario.vault), scenario.network, address(rewardsToken)
        );
        bytes memory data = abi.encodePacked(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), hex"01");

        vm.prank(scenario.staker);
        vm.expectRevert();
        rewards.claimRewards(scenario.recipient, address(rewardsToken), data);

        assertEq(rewardsToken.balanceOf(scenario.recipient), recipientBalanceBefore);
        assertEq(
            rewards.lastUnclaimedReward(
                scenario.staker, address(scenario.vault), scenario.network, address(rewardsToken)
            ),
            lastUnclaimedBefore
        );
    }

    function test_ClaimRewards_CumulativeMerkle_TruncatedPayloadReverts() public {
        CumulativeScenario memory scenario = _setupCumulativeScenario(makeAddr("truncated-claimant"), 500 ether);
        uint256 recipientBalanceBefore = rewardsToken.balanceOf(scenario.recipient);
        uint256 claimedBefore =
            rewards.claimed(scenario.network, address(rewardsToken), scenario.claimant, scenario.leaf.rewardeeType);
        bytes memory data = abi.encodePacked(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), hex"01");

        vm.prank(scenario.claimant);
        vm.expectRevert();
        rewards.claimRewards(scenario.recipient, address(rewardsToken), data);

        assertEq(rewardsToken.balanceOf(scenario.recipient), recipientBalanceBefore);
        assertEq(
            rewards.claimed(scenario.network, address(rewardsToken), scenario.claimant, scenario.leaf.rewardeeType),
            claimedBefore
        );
    }

    function test_Multicall_SuccessfullyBatchesClaimAndProtocolFeeClaim() public {
        CumulativeScenario memory scenario = _setupCumulativeScenario(address(this), 250 ether);

        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeCall(
            rewards.claimRewards,
            (
                scenario.recipient,
                address(rewardsToken),
                abi.encodePacked(
                    uint64(IRewards.RewardsType.CUMULATIVE_MERKLE),
                    abi.encode(scenario.network, scenario.root, scenario.leaf, scenario.proof)
                )
            )
        );
        calls[1] = abi.encodeCall(rewards.claimProtocolFees, (address(this), address(rewardsToken)));

        uint256 recipientBalanceBefore = rewardsToken.balanceOf(scenario.recipient);
        uint256 ownerBalanceBefore = rewardsToken.balanceOf(address(this));

        rewards.multicall(calls);

        assertEq(rewardsToken.balanceOf(scenario.recipient) - recipientBalanceBefore, scenario.distributionAmount);
        assertEq(
            rewardsToken.balanceOf(address(this)) - ownerBalanceBefore,
            scenario.totalDistributionAmount - scenario.distributionAmount
        );
    }

    function test_Multicall_RevertBubblesAndIsAtomic() public {
        address depositor = makeAddr("multicall-depositor");
        uint256 amount = 100 ether;
        rewardsToken.transfer(depositor, amount);

        vm.prank(depositor);
        rewardsToken.approve(address(rewards), amount);

        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeCall(rewards.depositCumulativeMerkleRewards, (NETWORK, address(rewardsToken), amount));
        calls[1] =
            abi.encodeCall(rewards.claimRewards, (depositor, address(rewardsToken), abi.encodePacked(uint64(99))));

        uint256 contractBalanceBefore = rewardsToken.balanceOf(address(rewards));

        vm.expectRevert(IRewards.InvalidRewardType.selector);
        vm.prank(depositor);
        rewards.multicall(calls);

        assertEq(rewards.balance(NETWORK, address(rewardsToken)), 0);
        assertEq(rewardsToken.balanceOf(address(rewards)), contractBalanceBefore);
        assertEq(rewardsToken.balanceOf(depositor), amount);
    }

    function test_Multicall_SuccessfullyBatchesDonationAndFeeClaims() public {
        uint256 donationAmount = 1000 ether;
        uint256 donationFee = 40_000;
        uint256 curatorFee = 50_000;
        address feeRecipient = makeAddr("fee-recipient");
        SimpleRegistry donationVaultFactory = new SimpleRegistry();

        CuratorRegistry localCuratorRegistry = new CuratorRegistry(address(donationVaultFactory));
        localCuratorRegistry = CuratorRegistry(
            address(
                new TransparentUpgradeableProxy(
                    address(localCuratorRegistry), address(this), abi.encodeCall(localCuratorRegistry.initialize, ())
                )
            )
        );

        FeeRegistry localFeeRegistry = new FeeRegistry(address(localCuratorRegistry));
        localFeeRegistry = FeeRegistry(
            address(
                new TransparentUpgradeableProxy(
                    address(localFeeRegistry),
                    address(this),
                    abi.encodeCall(localFeeRegistry.initialize, (address(this)))
                )
            )
        );

        MockVaultV2 vault = new MockVaultV2(address(rewardsToken), address(this));
        vm.prank(address(vault));
        donationVaultFactory.register();

        localCuratorRegistry.setCurator(address(vault), address(this));
        localFeeRegistry.setCuratorFee(address(vault), curatorFee);
        localFeeRegistry.setProtocolFee(
            keccak256(abi.encode("rewards", uint64(IRewards.RewardsType.DONATION))), true, donationFee
        );

        Rewards donationRewards = new Rewards(
            address(donationVaultFactory),
            address(0),
            address(0),
            address(localCuratorRegistry),
            address(localFeeRegistry)
        );
        donationRewards = Rewards(
            address(
                new TransparentUpgradeableProxy(
                    address(donationRewards), address(this), abi.encodeCall(donationRewards.initialize, (address(this)))
                )
            )
        );

        uint256 netAfterProtocol = donationRewards.totalToDistributionAmount(
            uint64(IRewards.RewardsType.DONATION), address(this), donationAmount
        );
        uint256 expectedCuratorFee = netAfterProtocol * curatorFee / donationRewards.MAX_FEE();
        uint256 expectedDonation = netAfterProtocol - expectedCuratorFee;
        uint256 expectedProtocolFee = donationAmount - netAfterProtocol;

        rewardsToken.approve(address(donationRewards), donationAmount);

        bytes[] memory calls = new bytes[](3);
        calls[0] = abi.encodeCall(donationRewards.distributeDonationRewards, (address(vault), donationAmount));
        calls[1] =
            abi.encodeCall(donationRewards.claimCuratorFees, (feeRecipient, address(vault), address(rewardsToken)));
        calls[2] = abi.encodeCall(donationRewards.claimProtocolFees, (feeRecipient, address(rewardsToken)));

        uint256 feeRecipientBalanceBefore = rewardsToken.balanceOf(feeRecipient);

        donationRewards.multicall(calls);

        assertEq(vault.lastCaller(), address(donationRewards));
        assertEq(vault.lastAmount(), expectedDonation);
        assertEq(
            rewardsToken.balanceOf(feeRecipient) - feeRecipientBalanceBefore, expectedCuratorFee + expectedProtocolFee
        );
        assertEq(donationRewards.curatorFees(address(vault), address(rewardsToken)), 0);
        assertEq(donationRewards.protocolFees(address(rewardsToken)), 0);
    }

    function test_DistributionAndTotalAmount_VaultSnapshot() public {
        _setProtocolFee(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), SNAPSHOT_FEE);

        uint256 distributionAmount = 1000 ether;
        uint256 expectedTotal = (distributionAmount - 1) * rewards.MAX_FEE() / (rewards.MAX_FEE() - SNAPSHOT_FEE) + 1;

        uint256 total =
            rewards.distributionToTotalAmount(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), NETWORK, distributionAmount);
        assertEq(total, expectedTotal, "vault snapshot total should include protocol fee");

        uint256 distribution =
            rewards.totalToDistributionAmount(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), NETWORK, total);
        assertEq(distribution, distributionAmount, "vault snapshot distribution should strip protocol fee");
    }

    function test_DistributionToTotalAmount_VaultSnapshot_MaxProtocolFee() public {
        _setProtocolFee(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), feeRegistry.MAX_FEE() - 1);

        uint256 total =
            rewards.distributionToTotalAmount(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), NETWORK, 100 ether);

        uint256 expectedTotal = (100 ether - 1) * rewards.MAX_FEE() / 1 + 1;
        assertEq(total, expectedTotal, "max protocol fee should nearly consume distribution");
    }

    function test_DistributionAndTotalAmount_CumulativeMerkle() public {
        _setProtocolFee(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), MERKLE_FEE);

        uint256 distributionAmount = 2500 ether;
        uint256 expectedTotal = distributionAmount * (rewards.MAX_FEE() + MERKLE_FEE) / rewards.MAX_FEE();

        uint256 total = rewards.distributionToTotalAmount(
            uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, distributionAmount
        );
        assertEq(total, expectedTotal, "cumulative merkle total should add protocol fee on top");

        uint256 distribution =
            rewards.totalToDistributionAmount(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, total);
        assertEq(distribution, distributionAmount, "cumulative merkle distribution should remove protocol fee");
    }

    function test_DistributionAndTotalAmount_Donation() public {
        uint256 donationFee = 40_000; // 4%
        _setProtocolFee(uint64(IRewards.RewardsType.DONATION), donationFee);

        uint256 distributionAmount = 800 ether;
        uint256 expectedTotal = (distributionAmount - 1) * rewards.MAX_FEE() / (rewards.MAX_FEE() - donationFee) + 1;

        uint256 total =
            rewards.distributionToTotalAmount(uint64(IRewards.RewardsType.DONATION), NETWORK, distributionAmount);
        assertEq(total, expectedTotal, "donation total should include protocol fee");

        uint256 distribution = rewards.totalToDistributionAmount(uint64(IRewards.RewardsType.DONATION), NETWORK, total);
        assertEq(distribution, distributionAmount, "donation distribution should strip protocol fee");
    }

    function test_TotalToDistributionAmount_CumulativeMerkle_RespectsBudget() public {
        uint256 nearMaxFee = feeRegistry.MAX_FEE() - 1;
        _setProtocolFee(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), nearMaxFee);

        uint256 totalDistributionAmount = 2;
        uint256 distribution = rewards.totalToDistributionAmount(
            uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, totalDistributionAmount
        );

        assertGt(distribution, 0, "distribution should remain positive");
        assertLe(
            rewards.distributionToTotalAmount(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, distribution),
            totalDistributionAmount,
            "required total must fit the provided amount"
        );
        assertGt(
            rewards.distributionToTotalAmount(
                uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, distribution + 1
            ),
            totalDistributionAmount,
            "next distribution should exceed the available total"
        );
    }

    function test_TotalToDistributionAmount_CumulativeMerkle_AllowsUnitWithTinyFee() public {
        _setProtocolFee(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), 1);

        uint256 totalDistributionAmount = 1;
        uint256 distribution = rewards.totalToDistributionAmount(
            uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, totalDistributionAmount
        );

        assertEq(distribution, 1, "tiny fee should not round net distribution down to zero");
    }

    function testFuzz_DistributionAndTotalAmount_VaultSnapshot_RoundTrip(uint256 fee, uint256 distributionAmount)
        public
    {
        fee = bound(fee, 0, feeRegistry.MAX_FEE() - 1);
        distributionAmount = bound(distributionAmount, 0, type(uint128).max);

        _setProtocolFee(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), fee);

        uint256 total =
            rewards.distributionToTotalAmount(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), NETWORK, distributionAmount);
        uint256 roundTrip =
            rewards.totalToDistributionAmount(uint64(IRewards.RewardsType.VAULT_SNAPSHOT), NETWORK, total);

        if (fee == feeRegistry.MAX_FEE()) {
            assertEq(total, type(uint256).max, "max protocol fee should force max total");
            assertEq(roundTrip, 0, "max protocol fee should leave no net distribution");
            return;
        }

        assertEq(roundTrip, distributionAmount, "vault snapshot math should round-trip");
    }

    function testFuzz_DistributionAndTotalAmount_CumulativeMerkle_RoundTrip(uint256 fee, uint256 distributionAmount)
        public
    {
        fee = bound(fee, 0, feeRegistry.MAX_FEE() - 1);
        distributionAmount = bound(distributionAmount, 0, type(uint128).max);

        _setProtocolFee(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), fee);

        uint256 total = rewards.distributionToTotalAmount(
            uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, distributionAmount
        );
        uint256 roundTrip =
            rewards.totalToDistributionAmount(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, total);

        assertEq(roundTrip, distributionAmount, "cumulative merkle math should round-trip");
    }

    function testFuzz_DistributionAndTotalAmount_Donation_RoundTrip(uint256 fee, uint256 distributionAmount) public {
        fee = bound(fee, 0, feeRegistry.MAX_FEE() - 1);
        distributionAmount = bound(distributionAmount, 0, type(uint128).max);

        _setProtocolFee(uint64(IRewards.RewardsType.DONATION), fee);

        uint256 total =
            rewards.distributionToTotalAmount(uint64(IRewards.RewardsType.DONATION), NETWORK, distributionAmount);
        uint256 roundTrip = rewards.totalToDistributionAmount(uint64(IRewards.RewardsType.DONATION), NETWORK, total);

        assertEq(roundTrip, distributionAmount, "donation math should round-trip");
    }

    function testFuzz_TotalToDistributionAmount_CumulativeMerkle_NotOverstated(
        uint256 fee,
        uint256 totalDistributionAmount
    ) public {
        fee = bound(fee, 0, feeRegistry.MAX_FEE() - 1);
        totalDistributionAmount = bound(totalDistributionAmount, 0, type(uint128).max);

        _setProtocolFee(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), fee);

        uint256 distribution = rewards.totalToDistributionAmount(
            uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, totalDistributionAmount
        );
        uint256 requiredTotal =
            rewards.distributionToTotalAmount(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, distribution);

        assertLe(requiredTotal, totalDistributionAmount, "distribution should not require more than provided total");
        if (distribution < type(uint256).max) {
            uint256 nextRequired = rewards.distributionToTotalAmount(
                uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), NETWORK, distribution + 1
            );
            assertGt(
                nextRequired, totalDistributionAmount, "distribution must already be the maximum affordable amount"
            );
        }
    }

    function test_DistributionAndTotalAmount_InvalidRewardType() public {
        vm.expectRevert(IRewards.InvalidRewardType.selector);
        rewards.distributionToTotalAmount(uint64(99), NETWORK, 1);

        vm.expectRevert(IRewards.InvalidRewardType.selector);
        rewards.totalToDistributionAmount(uint64(99), NETWORK, 1);
    }

    function _setProtocolFee(uint64 rewardsType, uint256 fee) internal {
        bytes32 feeId = keccak256(abi.encode("rewards", rewardsType));
        vm.prank(address(this));
        feeRegistry.setProtocolFee(feeId, true, fee);
    }

    function _setupSnapshotScenario(uint256 totalDistributionAmount)
        internal
        returns (SnapshotScenario memory scenario)
    {
        scenario.network = makeAddr("snapshot-network");
        scenario.staker = makeAddr("snapshot-staker");
        scenario.recipient = makeAddr("snapshot-recipient");

        vm.prank(scenario.network);
        symbioticCore.networkRegistry.registerNetwork();

        INetworkRestakeDelegator delegator;
        (scenario.vault, delegator) = _createNetworkRestakeVault(scenario.network);
        scenario.subnetwork = Subnetwork.subnetwork(scenario.network, SNAPSHOT_SUBNETWORK_ID);

        vm.prank(scenario.network);
        delegator.setMaxNetworkLimit(SNAPSHOT_SUBNETWORK_ID, SNAPSHOT_STAKE_AMOUNT);
        vm.prank(scenario.network);
        delegator.setNetworkLimit(scenario.subnetwork, SNAPSHOT_STAKE_AMOUNT);

        rewardsToken.transfer(scenario.staker, SNAPSHOT_STAKE_AMOUNT);
        vm.startPrank(scenario.staker);
        rewardsToken.approve(address(scenario.vault), SNAPSHOT_STAKE_AMOUNT);
        scenario.vault.deposit(scenario.staker, SNAPSHOT_STAKE_AMOUNT);
        vm.stopPrank();

        vm.warp(block.timestamp + 1);
        scenario.rewardTimestamp = uint48(block.timestamp);

        rewardsToken.transfer(scenario.network, totalDistributionAmount);
        vm.prank(scenario.network);
        rewardsToken.approve(address(rewards), totalDistributionAmount);

        vm.warp(block.timestamp + 1);
        vm.prank(scenario.network);
        rewards.distributeVaultSnapshotRewards(
            scenario.subnetwork,
            address(rewardsToken),
            address(scenario.vault),
            totalDistributionAmount,
            scenario.rewardTimestamp,
            abi.encode(new bytes(0), new bytes(0), new bytes(0), new bytes(0), new bytes(0))
        );

        scenario.totalDistributionAmount = totalDistributionAmount;
        scenario.expectedClaimAmount = rewards.totalToDistributionAmount(
            uint64(IRewards.RewardsType.VAULT_SNAPSHOT), scenario.network, totalDistributionAmount
        );
    }

    function _setupCumulativeScenario(address claimant, uint256 distributionAmount)
        internal
        returns (CumulativeScenario memory scenario)
    {
        scenario.network = makeAddr("cumulative-network");
        scenario.rewarder = vm.addr(CUMULATIVE_REWARDER_KEY);
        scenario.claimant = claimant;
        scenario.recipient = makeAddr("cumulative-recipient");
        scenario.distributionAmount = distributionAmount;

        rewards.setProtocol(vm.addr(CUMULATIVE_PROTOCOL_KEY));
        vm.prank(scenario.network);
        rewards.setRewarder(scenario.rewarder);

        scenario.totalDistributionAmount = rewards.distributionToTotalAmount(
            uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), scenario.network, distributionAmount
        );

        rewardsToken.approve(address(rewards), scenario.totalDistributionAmount);
        rewards.depositCumulativeMerkleRewards(
            scenario.network, address(rewardsToken), scenario.totalDistributionAmount
        );

        scenario.leaf = ICumulativeMerkleRewards.CumulativeDistributionLeaf({
            token: address(rewardsToken),
            rewardeeType: 1,
            amount: distributionAmount,
            rewardeeDataHash: keccak256("claimant-data")
        });

        (scenario.root, scenario.proof) = _createSingleLeafProof(scenario.claimant, scenario.leaf);

        ICumulativeMerkleRewards.CumulativeDistribution memory distribution =
            ICumulativeMerkleRewards.CumulativeDistribution({
                timestamp: uint48(block.timestamp), merkleRoot: scenario.root
            });

        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts = new ICumulativeMerkleRewards.TokenAmount[](1);
        totalAmounts[0] = ICumulativeMerkleRewards.TokenAmount({
            chainId: uint64(block.chainid), token: address(rewardsToken), amount: distributionAmount
        });

        bytes32 digest = _hashCumulativeDistributionPayload(scenario.network, distribution, totalAmounts);
        bytes memory protocolSignature = _signTypedData(CUMULATIVE_PROTOCOL_KEY, digest);
        bytes memory rewarderSignature = _signTypedData(CUMULATIVE_REWARDER_KEY, digest);

        rewards.distributeCumulativeMerkleRewards(
            scenario.network, distribution, totalAmounts, protocolSignature, rewarderSignature
        );
    }

    function _createSingleLeafProof(address claimant, ICumulativeMerkleRewards.CumulativeDistributionLeaf memory leaf)
        internal
        returns (bytes32 root, bytes32[] memory proof)
    {
        bytes32[] memory leafHashes = new bytes32[](1);
        leafHashes[0] = keccak256(abi.encode(claimant, block.chainid, leaf));

        bytes32[][] memory proofs;
        (root, proofs) = merkleUtils.createMerkleTree(leafHashes);
        proof = proofs[0];
    }

    function _hashCumulativeDistributionPayload(
        address network,
        ICumulativeMerkleRewards.CumulativeDistribution memory distribution,
        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts
    ) internal view returns (bytes32) {
        return _hashCumulativeDistributionPayloadFor(rewards, network, distribution, totalAmounts);
    }

    function _hashCumulativeDistributionPayloadFor(
        Rewards target,
        address network,
        ICumulativeMerkleRewards.CumulativeDistribution memory distribution,
        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts
    ) internal view returns (bytes32) {
        bytes32[] memory tokenAmountHashes = new bytes32[](totalAmounts.length);
        for (uint256 i; i < totalAmounts.length; ++i) {
            tokenAmountHashes[i] = keccak256(
                abi.encode(
                    TOKEN_AMOUNT_TYPEHASH, totalAmounts[i].chainId, totalAmounts[i].token, totalAmounts[i].amount
                )
            );
        }

        return target.hashTypedDataV4CrossChain(
            keccak256(
                abi.encode(
                    CUMULATIVE_DISTRIBUTION_PAYLOAD_TYPEHASH,
                    network,
                    distribution.timestamp,
                    distribution.merkleRoot,
                    keccak256(abi.encodePacked(tokenAmountHashes))
                )
            )
        );
    }

    function _signTypedData(uint256 privateKey, bytes32 digest) internal returns (bytes memory signature) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        signature = abi.encodePacked(r, s, v);
    }

    function _createNetworkRestakeVault(address network)
        internal
        returns (IVault vault, INetworkRestakeDelegator delegator)
    {
        (address vaultAddress, address delegatorAddress,) = symbioticCore.vaultConfigurator
            .create(
                IVaultConfigurator.InitParams({
                    version: symbioticCore.vaultFactory.lastVersion(),
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

        vault = IVault(vaultAddress);
        delegator = INetworkRestakeDelegator(delegatorAddress);
    }

    function _vaultParams() internal view returns (bytes memory) {
        IVault.InitParams memory baseParams = IVault.InitParams({
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

        return
            abi.encode(IVaultTokenized.InitParamsTokenized({baseParams: baseParams, name: "Rewards", symbol: "RWRD"}));
    }

    function _toSingletonArray(address value) internal pure returns (address[] memory array) {
        array = new address[](1);
        array[0] = value;
    }
}
