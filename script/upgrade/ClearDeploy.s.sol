// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ClearDeployBaseScript} from "./base/ClearDeployBase.s.sol";

contract ClearDeployScript is ClearDeployBaseScript {
    function run() external returns (address rewardsImplementation) {
        return runBase();
    }
}
