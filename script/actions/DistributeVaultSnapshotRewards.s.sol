// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DistributeVaultSnapshotRewardsBaseScript} from "./base/DistributeVaultSnapshotRewardsBase.s.sol";
import {IVaultSnapshotRewards} from "../../src/interfaces/IVaultSnapshotRewards.sol";

import {Logs} from "../utils/Logs.sol";

contract DistributeVaultSnapshotRewardsScript is DistributeVaultSnapshotRewardsBaseScript {
    address public constant REWARDS = address(0);
    bytes32 public constant SUBNETWORK = bytes32(0);
    address public constant TOKEN = address(0);
    address public constant VAULT = address(0);
    uint256 public constant AMOUNT = 0;
    uint48 public constant TIMESTAMP = 0;

    function run() public {
        bytes memory hints;

        (bytes memory data, address target) = runBase(REWARDS, SUBNETWORK, TOKEN, VAULT, AMOUNT, TIMESTAMP, hints);
        Logs.log(
            string.concat(
                "DistributeVaultSnapshotRewards data:",
                "\n    data:",
                vm.toString(data),
                "\n    target:",
                vm.toString(target)
            )
        );
    }
}
