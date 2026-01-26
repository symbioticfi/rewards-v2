// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IVaultSnapshotRewards} from "../../../src/interfaces/IVaultSnapshotRewards.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "../../utils/Logs.sol";

contract DistributeVaultSnapshotRewardsBaseScript is ScriptBase {
    function runBase(
        address rewards,
        bytes32 subnetwork,
        address token,
        address vault,
        uint256 amount,
        uint48 timestamp,
        bytes memory hints
    ) public returns (bytes memory data, address target) {
        target = address(IVaultSnapshotRewards(rewards));
        data = abi.encodeCall(
            IVaultSnapshotRewards(rewards).distributeVaultSnapshotRewards,
            (subnetwork, token, vault, amount, timestamp, hints)
        );

        sendTransaction(target, data);

        Logs.log(
            string.concat(
                "Distributed vault snapshot rewards",
                "\n    vault:",
                vm.toString(vault),
                "\n    token:",
                vm.toString(token),
                "\n    amount:",
                vm.toString(amount)
            )
        );
        Logs.logSimulationLink(target, data);

        return (data, target);
    }
}
