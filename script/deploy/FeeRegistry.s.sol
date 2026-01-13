// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {FeeRegistryBaseScript} from "./base/FeeRegistryBase.s.sol";

contract FeeRegistryScript is FeeRegistryBaseScript {
    address public constant CURATOR_REGISTRY = address(0);
    address public constant FEE_SETTER = address(0);
    address public constant PROXY_ADMIN = address(0);

    function run() external returns (address) {
        return runBase(CURATOR_REGISTRY, FEE_SETTER, PROXY_ADMIN);
    }
}
