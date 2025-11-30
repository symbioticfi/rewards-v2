// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProtocolFees} from "./IProtocolFees.sol";
import {IRewardsBase} from "./IRewardsBase.sol";

/**
 * @title ICumulativeMerkleRewards
 * @notice Interface for the CumulativeMerkleRewards contract.
 */
interface ICumulativeMerkleRewards is IRewardsBase {
    /* ERRORS */

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

    /* STRUCTS */

    /**
     * @notice Distribution checkpoint recorded for a network.
     * @param timestamp Timestamp of the cumulative distribution.
     * @param merkleRoot Merkle root that defines the distribution state.
     */
    struct CumulativeDistribution {
        uint48 timestamp;
        bytes32 merkleRoot;
    }

    /**
     * @notice Token amount snapshot that is used in reward distribution.
     * @param chainId Chain identifier where the amount applies.
     * @param token ERC20 token address tied to the amount.
     * @param amount Total amount accumulated for the token.
     */
    struct TokenAmount {
        uint64 chainId;
        address token;
        uint256 amount;
    }

    /**
     * @notice Leaf payload used to verify an individual cumulative reward claim.
     * @param chainId Chain identifier where the reward should be claimed.
     * @param token ERC20 token address being claimed.
     * @param rewardeeType Encoded rewardee type for downstream accounting.
     * @param amount Total cumulative amount allocated to the rewardee.
     * @param rewardeeDataHash Hash of rewardee-specific data that parametrizes the claim.
     */
    struct CumulativeDistributionLeaf {
        uint64 chainId;
        address token;
        uint256 rewardeeType;
        uint256 amount;
        bytes32 rewardeeDataHash;
    }

    /* EVENTS */

    /**
     * @notice Emitted when cumulative merkle rewards are distributed for a network.
     * @param network The network whose distribution is updated.
     * @param cumulativeDistribution Distribution metadata that was published.
     */
    event DistributeCumulativeMerkleRewards(address indexed network, CumulativeDistribution cumulativeDistribution);
    /**
     * @notice Emitted when tokens are deposited for a network's balance.
     * @param network The network receiving the deposited tokens.
     * @param token ERC20 token deposited into the rewards pool.
     * @param amount Net token amount received.
     */
    event DepositCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount);
    /**
     * @notice Emitted when tokens are withdrawn from a network's balance.
     * @param network The network whose balance decreased.
     * @param token ERC20 token withdrawn from the rewards pool.
     * @param amount Token amount transferred out.
     */
    event WithdrawCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount);
    /**
     * @notice Emitted when a rewardee claims rewards.
     * @param rewardee Address of the account that initiated the claim.
     * @param network The network under which the claim was made.
     * @param leaf Leaf data that defines the claimed allocation.
     */
    event ClaimCumulativeMerkleRewards(
        address indexed rewardee, address indexed network, CumulativeDistributionLeaf leaf
    );
    /**
     * @notice Emitted when a rewarder is set for a network.
     * @param network The network whose rewarder changed.
     * @param rewarder The address now authorized to manage rewards.
     */
    event SetRewarder(address indexed network, address rewarder);
    /**
     * @notice Emitted when the protocol address is updated.
     * @param protocol The new protocol address.
     */
    event SetProtocol(address indexed protocol);

    /* FUNCTIONS */

    /**
     * @notice Returns the last cumulative distribution for a network.
     * @param network The network address.
     * @return The last cumulative distribution.
     */
    function lastCumulativeDistribution(address network) external view returns (CumulativeDistribution memory);

    /**
     * @notice Returns the last total amount for a network and token.
     * @param network The network address.
     * @param token The token address.
     * @return The last total amount.
     */
    function lastTotalAmount(address network, address token) external view returns (uint256);

    /**
     * @notice Returns whether a cumulative distribution root exists for a network.
     * @param network The network address.
     * @param root The merkle root to check.
     * @return True if the root exists.
     */
    function isCumulativeDistributionRoot(address network, bytes32 root) external view returns (bool);

    /**
     * @notice Returns the balance for a network and token.
     * @param network The network address.
     * @param token The token address.
     * @return amount The balance amount.
     */
    function balance(address network, address token) external view returns (uint256 amount);

    /**
     * @notice Returns the claimed amount for a rewardee.
     * @param network The network address.
     * @param token The token address.
     * @param rewardee The rewardee address.
     * @param rewardeeType The rewardee type.
     * @return amount The claimed amount.
     */
    function claimed(address network, address token, address rewardee, uint256 rewardeeType)
        external
        view
        returns (uint256 amount);

    /**
     * @notice Returns the rewarder for a network.
     * @param network The network address.
     * @return The rewarder address.
     */
    function rewarder(address network) external view returns (address);

    /**
     * @notice Returns the protocol address.
     * @return The protocol address.
     */
    function protocol() external view returns (address);

    /**
     * @notice Distributes cumulative merkle rewards for a network.
     * @param network The network address.
     * @param cumulativeDistribution The cumulative distribution data.
     * @param totalAmounts Array of total amounts per token and chainId.
     * @param ownerSignature Signature by the contract owner over the payload.
     * @param rewarderSignature Signature by the network rewarder over the payload.
     */
    function distributeCumulativeMerkleRewards(
        address network,
        CumulativeDistribution calldata cumulativeDistribution,
        TokenAmount[] calldata totalAmounts,
        bytes calldata ownerSignature,
        bytes calldata rewarderSignature
    ) external;

    /**
     * @notice Deposits tokens to fund cumulative merkle rewards.
     * @param network The network address.
     * @param token The token address.
     * @param amount The amount to deposit.
     */
    function depositCumulativeMerkleRewards(address network, address token, uint256 amount) external;

    /**
     * @notice Withdraws cumulative merkle rewards for a network (only rewarder).
     * @param recipient The recipient address.
     * @param network The network address.
     * @param token The token address.
     * @param amount The amount to withdraw.
     */
    function withdrawCumulativeMerkleRewards(address recipient, address network, address token, uint256 amount) external;

    /**
     * @notice Claims cumulative merkle rewards for a recipient.
     * @param recipient The recipient address.
     * @param network The network address.
     * @param leaf The distribution leaf data.
     * @param proof The merkle proof.
     * @param merkleRoot The merkle root.
     */
    function claimCumulativeMerkleRewards(
        address recipient,
        address network,
        CumulativeDistributionLeaf calldata leaf,
        bytes32[] calldata proof,
        bytes32 merkleRoot
    ) external;

    /**
     * @notice Sets the rewarder for a network.
     * @param rewarder The rewarder address.
     */
    function setRewarder(address rewarder) external;

    /**
     * @notice Sets the protocol address.
     * @param protocol The protocol address.
     */
    function setProtocol(address protocol) external;
}
