// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {RewardsBaseScript} from "./base/RewardsBase.s.sol";

contract RewardsScript is RewardsBaseScript {
    address public constant FEE_REGISTRY = address(0);
    address public constant CURATOR_REGISTRY = address(0);
    address public constant FEE_RECEIVER = address(0);
    address public constant PROXY_ADMIN = address(0);

    function run() external returns (address) {
        return runBase(FEE_REGISTRY, CURATOR_REGISTRY, FEE_RECEIVER, PROXY_ADMIN);
    }
}
