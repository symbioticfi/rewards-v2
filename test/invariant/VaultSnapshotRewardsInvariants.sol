// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {VaultSnapshotRewardsHandler} from "./handlers/VaultSnapshotRewardsHandler.sol";

contract VaultSnapshotRewardsInvariants is Test {
    VaultSnapshotRewardsHandler public handler;

    function setUp() public {
        handler = new VaultSnapshotRewardsHandler();

        bytes4[] memory selectors = new bytes4[](6);
        selectors[0] = VaultSnapshotRewardsHandler.stakeTokens.selector;
        selectors[1] = VaultSnapshotRewardsHandler.claim.selector;
        selectors[2] = VaultSnapshotRewardsHandler.distributeRewards.selector;
        selectors[3] = VaultSnapshotRewardsHandler.claimCuratorFee.selector;
        selectors[4] = VaultSnapshotRewardsHandler.claimOperatorFee.selector;
        selectors[5] = VaultSnapshotRewardsHandler.claimProtocolFees.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
        targetContract(address(handler));
    }

    function invariant_RewardsBalance() public view {
        assertEq(
            handler.rewardsToken().balanceOf(address(handler.vaultSnapshotRewards())),
            handler.totalDepositedAmount() - handler.totalRewardsClaimedAmount() - handler.totalFeesClaimedAmount()
        );
    }
}
