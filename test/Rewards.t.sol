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
}
