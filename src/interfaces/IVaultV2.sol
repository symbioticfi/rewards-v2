// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

uint64 constant VAULT_V2_VERSION = 3;

interface IVaultV2 {
    function activeSharesAt(uint48 timestamp, bytes calldata hint) external view returns (uint256);

    function activeSharesOfAt(address account, uint48 timestamp, bytes calldata hint) external view returns (uint256);

    function activeStakeAt(uint48 timestamp, bytes calldata hint) external view returns (uint256);

    function activeWithdrawalsAt(uint48 timestamp) external view returns (uint256);

    function activeWithdrawalSharesAt(uint48 timestamp) external view returns (uint256);

    function activeWithdrawalSharesOfAt(address account, uint48 timestamp) external view returns (uint256);

    function delegator() external view returns (address);

    function collateral() external view returns (address);

    function donate(uint256 amount) external;
}
