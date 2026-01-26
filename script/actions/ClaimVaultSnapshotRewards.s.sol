// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ClaimVaultSnapshotRewardsBaseScript} from "./base/ClaimVaultSnapshotRewardsBase.s.sol";

import {Logs} from "../utils/Logs.sol";

contract ClaimVaultSnapshotRewardsScript is ClaimVaultSnapshotRewardsBaseScript {
    address public constant REWARDS = address(0);
    address public constant RECIPIENT = address(0);
    address public constant NETWORK = address(0);
    address public constant TOKEN = address(0);
    address public constant VAULT = address(0);
    uint256 public constant LAST_UNCLAIMED_REWARDS = 0;
    uint256 public constant FIRST_REWARD_TO_CLAIM = 0;
    uint256 public constant REWARDS_TO_CLAIM = 1;

    function run() public {
        bytes[] memory activeSharesHints = new bytes[](0);

        (bytes memory data, address target) = runBase(
            REWARDS,
            RECIPIENT,
            NETWORK,
            TOKEN,
            VAULT,
            LAST_UNCLAIMED_REWARDS,
            FIRST_REWARD_TO_CLAIM,
            REWARDS_TO_CLAIM,
            activeSharesHints
        );
        Logs.log(
            string.concat(
                "ClaimVaultSnapshotRewards data:",
                "\n    data:",
                vm.toString(data),
                "\n    target:",
                vm.toString(target)
            )
        );
    }
}
