// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

uint96 constant VAULT_V2_VERSION = 3;

interface IVaultV2 {
    function collateral() external view returns (address);

    function donate(uint256 amount) external;
}
