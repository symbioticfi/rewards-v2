// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SetRewarderBaseScript} from "./base/SetRewarderBase.s.sol";

import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SetRewarderScript is SetRewarderBaseScript {
    address public constant REWARDS = address(0);
    address public constant REWARDER = address(0);

    function run() public {
        (bytes memory data, address target) = runBase(REWARDS, REWARDER);
        Logs.log(
            string.concat("SetRewarder data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target))
        );
    }
}
