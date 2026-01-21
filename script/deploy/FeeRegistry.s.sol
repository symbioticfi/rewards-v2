// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {FeeRegistryBaseScript} from "./base/FeeRegistryBase.s.sol";

import {IFeeRegistry} from "../../src/interfaces/IFeeRegistry.sol";
import {IRewards} from "../../src/interfaces/IRewards.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract FeeRegistryScript is FeeRegistryBaseScript {
    address public constant CURATOR_REGISTRY = address(0);
    address public constant FEE_SETTER = address(0);
    address public constant PROXY_ADMIN = address(0);
    uint256 public constant CUMULATIVE_MERKLE_DEFAULT_FEE = 0.05 * 1e6;
    uint256 public constant VAULT_SNAPSHOT_DEFAULT_FEE = 0.05 * 1e6;

    function run() external returns (address) {
        return
            runBase(
                CURATOR_REGISTRY, FEE_SETTER, PROXY_ADMIN, CUMULATIVE_MERKLE_DEFAULT_FEE, VAULT_SNAPSHOT_DEFAULT_FEE
            );
    }
}
