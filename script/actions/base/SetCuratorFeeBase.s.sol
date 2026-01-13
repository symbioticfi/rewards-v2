// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IFeeRegistry} from "../../../src/interfaces/IFeeRegistry.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SetCuratorFeeBaseScript is ScriptBase {
    function runBase(address feeRegistry, address vault, uint256 fee)
        public
        returns (bytes memory data, address target)
    {
        target = address(IFeeRegistry(feeRegistry));
        data = abi.encodeCall(IFeeRegistry(feeRegistry).setCuratorFee, (vault, fee));

        sendTransaction(target, data);

        Logs.log(string.concat("Set curator fee", "\n    vault:", vm.toString(vault), "\n    fee:", vm.toString(fee)));
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
