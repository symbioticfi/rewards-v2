// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ClaimCumulativeMerkleRewardsBaseScript} from "./base/ClaimCumulativeMerkleRewardsBase.s.sol";
import {ICumulativeMerkleRewards} from "../../src/interfaces/ICumulativeMerkleRewards.sol";

import {Logs} from "../utils/Logs.sol";

contract ClaimCumulativeMerkleRewardsScript is ClaimCumulativeMerkleRewardsBaseScript {
    address public constant REWARDS = address(0);
    address public constant RECIPIENT = address(0);
    address public constant NETWORK = address(0);
    ICumulativeMerkleRewards.CumulativeDistributionLeaf public LEAF = ICumulativeMerkleRewards.CumulativeDistributionLeaf({
        token: address(0), rewardeeType: 0, amount: 0, rewardeeDataHash: bytes32(0)
    });
    bytes32 public constant MERKLE_ROOT = bytes32(0);

    function run() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = bytes32(0);

        (bytes memory data, address target) = runBase(REWARDS, RECIPIENT, NETWORK, LEAF, proof, MERKLE_ROOT);
        Logs.log(
            string.concat(
                "ClaimCumulativeMerkleRewards data:",
                "\n    data:",
                vm.toString(data),
                "\n    target:",
                vm.toString(target)
            )
        );
    }
}
