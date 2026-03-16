// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import {CuratorFees} from "./CuratorFees.sol";

import {IDonationRewards} from "../interfaces/IDonationRewards.sol";
import {IProtocolFees} from "../interfaces/IProtocolFees.sol";
import {IRewards} from "../interfaces/IRewards.sol";
import {IVaultV2} from "../interfaces/IVaultV2.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IRegistry} from "@symbioticfi/core/src/interfaces/common/IRegistry.sol";

/// @title DonationRewards
/// @notice Contract for managing vault snapshot-based rewards distributions.
/// @dev The protocol fee is deducted from the distribution amount.
abstract contract DonationRewards is CuratorFees, IDonationRewards {
    using SafeERC20 for IERC20;
    using Math for uint256;

    /* IMMUTABLES */

    address private immutable VAULT_FACTORY;

    /* STORAGE */

    /// @custom:storage-location erc7201:symbiotic.rewards.DonationRewards
    struct DonationRewardsStorage {
        mapping(address vault => mapping(address token => uint256 fee)) _curatorFees;
    }

    // keccak256(abi.encode(uint256(keccak256("symbiotic.rewards.DonationRewards")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant DONATION_REWARDS_STORAGE_POSITION =
        0x0e712c73f1ff87f3577bf7ef9813692a19fb3fb1a6ec4d36252fd835a2755800;

    function _donationRewardsStorage() internal pure returns (DonationRewardsStorage storage $) {
        assembly {
            $.slot := DONATION_REWARDS_STORAGE_POSITION
        }
    }

    /* CONSTRUCTOR */

    constructor(address vaultFactory) {
        VAULT_FACTORY = vaultFactory;
    }

    /* PUBLIC FUNCTIONS */

    /// @inheritdoc IProtocolFees
    function distributionToTotalAmount(
        uint64,
        /*rewardsType*/
        address vault,
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
                .mulDiv(MAX_FEE, MAX_FEE - protocolFee(uint64(IRewards.RewardsType.DONATION), vault)) + 1
            : 0;
    }

    /// @inheritdoc IProtocolFees
    function totalToDistributionAmount(
        uint64,
        /*rewardsType*/
        address vault,
        uint256 totalDistributionAmount
    )
        public
        view
        virtual
        override
        returns (uint256)
    {
        return totalDistributionAmount
            - totalDistributionAmount.mulDiv(protocolFee(uint64(IRewards.RewardsType.DONATION), vault), MAX_FEE);
    }

    /// @inheritdoc IDonationRewards
    function distributeDonationRewards(address vault, uint256 amount) public nonReentrant {
        if (!IRegistry(VAULT_FACTORY).isEntity(vault)) {
            revert NotVault();
        }

        address token = IVaultV2(vault).collateral();

        uint256 balanceBefore = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        amount = IERC20(token).balanceOf(address(this)) - balanceBefore;

        if (amount == 0) {
            revert InsufficientReward();
        }

        uint256 distributionAmount =
            _subProtocolFeesFromTotal(uint64(IRewards.RewardsType.DONATION), vault, token, amount);
        distributionAmount = _subCuratorFeesFromDistribution(
            uint64(IRewards.RewardsType.DONATION), vault, address(0), token, distributionAmount
        );

        IERC20(token).forceApprove(vault, distributionAmount);
        IVaultV2(vault).donate(distributionAmount);

        emit DistributeDonationRewards(vault, token, distributionAmount);
    }
}
