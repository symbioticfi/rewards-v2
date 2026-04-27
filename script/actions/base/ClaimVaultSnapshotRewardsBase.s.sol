// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IVaultSnapshotRewards} from "../../../src/interfaces/IVaultSnapshotRewards.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "../../utils/Logs.sol";

contract ClaimVaultSnapshotRewardsBaseScript is ScriptBase {
    function runBase(
        address rewards,
        address recipient,
        address network,
        address token,
        address vault,
        uint256 lastUnclaimedRewards,
        uint256 firstRewardToClaim,
        uint256 rewardsToClaim,
        bytes[] memory activeSharesHints
    ) public returns (bytes memory data, address target) {
        target = address(IVaultSnapshotRewards(rewards));
        data = abi.encodeCall(
            IVaultSnapshotRewards(rewards).claimVaultSnapshotRewards,
            (
                recipient,
                network,
                token,
                vault,
                lastUnclaimedRewards,
                firstRewardToClaim,
                rewardsToClaim,
                activeSharesHints
            )
        );

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Claimed vault snapshot rewards",
                "\n    recipient:",
                vm.toString(recipient),
                "\n    vault:",
                vm.toString(vault)
            )
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
