// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

import {AddDonationDeployScript} from "../../../script/upgrade/AddDonationDeploy.s.sol";
import {FeeRegistry} from "../../../src/contracts/FeeRegistry.sol";
import {Rewards} from "../../../src/contracts/Rewards.sol";
import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";
import {SymbioticRewardsConstants} from "../../integration/SymbioticRewardsConstants.sol";

contract AddDonationDeployScriptTest is Test {
    uint256 internal constant HOODI_CHAIN_ID = 560_048;

    AddDonationDeployScript internal script;

    function setUp() public {
        script = new AddDonationDeployScript();
    }

    function test_Run_DeploysImplementationsWithExpectedImmutableArgs() public {
        vm.chainId(HOODI_CHAIN_ID);

        SymbioticRewardsConstants.Rewards memory currentRewards = SymbioticRewardsConstants.rewards();
        SymbioticCoreConstants.Core memory core = SymbioticCoreConstants.core();

        (address feeRegistryImplementation, address rewardsImplementation) = script.run();

        assertTrue(feeRegistryImplementation.code.length > 0);
        assertTrue(rewardsImplementation.code.length > 0);
        assertEq(FeeRegistry(feeRegistryImplementation).CURATOR_REGISTRY(), address(currentRewards.curatorRegistry));
        assertEq(Rewards(rewardsImplementation).CURATOR_REGISTRY(), address(currentRewards.curatorRegistry));
        assertEq(Rewards(rewardsImplementation).FEE_REGISTRY(), address(currentRewards.feeRegistry));
        assertEq(Rewards(rewardsImplementation).VAULT_FACTORY(), address(core.vaultFactory));
        assertEq(Rewards(rewardsImplementation).NETWORK_REGISTRY(), address(core.networkRegistry));
        assertEq(Rewards(rewardsImplementation).NETWORK_MIDDLEWARE_SERVICE(), address(core.networkMiddlewareService));
    }

    function test_Run_RevertWhen_RewardsUnsupported() public {
        vm.chainId(31_337);

        vm.expectRevert("AddDonationDeployBaseScript.runBase(): rewards not supported");
        script.run();
    }
}
