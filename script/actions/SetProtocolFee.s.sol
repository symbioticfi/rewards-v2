// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SetProtocolFeeBaseScript} from "./base/SetProtocolFeeBase.s.sol";

import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SetProtocolFeeScript is SetProtocolFeeBaseScript {
    address public constant FEE_REGISTRY = address(0);
    bytes32 public constant ID = bytes32(0);
    bool public constant ENABLE = false;
    uint256 public constant FEE = 0;

    function run() public {
        (bytes memory data, address target) = runBase(FEE_REGISTRY, ID, ENABLE, FEE);
        Logs.log(
            string.concat(
                "SetProtocolFee data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target)
            )
        );
    }
}
