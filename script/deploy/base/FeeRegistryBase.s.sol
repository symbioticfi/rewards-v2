// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {FeeRegistry} from "../../../src/contracts/FeeRegistry.sol";
import {IFeeRegistry} from "../../../src/interfaces/IFeeRegistry.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract FeeRegistryBaseScript is Script {
    function runBase(address curatorRegistry, address feeSetter, address proxyAdmin) public returns (address) {
        vm.startBroadcast();

        address implementation = address(new FeeRegistry(curatorRegistry));
        address proxy = address(
            new TransparentUpgradeableProxy(
                implementation, proxyAdmin, abi.encodeWithSelector(FeeRegistry.initialize.selector, feeSetter)
            )
        );

        vm.stopBroadcast();

        Logs.log(string.concat("Deployed FeeRegistry implementation: ", vm.toString(implementation)));
        Logs.log(string.concat("Deployed FeeRegistry proxy: ", vm.toString(proxy)));

        return proxy;
    }
}
