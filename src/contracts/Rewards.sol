// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {CumulativeMerkleRewards} from "./CumulativeMerkleRewards.sol";
import {ProtocolFees} from "./ProtocolFees.sol";
import {VaultSnapshotRewards} from "./VaultSnapshotRewards.sol";

import {IRewards} from "../interfaces/IRewards.sol";

import {MulticallUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/MulticallUpgradeable.sol";

/// @title Rewards
/// @notice Contract for orchestrating cumulative and snapshot-based reward flows.
contract Rewards is VaultSnapshotRewards, CumulativeMerkleRewards, MulticallUpgradeable, IRewards {
    /* CONSTRUCTOR */

    constructor(
        address vaultFactory,
        address networkRegistry,
        address networkMiddlewareService,
        address curatorRegistry,
        address feeRegistry
    )
        VaultSnapshotRewards(vaultFactory, networkRegistry, networkMiddlewareService, curatorRegistry)
        ProtocolFees(feeRegistry)
    {
        _disableInitializers();
    }

    /* PUBLIC FUNCTIONS */

    function initialize(address owner) public initializer {
        __ProtocolFees_init(owner);
        __CumulativeMerkleRewards_init();
    }

    /// @inheritdoc IRewards
    function claimRewards(address recipient, address token, bytes calldata data)
        public
        override(VaultSnapshotRewards, CumulativeMerkleRewards, IRewards)
    {
        // Extract reward type from first 8 bytes
        uint64 rewardsType;
        assembly ("memory-safe") {
            rewardsType := shr(192, calldataload(data.offset))
        }

        if (rewardsType == uint64(IRewards.RewardsType.VAULT_SNAPSHOT)) {
            VaultSnapshotRewards.claimRewards(recipient, token, data[8:]);
        } else if (rewardsType == uint64(IRewards.RewardsType.CUMULATIVE_MERKLE)) {
            CumulativeMerkleRewards.claimRewards(recipient, token, data[8:]);
        } else {
            revert InvalidRewardType();
        }
    }
}
