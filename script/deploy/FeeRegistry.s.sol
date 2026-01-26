// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {FeeRegistryBaseScript} from "./base/FeeRegistryBase.s.sol";

contract FeeRegistryScript is FeeRegistryBaseScript {
    address public constant CURATOR_REGISTRY = address(0);
    address public constant FEE_SETTER = address(0);
    address public constant PROXY_ADMIN = address(0);

    uint256 public constant CUMULATIVE_MERKLE_DEFAULT_FEE = 0.10 * 1e6;
    uint256 public constant VAULT_SNAPSHOT_DEFAULT_FEE = 0.10 * 1e6;

    function run() external returns (address) {
        return
            runBase(
                CURATOR_REGISTRY, FEE_SETTER, PROXY_ADMIN, CUMULATIVE_MERKLE_DEFAULT_FEE, VAULT_SNAPSHOT_DEFAULT_FEE
            );
    }
}
