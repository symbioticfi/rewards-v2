// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {FeeRegistry as SymbioticFeeRegistry} from "../../../src/contracts/FeeRegistry.sol";
import {Rewards as SymbioticRewards} from "../../../src/contracts/Rewards.sol";

import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";
import {SymbioticRewardsConstants} from "../../../test/integration/SymbioticRewardsConstants.sol";
import {Logs} from "../../utils/Logs.sol";

contract AddDonationDeployBaseScript is Script {
    function runBase() public returns (address feeRegistryImplementation, address rewardsImplementation) {
        if (!SymbioticRewardsConstants.rewardsSupported()) {
            revert("AddDonationDeployBaseScript.runBase(): rewards not supported");
        }
        if (!SymbioticCoreConstants.coreSupported()) {
            revert("AddDonationDeployBaseScript.runBase(): core not supported");
        }

        SymbioticRewardsConstants.Rewards memory currentRewards = SymbioticRewardsConstants.rewards();
        SymbioticCoreConstants.Core memory core = SymbioticCoreConstants.core();

        vm.startBroadcast();

        feeRegistryImplementation = address(new SymbioticFeeRegistry(address(currentRewards.curatorRegistry)));
        rewardsImplementation = address(
            new SymbioticRewards(
                address(core.vaultFactory),
                address(core.networkRegistry),
                address(core.networkMiddlewareService),
                address(currentRewards.curatorRegistry),
                address(currentRewards.feeRegistry)
            )
        );

        vm.stopBroadcast();

        assert(feeRegistryImplementation.code.length > 0);
        assert(rewardsImplementation.code.length > 0);

        Logs.log(string.concat("Deployed FeeRegistry implementation: ", vm.toString(feeRegistryImplementation)));
        Logs.log(string.concat("Deployed Rewards implementation: ", vm.toString(rewardsImplementation)));

        return (feeRegistryImplementation, rewardsImplementation);
    }
}
