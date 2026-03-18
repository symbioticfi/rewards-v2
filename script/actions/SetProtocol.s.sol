// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SetProtocolBaseScript} from "./base/SetProtocolBase.s.sol";

import {Logs} from "../utils/Logs.sol";

contract SetProtocolScript is SetProtocolBaseScript {
    address public constant REWARDS = address(0);
    address public constant PROTOCOL = address(0);

    function run() public {
        (bytes memory data, address target) = runBase(REWARDS, PROTOCOL);
        Logs.log(
            string.concat("SetProtocol data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target))
        );
    }
}
