// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {Rewards} from "../../../src/contracts/Rewards.sol";

import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";
import {CreateXWrapper} from "@symbioticfi/core/script/utils/CreateXWrapper.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract RewardsBaseScript is Script, CreateXWrapper {
    function runBase(address feeRegistry, address curatorRegistry, address feeReceiver, address proxyAdmin)
        public
        returns (address)
    {
        SymbioticCoreConstants.Core memory core = SymbioticCoreConstants.core();

        vm.startBroadcast();

        (,, address txOrigin) = vm.readCallers();

        address implementation = address(
            new Rewards(
                address(core.vaultFactory),
                address(core.networkRegistry),
                address(core.networkMiddlewareService),
                curatorRegistry,
                feeRegistry
            )
        );
        bytes memory proxyInitCode = abi.encodePacked(
            type(TransparentUpgradeableProxy).creationCode, abi.encode(implementation, proxyAdmin, new bytes(0))
        );
        address proxy = deployCreate3AndInitWithGuardedSalt(
            txOrigin, "Rewards", proxyInitCode, abi.encodeCall(Rewards.initialize, (feeReceiver))
        );

        vm.stopBroadcast();

        Logs.log(string.concat("Deployed Rewards implementation: ", vm.toString(implementation)));
        Logs.log(string.concat("Deployed Rewards proxy: ", vm.toString(proxy)));

        return proxy;
    }
}
