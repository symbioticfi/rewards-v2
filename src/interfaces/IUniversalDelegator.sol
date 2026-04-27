// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUniversalDelegator {
    function oldDelegator() external view returns (address);

    function migrateTimestamp() external view returns (uint48);

    function getSlotOfNetworkAt(bytes32 subnetwork, uint48 timestamp) external view returns (uint96);

    function getFilledAt(uint96 index, uint48 duration, uint48 timestamp) external view returns (uint256);

    function getAllocatedAt(bytes32 subnetwork, address operator, uint48 duration, uint48 timestamp)
        external
        view
        returns (uint256);
}
