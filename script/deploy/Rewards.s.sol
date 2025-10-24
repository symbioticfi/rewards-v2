// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {Rewards} from "../../src/contracts/Rewards.sol";
import {IRewards} from "../../src/interfaces/IRewards.sol";
import {IVaultSnapshotRewards} from "../../src/interfaces/IVaultSnapshotRewards.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract RewardsScript is Script {
    // Configuration constants - UPDATE THESE BEFORE EXECUTING

    // Address of the VaultFactory contract
    address public constant VAULT_FACTORY = address(0x1);
    // Address of the NetworkRegistry contract
    address public constant NETWORK_REGISTRY = address(0x2);
    // Address of the NetworkMiddlewareService contract
    address public constant NETWORK_MIDDLEWARE_SERVICE = address(0x3);

    function run(address feeRegistry, address curatorRegistry, address owner, address admin)
        external
        returns (address)
    {
        vm.startBroadcast();

        Rewards implementation =
            new Rewards(VAULT_FACTORY, NETWORK_REGISTRY, NETWORK_MIDDLEWARE_SERVICE, curatorRegistry, feeRegistry);
        bytes memory initData = abi.encodeWithSelector(Rewards.initialize.selector, owner);
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(address(implementation), admin, initData);

        console2.log("Rewards implementation deployed at: ", address(implementation));
        console2.log("Rewards proxy deployed at: ", address(proxy));

        vm.stopBroadcast();

        return address(proxy);
    }
}
