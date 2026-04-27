// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {SymbioticRewardsConstants} from "../../../test/integration/SymbioticRewardsConstants.sol";
import {Logs} from "../../utils/Logs.sol";

contract Empty {}

contract ClearDeployBaseScript is Script {
    function runBase() public returns (address rewardsImplementation) {
        if (!SymbioticRewardsConstants.rewardsSupported()) {
            revert("ClearDeployBaseScript.runBase(): rewards not supported");
        }

        vm.startBroadcast();

        rewardsImplementation = address(new Empty());

        vm.stopBroadcast();

        assert(rewardsImplementation.code.length > 0);

        Logs.log(string.concat("Deployed Empty implementation: ", vm.toString(rewardsImplementation)));

        return rewardsImplementation;
    }
}
