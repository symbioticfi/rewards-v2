// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {Rewards} from "../../src/contracts/Rewards.sol";
import {IRewards} from "../../src/interfaces/IRewards.sol";
import {IVaultSnapshotRewards} from "../../src/interfaces/IVaultSnapshotRewards.sol";

import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract RewardsScript is Script {
    function run(address feeRegistry, address curatorRegistry, address owner, address admin)
        external
        returns (address)
    {
        SymbioticCoreConstants.Core memory core = SymbioticCoreConstants.core();

        vm.startBroadcast();

        Rewards implementation = new Rewards(
            address(core.vaultFactory),
            address(core.networkRegistry),
            address(core.networkMiddlewareService),
            curatorRegistry,
            feeRegistry
        );
        bytes memory initData = abi.encodeWithSelector(Rewards.initialize.selector, owner);
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(address(implementation), admin, initData);

        console2.log("Rewards implementation deployed at: ", address(implementation));
        console2.log("Rewards proxy deployed at: ", address(proxy));

        vm.stopBroadcast();

        return address(proxy);
    }
}
