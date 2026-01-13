// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {Rewards} from "../../../src/contracts/Rewards.sol";
import {IRewards} from "../../../src/interfaces/IRewards.sol";
import {IVaultSnapshotRewards} from "../../../src/interfaces/IVaultSnapshotRewards.sol";

import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract RewardsBaseScript is Script {
    function runBase(address feeRegistry, address curatorRegistry, address feeReceiver, address proxyAdmin)
        public
        returns (address)
    {
        SymbioticCoreConstants.Core memory core = SymbioticCoreConstants.core();

        vm.startBroadcast();

        address implementation = address(
            new Rewards(
                address(core.vaultFactory),
                address(core.networkRegistry),
                address(core.networkMiddlewareService),
                curatorRegistry,
                feeRegistry
            )
        );
        address proxy = address(
            new TransparentUpgradeableProxy(
                implementation, proxyAdmin, abi.encodeWithSelector(Rewards.initialize.selector, feeReceiver)
            )
        );

        vm.stopBroadcast();

        Logs.log(string.concat("Deployed Rewards implementation: ", vm.toString(implementation)));
        Logs.log(string.concat("Deployed Rewards proxy: ", vm.toString(proxy)));

        return proxy;
    }
}
