// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {CuratorRegistryScript} from "./CuratorRegistry.s.sol";
import {RewardsScript} from "./Rewards.s.sol";
import {FeeRegistryScript} from "./FeeRegistry.s.sol";

contract RewardsV2Script is Script {
    function run(address owner, address admin) external {
        CuratorRegistryScript curatorRegistryScript = new CuratorRegistryScript();
        address curatorRegistry = curatorRegistryScript.run(admin);

        FeeRegistryScript feeRegistryScript = new FeeRegistryScript();
        address feeRegistry = feeRegistryScript.run(curatorRegistry, owner, admin);

        RewardsScript rewardsScript = new RewardsScript();
        rewardsScript.run(feeRegistry, curatorRegistry, owner, admin);
    }
}
