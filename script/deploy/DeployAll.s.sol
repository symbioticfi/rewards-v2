// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DeployAllBaseScript} from "./base/DeployAllBase.s.sol";

contract DeployAllScript is DeployAllBaseScript {
    // Configuration constants - UPDATE THESE BEFORE EXECUTING

    // Address of the protocol fees setter
    address public constant FEE_SETTER = address(0);
    // Address of the protocol fees receiver
    address public constant FEE_RECEIVER = address(0);
    // Address of the proxy admin
    address public constant PROXY_ADMIN = address(0);

    // Default fee for Cumulative Merkle rewards
    uint256 public constant CUMULATIVE_MERKLE_DEFAULT_FEE = 0.1 * 1e6;
    // Default fee for Vault Snapshot rewards
    uint256 public constant VAULT_SNAPSHOT_DEFAULT_FEE = 0.1 * 1e6;

    function run() external {
        runBase(FEE_SETTER, FEE_RECEIVER, PROXY_ADMIN, CUMULATIVE_MERKLE_DEFAULT_FEE, VAULT_SNAPSHOT_DEFAULT_FEE);
    }
}
