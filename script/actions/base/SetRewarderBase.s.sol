// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ICumulativeMerkleRewards} from "../../../src/interfaces/ICumulativeMerkleRewards.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "../../utils/Logs.sol";

contract SetRewarderBaseScript is ScriptBase {
    function runBase(address rewards, address rewarder) public returns (bytes memory data, address target) {
        target = address(ICumulativeMerkleRewards(rewards));
        data = abi.encodeCall(ICumulativeMerkleRewards(rewards).setRewarder, (rewarder));

        sendTransaction(target, data);

        Logs.log(string.concat("Set rewarder", "\n    rewarder:", vm.toString(rewarder)));
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
