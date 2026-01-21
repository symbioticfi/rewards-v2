// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {FeeRegistry} from "../../../src/contracts/FeeRegistry.sol";
import {IFeeRegistry} from "../../../src/interfaces/IFeeRegistry.sol";
import {IRewards} from "../../../src/interfaces/IRewards.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract FeeRegistryBaseScript is Script {
    string internal constant REWARDS_FEE_ID = "rewards";

    function runBase(
        address curatorRegistry,
        address feeSetter,
        address proxyAdmin,
        uint256 cumulativeMerkleDefaultFee,
        uint256 vaultSnapshotDefaultFee
    ) public returns (address) {
        vm.startBroadcast();

        (,, address txOrigin) = vm.readCallers();

        address implementation = address(new FeeRegistry(curatorRegistry));
        address proxy = address(
            new TransparentUpgradeableProxy(
                implementation, proxyAdmin, abi.encodeCall(FeeRegistry.initialize, (feeSetter))
            )
        );

        IFeeRegistry(proxy)
            .setProtocolFee(
                keccak256(abi.encode(REWARDS_FEE_ID, IRewards.RewardsType.CUMULATIVE_MERKLE)),
                true,
                cumulativeMerkleDefaultFee
            );
        IFeeRegistry(proxy)
            .setProtocolFee(
                keccak256(abi.encode(REWARDS_FEE_ID, IRewards.RewardsType.VAULT_SNAPSHOT)),
                true,
                vaultSnapshotDefaultFee
            );
        Ownable(proxy).transferOwnership(feeSetter);

        vm.stopBroadcast();

        Logs.log(string.concat("Deployed FeeRegistry implementation: ", vm.toString(implementation)));
        Logs.log(string.concat("Deployed FeeRegistry proxy: ", vm.toString(proxy)));

        return proxy;
    }
}
