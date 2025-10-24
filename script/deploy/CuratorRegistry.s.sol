// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {CuratorRegistry} from "../../src/contracts/CuratorRegistry.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract CuratorRegistryScript is Script {
    function run(address admin) external returns (address) {
        vm.startBroadcast();

        CuratorRegistry implementation = new CuratorRegistry();
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(address(implementation), admin, "");

        console2.log("CuratorRegistry implementation deployed at: ", address(implementation));
        console2.log("CuratorRegistry proxy deployed at: ", address(proxy));

        vm.stopBroadcast();

        return address(proxy);
    }
}
