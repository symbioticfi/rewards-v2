// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ICuratorRegistry} from "../../../src/interfaces/ICuratorRegistry.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "../../utils/Logs.sol";

contract SetCuratorBaseScript is ScriptBase {
    function runBase(address curatorRegistry, address vault, address curator)
        public
        returns (bytes memory data, address target)
    {
        target = address(ICuratorRegistry(curatorRegistry));
        data = abi.encodeCall(ICuratorRegistry(curatorRegistry).setCurator, (vault, curator));

        sendTransaction(target, data);

        Logs.log(
            string.concat("Set curator", "\n    vault:", vm.toString(vault), "\n    curator:", vm.toString(curator))
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
