// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DeployAllBaseScript} from "./base/DeployAllBase.s.sol";

contract DeployAllScript is DeployAllBaseScript {
    address public constant FEE_RECEIVER = address(0);
    address public constant PROXY_ADMIN = address(0);

    function run() external {
        runBase(FEE_RECEIVER, PROXY_ADMIN);
    }
}
