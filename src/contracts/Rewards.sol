// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import {CumulativeMerkleRewards} from "./CumulativeMerkleRewards.sol";
import {CuratorFees} from "./CuratorFees.sol";
import {DonationRewards} from "./DonationRewards.sol";
import {ProtocolFees} from "./ProtocolFees.sol";
import {VaultSnapshotRewards} from "./VaultSnapshotRewards.sol";

import {IProtocolFees} from "../interfaces/IProtocolFees.sol";
import {IRewardsBase} from "../interfaces/IRewardsBase.sol";
import {IRewards} from "../interfaces/IRewards.sol";

/// @title Rewards
/// @notice Contract for orchestrating cumulative and snapshot-based reward flows.
contract Rewards is VaultSnapshotRewards, CumulativeMerkleRewards, DonationRewards, IRewards {
    /* MULTICALL */

    /// @inheritdoc IRewards
    function multicall(bytes[] calldata data) public {
        for (uint256 i; i < data.length; ++i) {
            (bool success, bytes memory returnData) = address(this).delegatecall(data[i]);
            if (!success) {
                assembly ("memory-safe") {
                    revert(add(32, returnData), mload(returnData))
                }
            }
        }
    }

    /* CONSTRUCTOR */

    constructor(
        address vaultFactory,
        address networkRegistry,
        address networkMiddlewareService,
        address curatorRegistry,
        address feeRegistry
    )
        VaultSnapshotRewards(vaultFactory, networkRegistry, networkMiddlewareService)
        DonationRewards(vaultFactory)
        CuratorFees(curatorRegistry)
        ProtocolFees(feeRegistry)
    {
        _disableInitializers();
    }

    /* PUBLIC FUNCTIONS */

    function initialize(address owner) public initializer {
        __ProtocolFees_init(owner);
        __CumulativeMerkleRewards_init();
    }

    /// @inheritdoc IProtocolFees
    function distributionToTotalAmount(uint64 rewardsType, address network, uint256 distributionAmount)
        public
        view
        override(VaultSnapshotRewards, CumulativeMerkleRewards, DonationRewards)
        returns (uint256)
    {
        if (rewardsType == uint64(IRewards.RewardsType.VAULT_SNAPSHOT)) {
            return VaultSnapshotRewards.distributionToTotalAmount(rewardsType, network, distributionAmount);
        } else if (rewardsType == uint64(IRewards.RewardsType.CUMULATIVE_MERKLE)) {
            return CumulativeMerkleRewards.distributionToTotalAmount(rewardsType, network, distributionAmount);
        } else if (rewardsType == uint64(IRewards.RewardsType.DONATION)) {
            return DonationRewards.distributionToTotalAmount(rewardsType, network, distributionAmount);
        } else {
            revert InvalidRewardType();
        }
    }

    /// @inheritdoc IProtocolFees
    function totalToDistributionAmount(uint64 rewardsType, address network, uint256 totalDistributionAmount)
        public
        view
        override(VaultSnapshotRewards, CumulativeMerkleRewards, DonationRewards)
        returns (uint256)
    {
        if (rewardsType == uint64(IRewards.RewardsType.VAULT_SNAPSHOT)) {
            return VaultSnapshotRewards.totalToDistributionAmount(rewardsType, network, totalDistributionAmount);
        } else if (rewardsType == uint64(IRewards.RewardsType.CUMULATIVE_MERKLE)) {
            return CumulativeMerkleRewards.totalToDistributionAmount(rewardsType, network, totalDistributionAmount);
        } else if (rewardsType == uint64(IRewards.RewardsType.DONATION)) {
            return DonationRewards.totalToDistributionAmount(rewardsType, network, totalDistributionAmount);
        } else {
            revert InvalidRewardType();
        }
    }

    /// @inheritdoc IRewardsBase
    /// @dev The function routes to the appropriate reward type based on the first 8 bytes (uint64)
    ///      of the payload that identify the rewards type. Remaining bytes are reward-specific data.
    function claimRewards(address recipient, address token, bytes calldata data)
        public
        override(VaultSnapshotRewards, CumulativeMerkleRewards, IRewardsBase)
    {
        // Extract reward type from first 8 bytes
        uint64 rewardsType;
        assembly ("memory-safe") {
            rewardsType := shr(192, calldataload(data.offset))
        }

        if (rewardsType == uint64(IRewards.RewardsType.VAULT_SNAPSHOT)) {
            VaultSnapshotRewards.claimRewards(recipient, token, data[8:]);
        } else if (rewardsType == uint64(IRewards.RewardsType.CUMULATIVE_MERKLE)) {
            CumulativeMerkleRewards.claimRewards(recipient, token, data[8:]);
        } else {
            revert InvalidRewardType();
        }
    }
}
