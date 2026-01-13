// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DepositCumulativeMerkleRewardsBaseScript} from "./base/DepositCumulativeMerkleRewardsBase.s.sol";

import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract DepositCumulativeMerkleRewardsScript is DepositCumulativeMerkleRewardsBaseScript {
    address public constant REWARDS = address(0);
    address public constant NETWORK = address(0);
    address public constant TOKEN = address(0);
    uint256 public constant AMOUNT = 0;

    function run() public {
        (bytes memory data, address target) = runBase(REWARDS, NETWORK, TOKEN, AMOUNT);
        Logs.log(
            string.concat(
                "DepositCumulativeMerkleRewards data:",
                "\n    data:",
                vm.toString(data),
                "\n    target:",
                vm.toString(target)
            )
        );
    }
}
