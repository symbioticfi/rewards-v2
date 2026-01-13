// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IProtocolFees} from "../../../src/interfaces/IProtocolFees.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract ClaimProtocolFeesBaseScript is ScriptBase {
    function runBase(address protocolFees, address recipient, address token)
        public
        returns (bytes memory data, address target)
    {
        target = address(IProtocolFees(protocolFees));
        data = abi.encodeCall(IProtocolFees(protocolFees).claimProtocolFees, (recipient, token));

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Claimed protocol fees", "\n    recipient:", vm.toString(recipient), "\n    token:", vm.toString(token)
            )
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
