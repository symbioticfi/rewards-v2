// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProtocolFees} from "./IProtocolFees.sol";
import {IRewardsBase} from "./IRewardsBase.sol";

/**
 * @title IDonationRewards
 * @notice Interface for the DonationRewards contract.
 */
interface IDonationRewards is IRewardsBase {
    /* EVENTS */

    /**
     * @notice Emitted when donation rewards are distributed.
     * @param vault The vault address.
     * @param token The token address.
     * @param amount The amount of tokens distributed.
     */
    event DistributeDonationRewards(address indexed vault, address indexed token, uint256 amount);

    /* FUNCTIONS */

    /**
     * @notice Distributes donation rewards to a vault.
     * @param vault The vault address.
     * @param amount The amount of tokens to distribute.
     */
    function distributeDonationRewards(address vault, uint256 amount) external;
}
