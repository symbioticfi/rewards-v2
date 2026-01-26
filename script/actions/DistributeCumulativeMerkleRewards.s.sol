// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DistributeCumulativeMerkleRewardsBaseScript} from "./base/DistributeCumulativeMerkleRewardsBase.s.sol";
import {ICumulativeMerkleRewards} from "../../src/interfaces/ICumulativeMerkleRewards.sol";

import {Logs} from "../utils/Logs.sol";

contract DistributeCumulativeMerkleRewardsScript is DistributeCumulativeMerkleRewardsBaseScript {
    address public constant REWARDS = address(0);
    address public constant NETWORK = address(0);
    bytes public constant PROTOCOL_SIGNATURE = hex"";
    bytes public constant REWARDER_SIGNATURE = hex"";
    ICumulativeMerkleRewards.CumulativeDistribution public CUMULATIVE_DISTRIBUTION =
        ICumulativeMerkleRewards.CumulativeDistribution({timestamp: 0, merkleRoot: bytes32(0)});
    ICumulativeMerkleRewards.TokenAmount public TOKEN_AMOUNT =
        ICumulativeMerkleRewards.TokenAmount({chainId: 0, token: address(0), amount: 0});

    function run() public {
        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts = new ICumulativeMerkleRewards.TokenAmount[](1);
        totalAmounts[0] = TOKEN_AMOUNT;

        (bytes memory data, address target) =
            runBase(REWARDS, NETWORK, CUMULATIVE_DISTRIBUTION, totalAmounts, PROTOCOL_SIGNATURE, REWARDER_SIGNATURE);
        Logs.log(
            string.concat(
                "DistributeCumulativeMerkleRewards data:",
                "\n    data:",
                vm.toString(data),
                "\n    target:",
                vm.toString(target)
            )
        );
    }
}
