// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICumulativeMerkleRewards} from "./ICumulativeMerkleRewards.sol";
import {IProtocolFees} from "./IProtocolFees.sol";
import {IRewardsBase} from "./IRewardsBase.sol";
import {IVaultSnapshotRewards} from "./IVaultSnapshotRewards.sol";

/**
 * @title IRewards
 * @notice Interface for the Rewards contract.
 */
interface IRewards is IRewardsBase {
    /* ERRORS */

    /**
     * @notice Raised when the supplied reward type identifier is not supported.
     */
    error InvalidRewardType();

    /* STRUCTS */

    /**
     * @notice Enumerates supported reward mechanisms.
     * @dev Used to route unified reward claims.
     */
    enum RewardsType {
        VAULT_SNAPSHOT,
        CUMULATIVE_MERKLE
    }
}
