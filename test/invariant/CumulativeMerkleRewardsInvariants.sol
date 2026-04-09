// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {ICumulativeMerkleRewards} from "../../src/interfaces/ICumulativeMerkleRewards.sol";
import {CumulativeMerkleRewardsHandler} from "./handlers/CumulativeMerkleRewardsHandler.sol";

contract CumulativeMerkleRewardsInvariants is Test {
    CumulativeMerkleRewardsHandler public handler;

    function setUp() public {
        handler = new CumulativeMerkleRewardsHandler();

        bytes4[] memory selectors = new bytes4[](6);
        selectors[0] = CumulativeMerkleRewardsHandler.depositCumulativeRewards.selector;
        selectors[1] = CumulativeMerkleRewardsHandler.distributeRewards.selector;
        selectors[2] = CumulativeMerkleRewardsHandler.claim.selector;
        selectors[3] = CumulativeMerkleRewardsHandler.claimViaRouter.selector;
        selectors[4] = CumulativeMerkleRewardsHandler.claimProtocolFees.selector;
        selectors[5] = CumulativeMerkleRewardsHandler.withdrawCumulativeRewards.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
        targetContract(address(handler));
    }

    function invariant_TokenAccounting() public {
        _assertTokenAccounting(address(handler.rewardsToken()));
        _assertTokenAccounting(address(handler.secondaryRewardsToken()));
    }

    function invariant_DistributionStateMatchesTrackedWatermarks() public {
        uint256 networksLen = handler.networksLength();

        for (uint256 i; i < networksLen; ++i) {
            address network = handler.networkAt(i);
            ICumulativeMerkleRewards.CumulativeDistribution memory distribution =
                handler.cumulativeMerkleRewards().lastCumulativeDistribution(network);

            assertEq(distribution.timestamp, handler.trackedLastTimestamp(network));
            _assertTrackedTotalAmount(network, address(handler.rewardsToken()));
            _assertTrackedTotalAmount(network, address(handler.secondaryRewardsToken()));

            uint256 rootsLen = handler.rootsLength(network);
            if (rootsLen == 0) {
                assertEq(distribution.timestamp, 0);
                assertEq(distribution.merkleRoot, bytes32(0));
                continue;
            }

            assertEq(distribution.merkleRoot, handler.rootAt(network, rootsLen - 1));
            for (uint256 j; j < rootsLen; ++j) {
                assertTrue(
                    handler.cumulativeMerkleRewards().isCumulativeDistributionRoot(network, handler.rootAt(network, j))
                );
            }
        }
    }

    function invariant_ClaimsStayWithinPublishedLeafAmounts() public {
        address token = address(handler.rewardsToken());
        uint256 networksLen = handler.networksLength();

        for (uint256 i; i < networksLen; ++i) {
            address network = handler.networkAt(i);
            uint256 rewardeesLen = handler.rewardeesLength(network);
            uint256 outstandingSum;

            for (uint256 j; j < rewardeesLen; ++j) {
                (
                    address account,
                    uint256 rewardeeType,
                    uint256 publishedAmount,
                    uint256 claimedAmount,
                    bool exists,
                    uint256 outstandingAmount
                ) = handler.rewardeeStateAt(network, j);

                if (!exists) {
                    assertEq(publishedAmount, 0);
                    assertEq(claimedAmount, 0);
                    assertEq(outstandingAmount, 0);
                    continue;
                }

                assertEq(
                    claimedAmount, handler.cumulativeMerkleRewards().claimed(network, token, account, rewardeeType)
                );
                assertLe(claimedAmount, publishedAmount);
                assertEq(outstandingAmount, publishedAmount - claimedAmount);
                outstandingSum += outstandingAmount;
            }

            assertEq(outstandingSum, handler.totalOutstandingByNetworkToken(network, token));
        }
    }

    function _assertTokenAccounting(address token) internal view {
        uint256 outstanding = handler.totalOutstandingByToken(token);
        uint256 claimable = handler.cumulativeMerkleRewards().protocolFees(token);
        uint256 sumBalances;

        uint256 networksLen = handler.networksLength();
        for (uint256 i; i < networksLen; ++i) {
            address network = handler.networkAt(i);
            sumBalances += handler.cumulativeMerkleRewards().balance(network, token);
        }

        uint256 contractBalance = IERC20(token).balanceOf(address(handler.cumulativeMerkleRewards()));
        assertEq(contractBalance, sumBalances + outstanding + claimable);
    }

    function _assertTrackedTotalAmount(address network, address token) internal view {
        assertEq(
            handler.cumulativeMerkleRewards().lastTotalAmount(network, token),
            handler.trackedLastTotalAmount(network, token)
        );
    }
}
