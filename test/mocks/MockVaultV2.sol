// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IVaultV2} from "../../src/interfaces/IVaultV2.sol";

/// @title MockVaultV2
/// @notice Minimal IVaultV2 mock for donation rewards tests.
contract MockVaultV2 is IVaultV2 {
    address public immutable override collateral;
    address public immutable vaultOwner;
    address public lastOnBehalfOf;
    address public lastCaller;
    uint256 public lastAmount;

    constructor(address collateral_, address owner_) {
        collateral = collateral_;
        vaultOwner = owner_;
    }

    function deposit(address onBehalfOf, uint256 amount)
        external
        override
        returns (uint256 depositedAmount, uint256 mintedShares)
    {
        lastCaller = msg.sender;
        lastOnBehalfOf = onBehalfOf;
        lastAmount = amount;
        return (amount, amount);
    }

    function owner() external view returns (address) {
        return vaultOwner;
    }
}
