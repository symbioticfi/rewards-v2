// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ClaimCuratorFeesBaseScript} from "./base/ClaimCuratorFeesBase.s.sol";

import {Logs} from "../utils/Logs.sol";

contract ClaimCuratorFeesScript is ClaimCuratorFeesBaseScript {
    address public constant REWARDS = address(0);
    address public constant RECIPIENT = address(0);
    address public constant VAULT = address(0);
    address public constant TOKEN = address(0);

    function run() public {
        (bytes memory data, address target) = runBase(REWARDS, RECIPIENT, VAULT, TOKEN);
        Logs.log(
            string.concat(
                "ClaimCuratorFees data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target)
            )
        );
    }
}
