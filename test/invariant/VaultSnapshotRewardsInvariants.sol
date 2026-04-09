// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {VAULT_V2_VERSION} from "../../src/interfaces/IVaultV2.sol";
import {IVaultSnapshotRewards} from "../../src/interfaces/IVaultSnapshotRewards.sol";
import {VaultSnapshotRewardsHandler} from "./handlers/VaultSnapshotRewardsHandler.sol";

contract VaultSnapshotRewardsInvariants is Test {
    VaultSnapshotRewardsHandler public handler;

    function setUp() public {
        handler = new VaultSnapshotRewardsHandler();

        bool donationSupported = handler.vaultVersion() >= VAULT_V2_VERSION;
        bytes4[] memory selectors = new bytes4[](donationSupported ? 9 : 8);
        selectors[0] = VaultSnapshotRewardsHandler.stakeTokens.selector;
        selectors[1] = VaultSnapshotRewardsHandler.claim.selector;
        selectors[2] = VaultSnapshotRewardsHandler.distributeRewards.selector;
        selectors[3] = VaultSnapshotRewardsHandler.claimCuratorFees.selector;
        selectors[4] = VaultSnapshotRewardsHandler.claimOperatorFees.selector;
        selectors[5] = VaultSnapshotRewardsHandler.claimProtocolFees.selector;
        if (donationSupported) {
            selectors[6] = VaultSnapshotRewardsHandler.donateRewards.selector;
            selectors[7] = VaultSnapshotRewardsHandler.staleClaimAttempt.selector;
            selectors[8] = VaultSnapshotRewardsHandler.staleOperatorClaimAttempt.selector;
        } else {
            selectors[6] = VaultSnapshotRewardsHandler.staleClaimAttempt.selector;
            selectors[7] = VaultSnapshotRewardsHandler.staleOperatorClaimAttempt.selector;
        }

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
        targetContract(address(handler));
    }

    function invariant_RewardsBalance() public view {
        assertEq(
            handler.rewardsToken().balanceOf(address(handler.vaultSnapshotRewards())),
            handler.totalDepositedAmount() - handler.totalRewardsClaimedAmount() - handler.totalFeesClaimedAmount()
        );
    }

    function invariant_DistributionBucketsConserveReceivedAmount() public view {
        assertEq(
            handler.totalReceivedAmount(),
            handler.totalProtocolFeesAccrued() + handler.totalCuratorFeesAccrued() + handler.totalOperatorFeesAccrued()
                + handler.totalNetRewardsAccrued() + handler.totalDonatedAmount()
        );
    }

    function invariant_ClaimCursorsStayBounded() public view {
        uint256 rewardsLength = handler.vaultSnapshotRewards()
            .rewardsLength(address(handler.vault()), handler.network(), address(handler.rewardsToken()));

        uint256 stakersLength = handler.stakersLength();
        for (uint256 i; i < stakersLength; ++i) {
            address staker = handler.stakerAt(i);
            uint256 cursor = handler.vaultSnapshotRewards()
                .lastUnclaimedReward(
                    staker, address(handler.vault()), handler.network(), address(handler.rewardsToken())
                );
            assertEq(cursor, handler.trackedStakerCursor(staker));
            assertLe(cursor, rewardsLength);
        }

        uint256 operatorsLength = handler.operatorsLength();
        for (uint256 i; i < operatorsLength; ++i) {
            address operator = handler.operatorAt(i);
            uint256 cursor = handler.vaultSnapshotRewards()
                .lastUnclaimedOperatorReward(
                    operator, address(handler.vault()), handler.network(), address(handler.rewardsToken())
                );
            assertEq(cursor, handler.trackedOperatorCursor(operator));
            assertLe(cursor, rewardsLength);
        }
    }

    function invariant_FeeBucketsMatchAccrualMinusClaims() public view {
        address token = address(handler.rewardsToken());

        assertEq(
            handler.vaultSnapshotRewards().protocolFees(token) + handler.totalProtocolFeesClaimedAmount(),
            handler.totalProtocolFeesAccrued()
        );
        assertEq(
            handler.vaultSnapshotRewards().curatorFees(address(handler.vault()), token)
                + handler.totalCuratorFeesClaimedAmount(),
            handler.totalCuratorFeesAccrued()
        );
        assertLe(handler.totalOperatorFeesClaimedAmount(), handler.totalOperatorFeesAccrued());
        assertLe(handler.totalRewardsClaimedAmount(), handler.totalNetRewardsAccrued());
    }

    function invariant_RewardRecordsAreWellFormed() public view {
        uint256 rewardsLength = handler.vaultSnapshotRewards()
            .rewardsLength(address(handler.vault()), handler.network(), address(handler.rewardsToken()));
        uint256 operatorFeesSum;
        uint256 netRewardsSum;

        for (uint256 i; i < rewardsLength; ++i) {
            IVaultSnapshotRewards.RewardDistribution memory reward = handler.vaultSnapshotRewards()
                .rewards(address(handler.vault()), handler.network(), address(handler.rewardsToken()), i);

            assertEq(reward.subnetworkId, handler.SUBNETWORK_ID());
            assertEq(reward.delegator, address(handler.networkRestakeDelegator()));
            assertEq(reward.delegatorType, uint64(IVaultSnapshotRewards.DelegatorType.NETWORK_RESTAKE));
            assertLt(reward.timestamp, block.timestamp);
            assertGt(reward.amountToDeposits + reward.amountToWithdrawals + reward.operatorsFees, 0);

            operatorFeesSum += reward.operatorsFees;
            netRewardsSum += reward.amountToDeposits + reward.amountToWithdrawals;
        }

        assertEq(operatorFeesSum, handler.totalOperatorFeesAccrued());
        assertEq(netRewardsSum, handler.totalNetRewardsAccrued());
    }
}
