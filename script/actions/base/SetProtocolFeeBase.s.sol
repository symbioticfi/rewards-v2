// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IFeeRegistry} from "../../../src/interfaces/IFeeRegistry.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SetProtocolFeeBaseScript is ScriptBase {
    function runBase(address feeRegistry, bytes32 id, bool enable, uint256 fee)
        public
        returns (bytes memory data, address target)
    {
        target = address(IFeeRegistry(feeRegistry));
        data = abi.encodeCall(IFeeRegistry(feeRegistry).setProtocolFee, (id, enable, fee));

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Set protocol fee",
                "\n    id:",
                vm.toString(id),
                "\n    enable:",
                vm.toString(enable),
                "\n    fee:",
                vm.toString(fee)
            )
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
