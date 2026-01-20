// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import {ProtocolFees} from "./ProtocolFees.sol";

import {IFeeRegistry} from "../interfaces/IFeeRegistry.sol";
import {ICuratorFees} from "../interfaces/ICuratorFees.sol";
import {ICuratorRegistry} from "../interfaces/ICuratorRegistry.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuardTransient} from "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

/// @title CuratorFees
/// @notice Contract for processing protocol fees.
abstract contract CuratorFees is ProtocolFees, ReentrancyGuardTransient, ICuratorFees {
    using SafeERC20 for IERC20;
    using Math for uint256;

    /* IMMUTABLES */

    /// @inheritdoc ICuratorFees
    address public immutable CURATOR_REGISTRY;

    /* STORAGE */

    /// @custom:storage-location erc7201:symbiotic.rewards.CuratorFees
    struct CuratorFeesStorage {
        mapping(address vault => mapping(address token => uint256 fee)) _curatorFees;
    }

    // (keccak256(abi.encode(uint256(keccak256("symbiotic.rewards.VaultSnapshotRewards")) - 1)) & ~bytes32(uint256(0xff))) + 4
    bytes32 private constant CURATOR_FEES_STORAGE_POSITION =
        0xea7ec811d4da20f680ecf87dbad2b956cc74e833cd99b5f63865df6b3d6b6804;

    function _curatorFeesStorage() private pure returns (CuratorFeesStorage storage $) {
        assembly {
            $.slot := CURATOR_FEES_STORAGE_POSITION
        }
    }

    /* CONSTRUCTOR */

    constructor(address curatorRegistry) {
        CURATOR_REGISTRY = curatorRegistry;
    }

    /* PUBLIC FUNCTIONS */

    /// @inheritdoc ICuratorFees
    function curatorFees(address vault, address token) public view returns (uint256) {
        return _curatorFeesStorage()._curatorFees[vault][token];
    }

    /// @inheritdoc ICuratorFees
    function claimCuratorFees(address recipient, address vault, address token) public nonReentrant {
        if (recipient == address(0)) {
            revert InvalidRecipient();
        }

        if (ICuratorRegistry(CURATOR_REGISTRY).getCurator(vault) != msg.sender) {
            revert NotCurator();
        }

        uint256 claimableFee = curatorFees(vault, token);
        if (claimableFee == 0) {
            revert NoRewardsToClaim();
        }

        _curatorFeesStorage()._curatorFees[vault][token] = 0;
        IERC20(token).safeTransfer(recipient, claimableFee);

        emit ClaimCuratorFees(vault, token, claimableFee);
    }

    /* INTERNAL FUNCTIONS */

    /// @dev Subtracts curator fees from distribution amount at a specific timestamp.
    function _subCuratorFeesAtFromDistribution(
        uint64 rewardsType,
        address vault,
        address network,
        address token,
        uint256 distributionAmount,
        uint48 timestamp,
        bytes memory hints
    ) internal returns (uint256) {
        return distributionAmount
            - _accountCuratorFees(
            rewardsType,
            vault,
            network,
            token,
            distributionAmount,
            IFeeRegistry(FEE_REGISTRY).getCuratorFeeAt(vault, network, timestamp, hints)
        );
    }

    /// @dev Subtracts curator fees from distribution amount.
    function _subCuratorFeesFromDistribution(
        uint64 rewardsType,
        address vault,
        address network,
        address token,
        uint256 distributionAmount
    ) internal returns (uint256) {
        return distributionAmount
            - _accountCuratorFees(
            rewardsType,
            vault,
            network,
            token,
            distributionAmount,
            IFeeRegistry(FEE_REGISTRY).getCuratorFee(vault, network)
        );
    }

    /// @dev Account curator fees.
    function _accountCuratorFees(
        uint64 rewardsType,
        address vault,
        address network,
        address token,
        uint256 distributionAmount,
        uint256 curatorFee
    ) internal returns (uint256 curatorFees) {
        curatorFees = distributionAmount.mulDiv(curatorFee, MAX_FEE);
        _curatorFeesStorage()._curatorFees[vault][token] += curatorFees;
        emit AccountCuratorFees(rewardsType, vault, network, token, curatorFees);
    }
}
