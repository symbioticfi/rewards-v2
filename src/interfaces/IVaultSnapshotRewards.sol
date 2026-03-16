// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProtocolFees} from "./IProtocolFees.sol";
import {IRewardsBase} from "./IRewardsBase.sol";

/**
 * @title IVaultSnapshotRewards
 * @notice Interface for the VaultSnapshotRewards contract.
 */
interface IVaultSnapshotRewards is IRewardsBase {
    /* ENUMS */

    /**
     * @notice The types of the delegator.
     */
    enum DelegatorType {
        NETWORK_RESTAKE,
        FULL_RESTAKE,
        OPERATOR_SPECIFIC,
        OPERATOR_NETWORK_SPECIFIC,
        UNIVERSAL
    }

    /* STRUCTS */

    /**
     * @notice Snapshot of a vault reward distribution.
     * @param subnetworkId Identifier of the subnetwork the reward targets.
     * @param delegator Delegator contract responsible for distribution.
     * @param delegatorType Type identifier that classifies the delegator.
     * @param timestamp Block timestamp when the reward was recorded.
     * @param amount Reward amount allocated to stakers.
     * @param operatorsFees Portion of the reward reserved for operators.
     */
    struct RewardDistribution {
        uint96 subnetworkId;
        address delegator;
        uint64 delegatorType;
        uint48 timestamp;
        uint256 amount;
        uint256 operatorsFees;
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
     * @param curatorFees Portion of the reward allocated to the curator.
     * @param operatorsFees Portion of the reward allocated to operators.
     */
    event DistributeVaultSnapshotRewards(
        address indexed network,
        address indexed token,
        address indexed vault,
        uint96 subnetworkId,
        uint48 timestamp,
        uint256 amount,
        uint256 curatorFees,
        uint256 operatorsFees
    );

    /**
     * @notice Emitted when a staker claims vault snapshot rewards.
     * @param staker Address of the reward claimant.
     * @param network Network whose rewards were claimed.
     * @param token ERC20 token distributed to the claimant.
     * @param vault Vault that sourced the reward.
     * @param amount Amount of tokens transferred to the claimant.
     * @param firstClaimedReward First claimed reward index.
     * @param rewardsClaimed Number of rewards distributions that were claimed.
     */
    event ClaimVaultSnapshotRewards(
        address indexed staker,
        address indexed network,
        address indexed token,
        address vault,
        uint256 amount,
        uint256 firstClaimedReward,
        uint256 rewardsClaimed
    );

    /**
     * @notice Emitted when operator fees are claimed.
     * @param operator Operator claiming the fees.
     * @param network Network whose operator fees were withdrawn.
     * @param token ERC20 token transferred to the operator.
     * @param vault Vault that generated the operator fees.
     * @param amount Amount transferred to the operator.
     * @param firstClaimedReward First claimed reward index.
     * @param rewardsClaimed Number of rewards distributions that were claimed.
     */
    event ClaimOperatorFees(
        address indexed operator,
        address indexed network,
        address indexed token,
        address vault,
        uint256 amount,
        uint256 firstClaimedReward,
        uint256 rewardsClaimed
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
     * @notice Hints for distributing vault snapshot rewards.
     * @param activeSharesHint Hint for active shares lookup.
     * @param curatorFeeHint Hint for curator fee lookup.
     * @param operatorsFeeHint Hint for operators fee lookup.
     * @param totalOperatorNetworkSharesHint Hint for total operator network shares lookup.
     */
    struct DistributeVaultSnapshotRewardsHints {
        bytes activeSharesHint;
        bytes curatorFeeHint;
        bytes operatorsFeeHint;
        bytes totalOperatorNetworkSharesHint;
    }

    /**
     * @notice Distributes vault snapshot rewards (only network or middleware).
     * @param subnetwork The subnetwork identifier.
     * @param token The token address.
     * @param vault The vault address.
     * @param amount The amount to distribute.
     * @param timestamp The distribution timestamp.
     * @param hints Hints for active shares and fee lookups.
     */
    function distributeVaultSnapshotRewards(
        bytes32 subnetwork,
        address token,
        address vault,
        uint256 amount,
        uint48 timestamp,
        bytes calldata hints
    ) external;

    /**
     * @notice Claims vault snapshot rewards.
     * @param recipient The recipient address.
     * @param network The network address.
     * @param token The token address.
     * @param vault The vault address.
     * @param lastUnclaimedRewards The last unclaimed rewards index.
     * @param firstRewardToClaim The first reward index to claim (optional).
     * @param rewardsToClaim The maximum number of rewards to process.
     * @param activeSharesOfHints Hints for active shares calculation.
     * @dev firstRewardToClaim allows to skip not only empty distributions, but also the ones with rewards.
     */
    function claimVaultSnapshotRewards(
        address recipient,
        address network,
        address token,
        address vault,
        uint256 lastUnclaimedRewards,
        uint256 firstRewardToClaim,
        uint256 rewardsToClaim,
        bytes[] memory activeSharesOfHints
    ) external;

    /**
     * @notice Claims the operator fees.
     * @param recipient The recipient address.
     * @param network The network address.
     * @param token The token address.
     * @param vault The vault address.
     * @param lastUnclaimedRewards The last unclaimed rewards index.
     * @param firstRewardToClaim The first reward index to claim (optional).
     * @param rewardsToClaim The maximum number of rewards to process.
     * @param extraData Additional data for operator type-specific logic.
     * @dev firstRewardToClaim allows to skip not only empty distributions, but also the ones with rewards.
     */
    function claimOperatorFees(
        address recipient,
        address network,
        address token,
        address vault,
        uint256 lastUnclaimedRewards,
        uint256 firstRewardToClaim,
        uint256 rewardsToClaim,
        bytes calldata extraData
    ) external;
}
