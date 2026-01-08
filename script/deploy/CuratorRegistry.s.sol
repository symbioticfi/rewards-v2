// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {CuratorRegistry} from "../../src/contracts/CuratorRegistry.sol";

import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract CuratorRegistryScript is Script {
    function run(address proxyAdmin) external returns (address) {
        SymbioticCoreConstants.Core memory core = SymbioticCoreConstants.core();

        vm.startBroadcast();

        address implementation = address(new CuratorRegistry(address(core.vaultFactory)));
        address proxy = address(
            new TransparentUpgradeableProxy(implementation, proxyAdmin, abi.encodeCall(CuratorRegistry.initialize, ()))
        );

        console2.log("CuratorRegistry implementation deployed at: ", implementation);
        console2.log("CuratorRegistry proxy deployed at: ", proxy);

        vm.stopBroadcast();

        return proxy;
    }
}
