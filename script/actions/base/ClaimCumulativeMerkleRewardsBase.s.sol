// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ICumulativeMerkleRewards} from "../../../src/interfaces/ICumulativeMerkleRewards.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "../../utils/Logs.sol";

contract ClaimCumulativeMerkleRewardsBaseScript is ScriptBase {
    function runBase(
        address rewards,
        address recipient,
        address network,
        ICumulativeMerkleRewards.CumulativeDistributionLeaf memory leaf,
        bytes32[] memory proof,
        bytes32 merkleRoot
    ) public returns (bytes memory data, address target) {
        target = address(ICumulativeMerkleRewards(rewards));
        data = abi.encodeCall(
            ICumulativeMerkleRewards(rewards).claimCumulativeMerkleRewards,
            (recipient, network, leaf, proof, merkleRoot)
        );

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Claimed cumulative merkle rewards",
                "\n    recipient:",
                vm.toString(recipient),
                "\n    network:",
                vm.toString(network)
            )
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
