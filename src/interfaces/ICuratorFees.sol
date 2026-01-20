// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IRewardsErrors} from "./IRewardsErrors.sol";

/**
 * @title ICuratorFees
 * @notice Interface for the CuratorFees contract.
 */
interface ICuratorFees is IRewardsErrors {
    /* EVENTS */
    /**
     * @notice Emitted when curator fees are claimed.
     * @param vault Vault whose curator fees were withdrawn.
     * @param token ERC20 token claimed by the curator.
     * @param amount Amount transferred to the curator.
     */
    event ClaimCuratorFees(address indexed vault, address indexed token, uint256 amount);

    /**
     * @notice Emitted when curator fees are accounted for a distribution.
     * @param rewardsType Type identifier for the rewards flow.
     * @param vault The vault address.
     * @param network The network address.
     * @param token ERC20 token the fee was accounted at.
     * @param fees Amount of tokens reserved as curator fees.
     */
    event AccountCuratorFees(
        uint64 indexed rewardsType, address indexed vault, address network, address indexed token, uint256 fees
    );

    /* FUNCTIONS */

    /**
     * @notice Returns the curator registry address.
     * @return The curator registry address.
     */
    function CURATOR_REGISTRY() external view returns (address);

    /**
     * @notice Returns the curator fees for a vault and token.
     * @param vault The vault address.
     * @param token The token address.
     * @return The curator fees.
     */
    function curatorFees(address vault, address token) external view returns (uint256);

    /**
     * @notice Claims the curator fees (only curator).
     * @param recipient The recipient address.
     * @param vault The vault address.
     * @param token The token address.
     * @dev If the vault's curator is changed, the past fees go to the new curator.
     */
    function claimCuratorFees(address recipient, address vault, address token) external;
}
