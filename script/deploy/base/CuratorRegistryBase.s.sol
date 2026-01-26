// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {CuratorRegistry} from "../../../src/contracts/CuratorRegistry.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Logs} from "../../utils/Logs.sol";
import {CreateXWrapper} from "@symbioticfi/core/script/utils/CreateXWrapper.sol";
import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";

contract CuratorRegistryBaseScript is Script, CreateXWrapper {
    function runBase(address proxyAdmin) public returns (address) {
        vm.startBroadcast();

        (,, address txOrigin) = vm.readCallers();

        address implementation = address(new CuratorRegistry(address(SymbioticCoreConstants.core().vaultFactory)));
        bytes memory proxyInitCode = abi.encodePacked(
            type(TransparentUpgradeableProxy).creationCode, abi.encode(implementation, proxyAdmin, new bytes(0))
        );
        address proxy = deployCreate3AndInitWithGuardedSalt(
            txOrigin, "CuratorReg", proxyInitCode, abi.encodeCall(CuratorRegistry.initialize, ())
        );

        vm.stopBroadcast();

        Logs.log(string.concat("Deployed CuratorRegistry implementation: ", vm.toString(implementation)));
        Logs.log(string.concat("Deployed CuratorRegistry proxy: ", vm.toString(proxy)));

        return proxy;
    }
}
