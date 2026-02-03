// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SetCuratorNetworkFeeBaseScript} from "./base/SetCuratorNetworkFeeBase.s.sol";

import {Logs} from "../utils/Logs.sol";

contract SetCuratorNetworkFeeScript is SetCuratorNetworkFeeBaseScript {
    address public constant FEE_REGISTRY = address(0);
    address public constant VAULT = address(0);
    address public constant NETWORK = address(0);
    bool public constant ENABLE = false;
    uint256 public constant FEE = 0;

    function run() public {
        (bytes memory data, address target) = runBase(FEE_REGISTRY, VAULT, NETWORK, ENABLE, FEE);
        Logs.log(
            string.concat(
                "SetCuratorNetworkFee data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target)
            )
        );
    }
}
