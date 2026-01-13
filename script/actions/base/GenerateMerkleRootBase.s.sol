// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {MerkleTreeUtils} from "../../../test/utils/MerkleTreeUtils.sol";
import {ICumulativeMerkleRewards} from "../../../src/interfaces/ICumulativeMerkleRewards.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract GenerateMerkleRootBaseScript is ScriptBase {
    function runBase(ICumulativeMerkleRewards.CumulativeDistributionLeaf[] memory leaves, address[] memory rewardees)
        internal
        returns (bytes32 root, bytes32[][] memory proofs)
    {
        MerkleTreeUtils merkleUtils = new MerkleTreeUtils();
        bytes32[] memory leafHashes = new bytes32[](leaves.length);

        for (uint256 i; i < leaves.length; ++i) {
            leafHashes[i] = keccak256(abi.encode(rewardees[i], block.chainid, leaves[i]));
        }

        (root, proofs) = merkleUtils.createMerkleTree(leafHashes);

        Logs.log(string.concat("Merkle Root:", "\n    root:", vm.toString(root)));
        for (uint256 i; i < proofs.length; ++i) {
            Logs.log(string.concat("Merkle Proof:", "\n    index:", vm.toString(i)));
            for (uint256 j; j < proofs[i].length; ++j) {
                Logs.log(string.concat("    ", vm.toString(j), ": ", vm.toString(proofs[i][j])));
            }
        }
    }
}
