// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {CuratorRegistry} from "../../../src/contracts/CuratorRegistry.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";
import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";

contract CuratorRegistryBaseScript is Script {
    function runBase(address proxyAdmin) public returns (address) {
        vm.startBroadcast();

        address implementation = address(new CuratorRegistry(address(SymbioticCoreConstants.core().vaultFactory)));
        address proxy = address(
            new TransparentUpgradeableProxy(implementation, proxyAdmin, abi.encodeCall(CuratorRegistry.initialize, ()))
        );

        vm.stopBroadcast();

        Logs.log(string.concat("Deployed CuratorRegistry implementation: ", vm.toString(implementation)));
        Logs.log(string.concat("Deployed CuratorRegistry proxy: ", vm.toString(proxy)));

        return proxy;
    }
}
