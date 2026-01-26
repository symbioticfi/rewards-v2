// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {CuratorRegistryBaseScript} from "./CuratorRegistryBase.s.sol";
import {FeeRegistryBaseScript} from "./FeeRegistryBase.s.sol";
import {RewardsBaseScript} from "./RewardsBase.s.sol";

contract DeployAllBaseScript is Script {
    function runBase(
        address feeSetter,
        address feeReceiver,
        address proxyAdmin,
        uint256 cumulativeMerkleDefaultFee,
        uint256 vaultSnapshotDefaultFee
    ) public {
        CuratorRegistryBaseScript curatorRegistryScript = new CuratorRegistryBaseScript();
        address curatorRegistry = curatorRegistryScript.runBase(proxyAdmin);

        FeeRegistryBaseScript feeRegistryScript = new FeeRegistryBaseScript();
        address feeRegistry = feeRegistryScript.runBase(
            curatorRegistry, feeSetter, proxyAdmin, cumulativeMerkleDefaultFee, vaultSnapshotDefaultFee
        );

        RewardsBaseScript rewardsScript = new RewardsBaseScript();
        rewardsScript.runBase(feeRegistry, curatorRegistry, feeReceiver, proxyAdmin);
    }
}
