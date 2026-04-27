// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ClearUpgradeBaseScript} from "./base/ClearUpgradeBase.s.sol";
import {Logs} from "../utils/Logs.sol";

contract ClearUpgradeScript is ClearUpgradeBaseScript {
    // Configuration constants - UPDATE THESE BEFORE EXECUTING

    // Address of the Empty implementation
    address public constant REWARDS_IMPLEMENTATION = address(0);

    function run() public {
        (bytes memory data, address target) = runBase(REWARDS_IMPLEMENTATION);
        Logs.log(
            string.concat("ClearUpgrade data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target))
        );
    }
}
