// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {AddDonationUpgradeBaseScript} from "./base/AddDonationUpgradeBase.s.sol";
import {Logs} from "../utils/Logs.sol";

contract AddDonationUpgradeScript is AddDonationUpgradeBaseScript {
    // Configuration constants - UPDATE THESE BEFORE EXECUTING

    // Address of the new FeeRegistry implementation
    address public constant FEE_REGISTRY_IMPLEMENTATION = address(0);
    // Address of the new Rewards implementation
    address public constant REWARDS_IMPLEMENTATION = address(0);
    // Default fee for Donation rewards
    uint256 public constant DONATION_DEFAULT_FEE = 0.1 * 1e6;

    function run() public {
        (bytes memory data, address target) =
            runBase(FEE_REGISTRY_IMPLEMENTATION, REWARDS_IMPLEMENTATION, DONATION_DEFAULT_FEE);
        Logs.log(
            string.concat(
                "AddDonationUpgrade data:", "\n    data:", vm.toString(data), "\n    target:", vm.toString(target)
            )
        );
    }
}
