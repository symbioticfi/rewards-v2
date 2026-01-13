// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {SignDistributionBaseScript} from "./base/SignDistributionBase.s.sol";
import {ICumulativeMerkleRewards} from "../../src/interfaces/ICumulativeMerkleRewards.sol";

import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SignDistributionScript is SignDistributionBaseScript {
    uint256 public constant PRIVATE_KEY = 0;
    address public constant NETWORK = address(0);
    ICumulativeMerkleRewards.CumulativeDistribution public CUMULATIVE_DISTRIBUTION =
        ICumulativeMerkleRewards.CumulativeDistribution({timestamp: 0, merkleRoot: bytes32(0)});
    ICumulativeMerkleRewards.TokenAmount public TOKEN_AMOUNT =
        ICumulativeMerkleRewards.TokenAmount({chainId: 0, token: address(0), amount: 0});

    function run() public {
        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts = new ICumulativeMerkleRewards.TokenAmount[](1);
        totalAmounts[0] = TOKEN_AMOUNT;
        bytes memory signature = runBase(PRIVATE_KEY, NETWORK, CUMULATIVE_DISTRIBUTION, totalAmounts);
        Logs.log(string.concat("SignDistribution signature:", "\n    signature:", vm.toString(signature)));
    }
}
