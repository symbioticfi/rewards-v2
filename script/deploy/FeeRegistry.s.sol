// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {FeeRegistry} from "../../src/contracts/FeeRegistry.sol";
import {IFeeRegistry} from "../../src/interfaces/IFeeRegistry.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract FeeRegistryScript is Script {
    function run(address curatorRegistry, address owner, address admin) external returns (address) {
        vm.startBroadcast();

        FeeRegistry implementation = new FeeRegistry(curatorRegistry);
        bytes memory initData = abi.encodeWithSelector(FeeRegistry.initialize.selector, owner);
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(address(implementation), admin, initData);

        console2.log("FeeRegistry implementation deployed at: ", address(implementation));
        console2.log("FeeRegistry proxy deployed at: ", address(proxy));

        vm.stopBroadcast();

        return address(proxy);
    }
}
