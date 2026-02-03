// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ICumulativeMerkleRewards} from "../../../src/interfaces/ICumulativeMerkleRewards.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "../../utils/Logs.sol";

contract DistributeCumulativeMerkleRewardsBaseScript is ScriptBase {
    function runBase(
        address rewards,
        address network,
        ICumulativeMerkleRewards.CumulativeDistribution memory cumulativeDistribution,
        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts,
        bytes memory protocolSignature,
        bytes memory rewarderSignature
    ) public returns (bytes memory data, address target) {
        target = address(ICumulativeMerkleRewards(rewards));
        data = abi.encodeCall(
            ICumulativeMerkleRewards(rewards).distributeCumulativeMerkleRewards,
            (network, cumulativeDistribution, totalAmounts, protocolSignature, rewarderSignature)
        );

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Distributed cumulative merkle rewards",
                "\n    network:",
                vm.toString(network),
                "\n    merkleRoot:",
                vm.toString(cumulativeDistribution.merkleRoot)
            )
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
