// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProtocolFees} from "./IProtocolFees.sol";

/**
 * @title IVaultSnapshotRewards
 * @notice Interface for the VaultSnapshotRewards contract.
 */
interface IVaultSnapshotRewards {
    /* ERRORS */

    /**
     * @notice Raised when no reward tokens are received during transfer.
     */
    error InsufficientReward();

    /**
     * @notice Raised when an unsupported delegator type is encountered.
     */
    error InvalidDelegatorType();

    /**
     * @notice Raised when the supplied hints data does not match expectations.
     */
    error InvalidHintsLength();

    /**
     * @notice Raised when the provided last unclaimed reward index mismatches storage.
     */
    error InvalidLastUnclaimedReward();

    /**
     * @notice Raised when the recipient address is zero.
     */
    error InvalidRecipient();

    /**
     * @notice Raised when a reward timestamp is invalid for distribution.
     */
    error InvalidRewardTimestamp();

    /**
     * @notice Raised when the provided vault is not supported.
     */
    error InvalidVault();

    /**
     * @notice Raised when there are no rewards available to claim.
     */
    error NoRewardsToClaim();

    /**
     * @notice Raised when the caller is not the registered curator.
     */
    error NotCurator();

    /**
     * @notice Raised when the caller is neither the network nor its middleware.
     */
    error NotNetworkOrMiddleware();

    /**
     * @notice Raised when the caller is not the operator entitled to fees.
     */
    error NotOperator();

    /* STRUCTS */

    /**
     * @notice Snapshot of a vault reward distribution.
     * @param subnetworkId Identifier of the subnetwork the reward targets.
     * @param delegator Delegator contract responsible for distribution.
     * @param delegatorType Type identifier that classifies the delegator.
     * @param timestamp Block timestamp when the reward was recorded.
     * @param amount Reward amount allocated to stakers.
     * @param operatorsFee Portion of the reward reserved for operators.
     */
    struct RewardDistribution {
        uint96 subnetworkId;
        address delegator;
        uint64 delegatorType;
        uint48 timestamp;
        uint256 amount;
        uint256 operatorsFee;
    }

    /* EVENTS */

    /**
     * @notice Emitted when vault snapshot rewards are distributed.
     * @param network Network receiving the distribution.
     * @param token ERC20 token distributed to the vault.
     * @param vault Vault that recorded the distribution.
     * @param subnetworkId Identifier of the subnetwork within the network.
     * @param timestamp Timestamp associated with the distribution snapshot.
     * @param amount Net reward amount made available for stakers.
     * @param curatorFee Portion of the reward allocated to the curator.
     * @param operatorsFee Portion of the reward allocated to operators.
     */
    event DistributeVaultSnapshotRewards(
        address indexed network,
        address indexed token,
        address indexed vault,
        uint96 subnetworkId,
        uint48 timestamp,
        uint256 amount,
        uint256 curatorFee,
        uint256 operatorsFee
    );

    /**
     * @notice Emitted when a staker claims vault snapshot rewards.
     * @param staker Address of the reward claimant.
     * @param network Network whose rewards were claimed.
     * @param token ERC20 token distributed to the claimant.
     * @param vault Vault that sourced the reward.
     * @param amount Amount of tokens transferred to the claimant.
     * @param lastUnclaimedIndex Index up to which rewards were claimed.
     */
    event ClaimVaultSnapshotRewards(
        address indexed staker,
        address indexed network,
        address indexed token,
        address vault,
        uint256 amount,
        uint256 lastUnclaimedIndex
    );

    /**
     * @notice Emitted when curator fees are claimed.
     * @param vault Vault whose curator fee was withdrawn.
     * @param token ERC20 token claimed by the curator.
     * @param amount Amount transferred to the curator.
     */
    event ClaimCuratorFee(address indexed vault, address indexed token, uint256 amount);

    /**
     * @notice Emitted when operator fees are claimed.
     * @param operator Operator claiming the fees.
     * @param network Network whose operator fees were withdrawn.
     * @param token ERC20 token transferred to the operator.
     * @param vault Vault that generated the operator fees.
     * @param amount Amount transferred to the operator.
     * @param lastUnclaimedIndex Index up to which operator rewards were claimed.
     */
    event ClaimOperatorFee(
        address indexed operator,
        address indexed network,
        address indexed token,
        address vault,
        uint256 amount,
        uint256 lastUnclaimedIndex
    );

    /* FUNCTIONS */

