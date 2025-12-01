// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IProtocolFees
 * @notice Interface for the ProtocolFees contract.
 */
interface IProtocolFees {
    /* ERRORS */

    /**
     * @notice Raised when no fees are available to claim for a token.
     */
    error InsufficientClaimableFees();

    /* EVENTS */

    /**
     * @notice Emitted when protocol fees are accounted for a distribution.
     * @param rewardsType Type identifier for the rewards flow.
     * @param network The network whose rewards incurred the fee.
     * @param token ERC20 token the fee was accounted at.
     * @param fees Amount of tokens reserved as protocol fees.
     */
    event AccountProtocolFees(uint64 indexed rewardsType, address indexed network, address indexed token, uint256 fees);

    /**
     * @notice Emitted when protocol fees are claimed.
     * @param token ERC20 token that was transferred to the claimant.
     * @param fees Amount of protocol fees disbursed.
     */
    event ClaimProtocolFees(address indexed token, uint256 fees);

    /* FUNCTIONS */

    /**
     * @notice Returns the maximum fee value.
     * @return The maximum fee value.
     */
    function MAX_FEE() external view returns (uint256);

    /**
     * @notice Returns the FeeRegistry contract address.
     * @return The FeeRegistry address.
     */
    function FEE_REGISTRY() external view returns (address);

    /**
     * @notice Returns the claimable protocol fees for a token.
     * @param token The token address.
     * @return The claimable fee amount.
     */
    function protocolFees(address token) external view returns (uint256);

    /**
     * @notice Returns the protocol fee for a reward type and network.
     * @param rewardsType The reward type identifier.
     * @param network The network address.
     * @return The protocol fee amount.
     */
    function protocolFee(uint64 rewardsType, address network) external view returns (uint256);

    /**
     * @notice Returns a total amount that must be provided (including protocol fees) from the net distribution amount.
     * @param rewardsType Identifier of the rewards flow.
     * @param network The network for which the protocol fee will be applied.
     * @param distributionAmount Amount intended to reach recipients, excluding protocol fees.
     * @return Gross amount required to cover the distribution plus protocol fees.
     */
    function distributionToTotalAmount(uint64 rewardsType, address network, uint256 distributionAmount)
        external
        view
        returns (uint256);

    /**
     * @notice Returns a net distribution amount from the total provided amount (inclusive of protocol fees).
     * @param rewardsType Identifier of the rewards flow.
     * @param network The network for which the protocol fee will be applied.
     * @param totalDistributionAmount Gross amount supplied for the distribution, including protocol fees.
     * @return Net amount available for recipients after protocol fees are removed.
     */
    function totalToDistributionAmount(uint64 rewardsType, address network, uint256 totalDistributionAmount)
        external
        view
        returns (uint256);

    /**
     * @notice Claims protocol fees for a token (only owner).
     * @param recipient The recipient address.
     * @param token The token address.
     * @return fees The amount of fees claimed.
     */
    function claimProtocolFees(address recipient, address token) external returns (uint256 fees);
}
