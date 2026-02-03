// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

import {CuratorRegistry} from "../src/contracts/CuratorRegistry.sol";
import {FeeRegistry} from "../src/contracts/FeeRegistry.sol";
import {IRewards} from "../src/interfaces/IRewards.sol";

import {Token} from "@symbioticfi/core/test/mocks/Token.sol";
import {SymbioticCoreInit} from "@symbioticfi/core/test/integration/SymbioticCoreInit.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

/// @title RewardsV2TestBase
/// @notice Contract for providing shared deployment helpers for Rewards V2 tests.
abstract contract RewardsV2TestBase is SymbioticCoreInit {
    CuratorRegistry public curatorRegistry;
    FeeRegistry public feeRegistry;
    Token public rewardsToken;

    string internal constant REWARDS_PROTOCOL_FEE_ID = "rewards";
    uint256 internal constant DEFAULT_CUMULATIVE_MERKLE_FEE = 50_000;
    uint256 internal constant DEFAULT_VAULT_SNAPSHOT_FEE = 50_000;

    function _deployRewardsInfra(address feeOwner) internal {
        _initCore_SymbioticCore(false);
        curatorRegistry = new CuratorRegistry(address(symbioticCore.vaultFactory));
        curatorRegistry = CuratorRegistry(
            address(
                new TransparentUpgradeableProxy(
                    address(curatorRegistry), address(this), abi.encodeCall(curatorRegistry.initialize, ())
                )
            )
        );
        feeRegistry = new FeeRegistry(address(curatorRegistry));
        feeRegistry = FeeRegistry(
            address(
                new TransparentUpgradeableProxy(
                    address(feeRegistry), address(this), abi.encodeCall(feeRegistry.initialize, (feeOwner))
                )
            )
        );
        _setDefaultProtocolFees(feeOwner);
        rewardsToken = new Token("RewardsToken");
    }

    function _registerNetwork(address network) internal {
        vm.prank(network);
        symbioticCore.networkRegistry.registerNetwork();
    }

    function _setDefaultProtocolFees(address feeOwner) internal {
        bytes32 cumulativeMerkleId =
            keccak256(abi.encode(REWARDS_PROTOCOL_FEE_ID, IRewards.RewardsType.CUMULATIVE_MERKLE));
        bytes32 vaultSnapshotId = keccak256(abi.encode(REWARDS_PROTOCOL_FEE_ID, IRewards.RewardsType.VAULT_SNAPSHOT));

        vm.startPrank(feeOwner);
        feeRegistry.setProtocolFee(cumulativeMerkleId, true, DEFAULT_CUMULATIVE_MERKLE_FEE);
        feeRegistry.setProtocolFee(vaultSnapshotId, true, DEFAULT_VAULT_SNAPSHOT_FEE);
        vm.stopPrank();
    }
}
