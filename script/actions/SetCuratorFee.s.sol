// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SetCuratorFeeBaseScript} from "./base/SetCuratorFeeBase.s.sol";

import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SetCuratorFeeScript is SetCuratorFeeBaseScript {
    address public constant FEE_REGISTRY = address(0);
    address public constant VAULT = address(0);
    uint256 public constant FEE = 0;

    function run() public {
        (bytes memory data, address target) = runBase(FEE_REGISTRY, VAULT, FEE);
        Logs.log(
            string.concat("SetCuratorFee data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target))
        );
    }
}
