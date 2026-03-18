// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {AddDonationDeployBaseScript} from "./base/AddDonationDeployBase.s.sol";

contract AddDonationDeployScript is AddDonationDeployBaseScript {
    function run() external returns (address feeRegistryImplementation, address rewardsImplementation) {
        return runBase();
    }
}
