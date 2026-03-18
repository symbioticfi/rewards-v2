// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProtocolFees} from "./IProtocolFees.sol";
import {IRewardsBase} from "./IRewardsBase.sol";

/**
 * @title IDonationRewards
 * @notice Interface for donation flows that transfer vault collateral into a vault.
 */
interface IDonationRewards is IRewardsBase {
    /* EVENTS */

    /**
     * @notice Emitted when donation rewards are distributed.
     * @param adapter The caller whose fee configuration was used for the donation.
     * @param vault The vault address.
     * @param amount The net collateral amount donated into the vault after fees.
     */
    event DistributeDonationRewards(address indexed adapter, address indexed vault, uint256 amount);

    /* FUNCTIONS */

    /**
     * @notice Distributes donation rewards to a vault.
     * @param vault The vault address.
     * @param amount The amount of vault collateral transferred from the caller before fees.
     */
    function distributeDonationRewards(address vault, uint256 amount) external;
}
