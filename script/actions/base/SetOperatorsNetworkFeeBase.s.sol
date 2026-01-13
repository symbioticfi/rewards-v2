// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IFeeRegistry} from "../../../src/interfaces/IFeeRegistry.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SetOperatorsNetworkFeeBaseScript is ScriptBase {
    function runBase(address feeRegistry, address vault, address network, bool enable, uint256 fee)
        public
        returns (bytes memory data, address target)
    {
        target = address(IFeeRegistry(feeRegistry));
        data = abi.encodeCall(IFeeRegistry(feeRegistry).setOperatorsNetworkFee, (vault, network, enable, fee));

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Set operators network fee",
                "\n    vault:",
                vm.toString(vault),
                "\n    network:",
                vm.toString(network),
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
