// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {CuratorRegistryBaseScript} from "./base/CuratorRegistryBase.s.sol";

contract CuratorRegistryScript is CuratorRegistryBaseScript {
    address public constant PROXY_ADMIN = address(0);

    function run() external returns (address) {
        return runBase(PROXY_ADMIN);
    }
}
