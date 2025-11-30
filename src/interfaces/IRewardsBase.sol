// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IRewardsBase
 * @notice Base interface for any Rewards contract.
 */
interface IRewardsBase {
    /* FUNCTIONS */

    /**
     * @notice Claims rewards via a unified entrypoint.
     * @param recipient The recipient address.
     * @param token The token address.
     * @param data The encoded claim data containing reward type and specific data.
     */
    function claimRewards(address recipient, address token, bytes calldata data) external;
}
