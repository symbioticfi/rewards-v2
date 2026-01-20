// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultV2 {
    function collateral() external view returns (address);

    function deposit(address onBehalfOf, uint256 amount)
        external
        returns (uint256 depositedAmount, uint256 mintedShares);
}
