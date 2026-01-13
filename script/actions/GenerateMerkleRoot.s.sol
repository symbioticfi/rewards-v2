// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {GenerateMerkleRootBaseScript} from "./base/GenerateMerkleRootBase.s.sol";
import {ICumulativeMerkleRewards} from "../../src/interfaces/ICumulativeMerkleRewards.sol";

import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract GenerateMerkleRootScript is GenerateMerkleRootBaseScript {
    ICumulativeMerkleRewards.CumulativeDistributionLeaf public leaf1 =
        ICumulativeMerkleRewards.CumulativeDistributionLeaf({
            token: address(0), amount: 0, rewardeeType: 1, rewardeeDataHash: keccak256("leaf1-data")
        });
    ICumulativeMerkleRewards.CumulativeDistributionLeaf public leaf2 =
        ICumulativeMerkleRewards.CumulativeDistributionLeaf({
            token: address(0), amount: 0, rewardeeType: 1, rewardeeDataHash: keccak256("leaf2-data")
        });
    address[] public rewardees =
        [address(0), address(0)];

    function run() public {
        ICumulativeMerkleRewards.CumulativeDistributionLeaf[] memory leaves =
            new ICumulativeMerkleRewards.CumulativeDistributionLeaf[](2);

        leaves[0] = leaf1;
        leaves[1] = leaf2;
        (bytes32 root,) = runBase(leaves, rewardees);
        Logs.log(string.concat("GenerateMerkleRoot root:", "\n    root:", vm.toString(root)));
    }
}
