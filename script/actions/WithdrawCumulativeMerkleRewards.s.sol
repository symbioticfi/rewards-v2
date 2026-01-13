// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {WithdrawCumulativeMerkleRewardsBaseScript} from "./base/WithdrawCumulativeMerkleRewardsBase.s.sol";

import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract WithdrawCumulativeMerkleRewardsScript is WithdrawCumulativeMerkleRewardsBaseScript {
    address public constant REWARDS = address(0);
    address public constant RECIPIENT = address(0);
    address public constant NETWORK = address(0);
    address public constant TOKEN = address(0);
    uint256 public constant AMOUNT = 0;

    function run() public {
        (bytes memory data, address target) = runBase(REWARDS, RECIPIENT, NETWORK, TOKEN, AMOUNT);
        Logs.log(
            string.concat(
                "WithdrawCumulativeMerkleRewards data:",
                "\n    data:",
                vm.toString(data),
                "\n    target:",
                vm.toString(target)
            )
        );
    }
}
