// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
        address token = address(handler.rewardsToken());

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
}
