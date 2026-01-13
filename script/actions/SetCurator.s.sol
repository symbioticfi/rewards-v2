// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SetCuratorBaseScript} from "./base/SetCuratorBase.s.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SetCuratorScript is SetCuratorBaseScript {
    address public constant CURATOR_REGISTRY = address(0);
    address public constant VAULT = address(0);
    address public constant CURATOR = address(0);

    function run() public {
        (bytes memory data, address target) = runBase(CURATOR_REGISTRY, VAULT, CURATOR);
        Logs.log(
            string.concat("SetCurator data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target))
        );
    }
}
