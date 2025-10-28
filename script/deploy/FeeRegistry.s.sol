// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {FeeRegistry} from "../../src/contracts/FeeRegistry.sol";
import {IFeeRegistry} from "../../src/interfaces/IFeeRegistry.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract FeeRegistryScript is Script {
    function run(address curatorRegistry, address feeSetter, address proxyAdmin) external returns (address) {
        vm.startBroadcast();

        address implementation = address(new FeeRegistry(curatorRegistry));
        address proxy = address(
            new TransparentUpgradeableProxy(
                implementation, proxyAdmin, abi.encodeWithSelector(FeeRegistry.initialize.selector, feeSetter)
            )
        );

        console2.log("FeeRegistry implementation deployed at: ", implementation);
        console2.log("FeeRegistry proxy deployed at: ", proxy);

        vm.stopBroadcast();

        return proxy;
    }
}
