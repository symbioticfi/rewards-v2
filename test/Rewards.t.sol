// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Vm} from "forge-std/Vm.sol";

import {Rewards} from "../src/contracts/Rewards.sol";
import {IRewards} from "../src/interfaces/IRewards.sol";
import {IVaultSnapshotRewards} from "../src/interfaces/IVaultSnapshotRewards.sol";
import {ICumulativeMerkleRewards} from "../src/interfaces/ICumulativeMerkleRewards.sol";

import {RewardsV2TestBase} from "./RewardsV2TestBase.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract RewardsTest is RewardsV2TestBase {
    Rewards rewards;

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
        vm.expectRevert(IVaultSnapshotRewards.InvalidLastUnclaimedReward.selector); // This will revert due to missing setup, but shows routing works
        rewards.claimRewards(address(this), address(rewardsToken), data);
    }

    function test_ClaimRewards_CumulativeMerkle() public {
        ICumulativeMerkleRewards.CumulativeDistributionLeaf memory leaf;
        bytes32[] memory proof = new bytes32[](1);
        bytes memory cumulativeDistributionData = abi.encode(address(1), keccak256("root"), leaf, proof);

        // Encode reward type + data
        bytes memory data = abi.encodePacked(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), cumulativeDistributionData);

        // We only test that the function routes correctly
        vm.expectRevert(ICumulativeMerkleRewards.InvalidToken.selector); // This will revert due to missing setup, but shows routing works
        rewards.claimRewards(address(this), address(rewardsToken), data);
    }

    function test_ClaimRewards_InvalidRewardType() public {
        // Create data with an unsupported reward type (e.g., 2)
        bytes memory invalidData = abi.encodePacked(uint64(2), "some data");

        // Expect the function to revert with InvalidRewardType error
        vm.expectRevert(IRewards.InvalidRewardType.selector);
        rewards.claimRewards(address(this), address(rewardsToken), invalidData);
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
}
