// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ICuratorFees} from "../../../src/interfaces/ICuratorFees.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "../../utils/Logs.sol";

contract ClaimCuratorFeesBaseScript is ScriptBase {
    function runBase(address rewards, address recipient, address vault, address token)
        public
        returns (bytes memory data, address target)
    {
        target = address(ICuratorFees(rewards));
        data = abi.encodeCall(ICuratorFees(rewards).claimCuratorFees, (recipient, vault, token));

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Claimed curator fees",
                "\n    recipient:",
                vm.toString(recipient),
                "\n    vault:",
                vm.toString(vault),
                "\n    token:",
                vm.toString(token)
            )
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
