// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import {CuratorFees} from "./CuratorFees.sol";

import {IDonationRewards} from "../interfaces/IDonationRewards.sol";
import {IProtocolFees} from "../interfaces/IProtocolFees.sol";
import {IRewards} from "../interfaces/IRewards.sol";
import {IVaultV2, VAULT_V2_VERSION} from "../interfaces/IVaultV2.sol";

import {IMigratableEntity} from "@symbioticfi/core/src/interfaces/common/IMigratableEntity.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IRegistry} from "@symbioticfi/core/src/interfaces/common/IRegistry.sol";

/// @title DonationRewards
/// @notice Contract for managing direct donations of a vault's collateral into the vault itself.
/// @dev The protocol fee is deducted from the distribution amount.
abstract contract DonationRewards is CuratorFees, IDonationRewards {
    using SafeERC20 for IERC20;
    using Math for uint256;

    /* IMMUTABLES */

    address private immutable VAULT_FACTORY;

    /* CONSTRUCTOR */

    constructor(address vaultFactory) {
        VAULT_FACTORY = vaultFactory;
    }

    /* PUBLIC FUNCTIONS */

    /// @inheritdoc IProtocolFees
    function distributionToTotalAmount(
        uint64,
        /*rewardsType*/
        address adapter,
        uint256 distributionAmount
    )
        public
        view
        virtual
        override
        returns (uint256)
    {
        return distributionAmount > 0
            ? (distributionAmount - 1)
                .mulDiv(MAX_FEE, MAX_FEE - protocolFee(uint64(IRewards.RewardsType.DONATION), adapter)) + 1
            : 0;
    }

    /// @inheritdoc IProtocolFees
    function totalToDistributionAmount(
        uint64,
        /*rewardsType*/
        address adapter,
        uint256 totalDistributionAmount
    )
        public
        view
        virtual
        override
        returns (uint256)
    {
        return totalDistributionAmount
            - totalDistributionAmount.mulDiv(protocolFee(uint64(IRewards.RewardsType.DONATION), adapter), MAX_FEE);
    }

    /// @inheritdoc IDonationRewards
    function distributeDonationRewards(address vault, uint256 amount) public nonReentrant {
        if (!IRegistry(VAULT_FACTORY).isEntity(vault)) {
            revert NotVault();
        }
        if (IMigratableEntity(vault).version() < VAULT_V2_VERSION) {
            revert NoDonationSupport();
        }

        address token = IVaultV2(vault).collateral();

        uint256 balanceBefore = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        amount = IERC20(token).balanceOf(address(this)) - balanceBefore;

        if (amount == 0) {
            revert InsufficientReward();
        }

        uint256 distributionAmount =
            _subProtocolFeesFromTotal(uint64(IRewards.RewardsType.DONATION), msg.sender, token, amount);
        distributionAmount = _subCuratorFeesFromDistribution(
            uint64(IRewards.RewardsType.DONATION), vault, msg.sender, token, distributionAmount
        );

        IERC20(token).forceApprove(vault, distributionAmount);
        IVaultV2(vault).donate(distributionAmount);

        emit DistributeDonationRewards(msg.sender, vault, distributionAmount);
    }
}
