// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IRewardsErrors
 * @notice Interface for all rewards errors.
 */
interface IRewardsErrors {
    /* ERRORS */

    /**
     * @notice Raised when the address is not a vault.
     */
    error NotVault();

    /**
     * @notice Raised when there are no rewards available to claim.
     */
    error NoRewardsToClaim();

    /**
     * @notice Raised when no reward tokens are received during transfer.
     */
    error InsufficientReward();

    /**
     * @notice Raised when an unsupported delegator type is encountered.
     */
    error InvalidDelegatorType();

    /**
     * @notice Raised when the provided last unclaimed reward index mismatches storage.
     */
    error InvalidLastUnclaimedReward();

    /**
     * @notice Raised when a reward timestamp is invalid for distribution.
     */
    error InvalidRewardTimestamp();

    /**
     * @notice Raised when the caller is neither the network nor its middleware.
     */
    error NotNetworkOrMiddleware();

    /**
     * @notice Raised when the caller is not the operator entitled to fees.
     */
    error NotOperator();

    /**
     * @notice Raised when no fees are available to claim for a token.
     */
    error InsufficientClaimableFees();

    /**
     * @notice Raised when the recipient address is zero.
     */
    error InvalidRecipient();

    /**
     * @notice Raised when the caller is not the registered curator.
     */
    error NotCurator();

    /**
     * @notice Raised when trying to deposit zero tokens.
     */
    error InsufficientDeposit();

    /**
     * @notice Raised when a supplied merkle proof is invalid.
     */
    error InvalidMerkleProof();

    /**
     * @notice Raised when a supplied merkle root is not recognized.
     */
    error InvalidMerkleRoot();

    /**
     * @notice Raised when a signature validation fails.
     */
    error InvalidSignature();

    /**
     * @notice Raised when a distribution timestamp is not strictly increasing.
     */
    error InvalidTimestamp();

    /**
     * @notice Raised when a provided token address does not match expectations.
     */
    error InvalidToken();

    /**
     * @notice Raised when a claimant has no rewards to withdraw.
     */
    error NoCumulativeRewardsToClaim();

    /**
     * @notice Raised when the caller is not authorized as the rewarder for a network.
     */
    error NotRewarder();

    /**
     * @notice Raised when attempting to register a merkle root that has already been stored.
     */
    error RootAlreadySet();
}
