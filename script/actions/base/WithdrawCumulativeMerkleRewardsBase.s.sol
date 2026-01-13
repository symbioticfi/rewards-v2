// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ICumulativeMerkleRewards} from "../../../src/interfaces/ICumulativeMerkleRewards.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract WithdrawCumulativeMerkleRewardsBaseScript is ScriptBase {
    function runBase(address rewards, address recipient, address network, address token, uint256 amount)
        public
        returns (bytes memory data, address target)
    {
        target = address(ICumulativeMerkleRewards(rewards));
        data = abi.encodeCall(
            ICumulativeMerkleRewards(rewards).withdrawCumulativeMerkleRewards, (recipient, network, token, amount)
        );

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Withdrew cumulative merkle rewards",
                "\n    recipient:",
                vm.toString(recipient),
                "\n    network:",
                vm.toString(network),
                "\n    token:",
                vm.toString(token),
                "\n    amount:",
                vm.toString(amount)
            )
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
