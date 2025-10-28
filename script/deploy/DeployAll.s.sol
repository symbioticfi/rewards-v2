// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console2, Script} from "forge-std/Script.sol";

import {CuratorRegistryScript} from "./CuratorRegistry.s.sol";
import {RewardsScript} from "./Rewards.s.sol";
import {FeeRegistryScript} from "./FeeRegistry.s.sol";

contract DeployAllScript is Script {
    function run(address feeReceiver, address proxyAdmin) external {
        CuratorRegistryScript curatorRegistryScript = new CuratorRegistryScript();
        address curatorRegistry = curatorRegistryScript.run(proxyAdmin);

        FeeRegistryScript feeRegistryScript = new FeeRegistryScript();
        address feeRegistry = feeRegistryScript.run(curatorRegistry, feeReceiver, proxyAdmin);

        RewardsScript rewardsScript = new RewardsScript();
        rewardsScript.run(feeRegistry, curatorRegistry, feeReceiver, proxyAdmin);
    }
}
