// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICumulativeMerkleRewards} from "./ICumulativeMerkleRewards.sol";
import {IProtocolFees} from "./IProtocolFees.sol";
import {IVaultSnapshotRewards} from "./IVaultSnapshotRewards.sol";

/**
 * @title IRewards
 * @notice Interface for the Rewards contract.
 */
interface IRewards {
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

    /* FUNCTIONS */

    /**
     * @notice Claims rewards via a unified entrypoint.
     * @param recipient The recipient address.
     * @param token The token address.
     * @param data The encoded claim data containing reward type and specific data.
     * @dev The function routes to the appropriate reward type based on the first 8 bytes (uint64).
     * of the payload that identify the rewards type. Remaining bytes are reward-specific data.
     */
    function claimRewards(address recipient, address token, bytes calldata data) external;
}
