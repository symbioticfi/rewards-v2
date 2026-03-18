// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SymbioticRewardsImports.sol";

library SymbioticRewardsConstants {
    struct Rewards {
        ISymbioticCuratorRegistry curatorRegistry;
        ISymbioticFeeRegistry feeRegistry;
        ISymbioticRewards rewards;
    }

    function rewardsSupported() internal view returns (bool) {
        return block.chainid == 1 || block.chainid == 560048;
    }

    function rewards() internal view returns (Rewards memory) {
        if (block.chainid == 1) {
            // mainnet
            return Rewards({
                curatorRegistry: ISymbioticCuratorRegistry(0xF75D8d8F790178F0d7F2ee7656874567d382C21e),
                feeRegistry: ISymbioticFeeRegistry(0x3E5a669F673712Bf72De956608E89D36561cbAf1),
                rewards: ISymbioticRewards(0xa13e65cA0FeFa52cCb9615108fF400EF4806866B)
            });
        } else if (block.chainid == 560048) {
            // hoodi
            return Rewards({
                curatorRegistry: ISymbioticCuratorRegistry(0x0fbd01C89F4B12475A67204FF4e18E809839B7b4),
                feeRegistry: ISymbioticFeeRegistry(0x4804a29f16E25cE1BcBd802547445012fa7e0051),
                rewards: ISymbioticRewards(0x2A49C0B7154919eA2453aA190A014994A5C87D84)
            });
        } else {
            revert("SymbioticRewardsConstants.rewards(): chainid not supported");
        }
    }
}
