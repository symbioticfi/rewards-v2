// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DeployAllBaseScript} from "./base/DeployAllBase.s.sol";

contract DeployAllScript is DeployAllBaseScript {
    address public constant FEE_RECEIVER = address(0);
    address public constant PROXY_ADMIN = address(0);

    uint256 public constant CUMULATIVE_MERKLE_DEFAULT_FEE = 0.05 * 1e6;
    uint256 public constant VAULT_SNAPSHOT_DEFAULT_FEE = 0.05 * 1e6;

    function run() external {
        runBase(FEE_RECEIVER, PROXY_ADMIN, CUMULATIVE_MERKLE_DEFAULT_FEE, VAULT_SNAPSHOT_DEFAULT_FEE);
    }
}
