// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IVaultV2, VAULT_V2_VERSION} from "../../src/interfaces/IVaultV2.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @title MockVaultV2
/// @notice Minimal IVaultV2 mock for donation rewards tests.
contract MockVaultV2 is IVaultV2 {
    using SafeERC20 for IERC20;

    address public immutable override collateral;
    address public immutable vaultOwner;
    address public lastOnBehalfOf;
    address public lastCaller;
    uint256 public lastAmount;

    constructor(address collateral_, address owner_) {
        collateral = collateral_;
        vaultOwner = owner_;
    }

    function donate(uint256 amount) external override {
        IERC20(collateral).safeTransferFrom(msg.sender, address(this), amount);
        lastCaller = msg.sender;
        lastOnBehalfOf = address(0);
        lastAmount = amount;
    }

    function owner() external view returns (address) {
        return vaultOwner;
    }

    function version() external view returns (uint64) {
        return VAULT_V2_VERSION;
    }
}
