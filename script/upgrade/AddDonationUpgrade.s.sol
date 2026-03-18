// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {AddDonationUpgradeBaseScript} from "./base/AddDonationUpgradeBase.s.sol";

contract AddDonationUpgradeScript is AddDonationUpgradeBaseScript {
    // Configuration constants - UPDATE THESE BEFORE EXECUTING

    // Default fee for Donation rewards
    uint256 public constant DONATION_DEFAULT_FEE = 0.1 * 1e6;

    function run() external {
        runBase(DONATION_DEFAULT_FEE);
    }
}
