// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {Rewards} from "../../src/contracts/Rewards.sol";
import {IRewards} from "../../src/interfaces/IRewards.sol";
import {IVaultSnapshotRewards} from "../../src/interfaces/IVaultSnapshotRewards.sol";

import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract RewardsScript is Script {
    function run(address feeRegistry, address curatorRegistry, address feeReceiver, address proxyAdmin)
        external
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

        console2.log("Rewards implementation deployed at: ", implementation);
        console2.log("Rewards proxy deployed at: ", proxy);

        vm.stopBroadcast();

        return proxy;
    }
}
