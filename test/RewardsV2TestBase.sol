// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

import {CuratorRegistry} from "../src/contracts/CuratorRegistry.sol";
import {FeeRegistry} from "../src/contracts/FeeRegistry.sol";

import {Token} from "@symbioticfi/core/test/mocks/Token.sol";
import {SymbioticCoreInit} from "@symbioticfi/core/test/integration/SymbioticCoreInit.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

/// @title RewardsV2TestBase
/// @notice Contract for providing shared deployment helpers for Rewards V2 tests.
abstract contract RewardsV2TestBase is SymbioticCoreInit {
    CuratorRegistry public curatorRegistry;
    FeeRegistry public feeRegistry;
    Token public rewardsToken;

    function _deployRewardsInfra(address feeOwner) internal {
        SYMBIOTIC_CORE_PROJECT_ROOT = "lib/core/";
        _initCore_SymbioticCore(false);
        curatorRegistry = new CuratorRegistry();
        curatorRegistry =
            CuratorRegistry(address(new TransparentUpgradeableProxy(address(curatorRegistry), address(this), "")));
        feeRegistry = new FeeRegistry(address(curatorRegistry));
        feeRegistry = FeeRegistry(
            address(
                new TransparentUpgradeableProxy(
                    address(feeRegistry), address(this), abi.encodeCall(feeRegistry.initialize, (feeOwner))
                )
            )
        );
        rewardsToken = new Token("RewardsToken");
    }

    function _registerNetwork(address network) internal {
        vm.prank(network);
        symbioticCore.networkRegistry.registerNetwork();
    }
}
