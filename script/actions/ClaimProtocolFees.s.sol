// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ClaimProtocolFeesBaseScript} from "./base/ClaimProtocolFeesBase.s.sol";

import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract ClaimProtocolFeesScript is ClaimProtocolFeesBaseScript {
    address public constant PROTOCOL_FEES = address(0);
    address public constant RECIPIENT = address(0);
    address public constant TOKEN = address(0);

    function run() public {
        (bytes memory data, address target) = runBase(PROTOCOL_FEES, RECIPIENT, TOKEN);
        Logs.log(
            string.concat(
                "ClaimProtocolFees data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target)
            )
        );
    }
}
