// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {RewardsBaseScript} from "./base/RewardsBase.s.sol";

contract RewardsScript is RewardsBaseScript {
    // Configuration constants - UPDATE THESE BEFORE EXECUTING

    // Address of the fee registry
    // TODO: Replace with constant
    address public constant FEE_REGISTRY = address(0);
    // Address of the curator registry
    // TODO: Replace with constant
    address public constant CURATOR_REGISTRY = address(0);
    // Address of the protocol fees receiver
    address public constant FEE_RECEIVER = address(0);
    // Address of the proxy admin
    address public constant PROXY_ADMIN = address(0);

    function run() external returns (address) {
        return runBase(FEE_REGISTRY, CURATOR_REGISTRY, FEE_RECEIVER, PROXY_ADMIN);
    }
}