    /**
     * @notice Returns the vault factory address.
     * @return The vault factory address.
     */
    function VAULT_FACTORY() external view returns (address);

    /**
     * @notice Returns the network registry address.
     * @return The network registry address.
     */
    function NETWORK_REGISTRY() external view returns (address);

    /**
     * @notice Returns the network middleware service address.
     * @return The network middleware service address.
     */
    function NETWORK_MIDDLEWARE_SERVICE() external view returns (address);

    /**
     * @notice Returns the curator registry address.
     * @return The curator registry address.
     */
    function CURATOR_REGISTRY() external view returns (address);

    /**
     * @notice Returns the number of reward distributions for a vault, network, and token.
     * @param vault The vault address.
     * @param network The network address.
     * @param token The token address.
     * @return The number of reward distributions.
     */
    function rewardsLength(address vault, address network, address token) external view returns (uint256);

    /**
     * @notice Returns a reward distribution by index.
     * @param vault The vault address.
     * @param network The network address.
     * @param token The token address.
     * @param index The reward index.
     * @return The reward distribution.
     */
    function rewards(address vault, address network, address token, uint256 index)
        external
        view
        returns (RewardDistribution memory);

    /**
     * @notice Returns the last unclaimed reward index for an account.
     * @param account The account address.
     * @param vault The vault address.
     * @param network The network address.
     * @param token The token address.
     * @return The last unclaimed reward index.
     */
    function lastUnclaimedReward(address account, address vault, address network, address token)
        external
        view
        returns (uint256);

    /**
     * @notice Returns the last unclaimed operator reward index for an account.
     * @param account The account address.
     * @param vault The vault address.
     * @param network The network address.
     * @param token The token address.
     * @return The last unclaimed operator reward index.
     */
    function lastUnclaimedOperatorReward(address account, address vault, address network, address token)
        external
        view
        returns (uint256);

    /**
     * @notice Returns the curator fee for a vault and token.
     * @param vault The vault address.
     * @param token The token address.
     * @return The curator fee.
     */
    function curatorFee(address vault, address token) external view returns (uint256);

    /**
     * @notice Distributes vault snapshot rewards (only network or middleware).
     * @param subnetwork The subnetwork identifier.
     * @param token The token address.
     * @param vault The vault address.
     * @param amount The amount to distribute.
     * @param timestamp The distribution timestamp.
     * @param activeSharesHint Hint for active shares calculation.
     */
    function distributeVaultSnapshotRewards(
        bytes32 subnetwork,
        address token,
        address vault,
        uint256 amount,
        uint48 timestamp,
        bytes calldata activeSharesHint
    ) external;

    /**
     * @notice Claims vault snapshot rewards.
     * @param recipient The recipient address.
     * @param network The network address.
     * @param token The token address.
     * @param vault The vault address.
     * @param lastUnclaimedRewards The last unclaimed rewards index.
     * @param firstRewardToClaim The first reward index to claim (optional).
     * @param maxRewards The maximum number of rewards to process.
     * @param activeSharesOfHints Hints for active shares calculation.
     */
    function claimVaultSnapshotRewards(
        address recipient,
        address network,
        address token,
        address vault,
        uint256 lastUnclaimedRewards,
        uint256 firstRewardToClaim,
        uint256 maxRewards,
        bytes[] memory activeSharesOfHints
    ) external;

    /**
     * @notice Claims the curator fee (only curator).
     * @param recipient The recipient address.
     * @param vault The vault address.
     * @param token The token address.
     */
    function claimCuratorFee(address recipient, address vault, address token) external;

    /**
     * @notice Claims the operator fee.
     * @param recipient The recipient address.
     * @param network The network address.
     * @param token The token address.
     * @param vault The vault address.
     * @param lastUnclaimedRewards The last unclaimed rewards index.
     * @param firstRewardToClaim The first reward index to claim (optional).
     * @param maxRewards The maximum number of rewards to process.
     * @param extraData Additional data for operator type-specific logic.
     */
    function claimOperatorFee(
        address recipient,
        address network,
        address token,
        address vault,
        uint256 lastUnclaimedRewards,
        uint256 firstRewardToClaim,
        uint256 maxRewards,
        bytes calldata extraData
    ) external;

    /**
     * @notice Claims rewards via the vault snapshot path.
     * @param recipient The recipient address.
     * @param token The token address.
     * @param data The encoded claim data.
     */
    function claimRewards(address recipient, address token, bytes calldata data) external;
}
