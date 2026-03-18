// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {FeeRegistry as SymbioticFeeRegistry} from "../../../src/contracts/FeeRegistry.sol";
import {Rewards as SymbioticRewards} from "../../../src/contracts/Rewards.sol";
import {IFeeRegistry} from "../../../src/interfaces/IFeeRegistry.sol";
import {IRewards} from "../../../src/interfaces/IRewards.sol";

import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {ITransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {SymbioticRewardsConstants} from "../../../test/integration/SymbioticRewardsConstants.sol";
import {Logs} from "../../utils/Logs.sol";

contract AddDonationUpgradeBaseScript is ScriptBase {
    string internal constant REWARDS_FEE_ID = "rewards";
    // keccak256("eip1967.proxy.implementation") - 1
    bytes32 internal constant ERC1967_IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    // keccak256("eip1967.proxy.admin") - 1
    bytes32 internal constant ERC1967_ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    function runBase(uint256 donationDefaultFee) public {
        if (!SymbioticRewardsConstants.rewardsSupported()) {
            revert("AddDonationUpgradeBaseScript.runBase(): rewards not supported");
        }
        if (!SymbioticCoreConstants.coreSupported()) {
            revert("AddDonationUpgradeBaseScript.runBase(): core not supported");
        }

        SymbioticRewardsConstants.Rewards memory currentRewards = SymbioticRewardsConstants.rewards();
        SymbioticCoreConstants.Core memory core = SymbioticCoreConstants.core();

        address curatorRegistry = address(currentRewards.curatorRegistry);
        address feeRegistryProxy = address(currentRewards.feeRegistry);
        address rewardsProxy = address(currentRewards.rewards);

        bytes32 donationFeeId = _protocolFeeId(uint64(IRewards.RewardsType.DONATION));

        address feeRegistryProxyAdmin = _proxyAdmin(feeRegistryProxy);
        address rewardsProxyAdmin = _proxyAdmin(rewardsProxy);

        if (feeRegistryProxyAdmin.code.length == 0) {
            revert("AddDonationUpgradeBaseScript.runBase(): invalid FeeRegistry proxy admin");
        }
        if (rewardsProxyAdmin.code.length == 0) {
            revert("AddDonationUpgradeBaseScript.runBase(): invalid Rewards proxy admin");
        }

        vm.startBroadcast();

        address feeRegistryImplementation = address(new SymbioticFeeRegistry(curatorRegistry));
        address rewardsImplementation = address(
            new SymbioticRewards(
                address(core.vaultFactory),
                address(core.networkRegistry),
                address(core.networkMiddlewareService),
                curatorRegistry,
                feeRegistryProxy
            )
        );

        vm.stopBroadcast();

        bytes memory upgradeFeeRegistryData = abi.encodeCall(
            ProxyAdmin.upgradeAndCall,
            (ITransparentUpgradeableProxy(payable(feeRegistryProxy)), feeRegistryImplementation, new bytes(0))
        );
        bytes memory setDonationFeeData =
            abi.encodeCall(IFeeRegistry.setProtocolFee, (donationFeeId, true, donationDefaultFee));
        bytes memory upgradeRewardsData = abi.encodeCall(
            ProxyAdmin.upgradeAndCall,
            (ITransparentUpgradeableProxy(payable(rewardsProxy)), rewardsImplementation, new bytes(0))
        );

        sendTransaction(feeRegistryProxyAdmin, upgradeFeeRegistryData);
        sendTransaction(feeRegistryProxy, setDonationFeeData);
        sendTransaction(rewardsProxyAdmin, upgradeRewardsData);

        assert(_implementation(feeRegistryProxy) == feeRegistryImplementation);
        assert(_implementation(rewardsProxy) == rewardsImplementation);
        assert(_proxyAdmin(feeRegistryProxy) == feeRegistryProxyAdmin);
        assert(_proxyAdmin(rewardsProxy) == rewardsProxyAdmin);

        (bool donationFeeEnabled, uint256 donationFee) = IFeeRegistry(feeRegistryProxy).getProtocolFee(donationFeeId);
        assert(donationFeeEnabled);
        assert(donationFee == donationDefaultFee);

        Logs.log(string.concat("Deployed FeeRegistry implementation: ", vm.toString(feeRegistryImplementation)));
        Logs.log(string.concat("Deployed Rewards implementation: ", vm.toString(rewardsImplementation)));
        Logs.log(string.concat("FeeRegistry proxy: ", vm.toString(feeRegistryProxy)));
        Logs.log(string.concat("FeeRegistry proxy admin: ", vm.toString(feeRegistryProxyAdmin)));
        Logs.log(string.concat("Rewards proxy: ", vm.toString(rewardsProxy)));
        Logs.log(string.concat("Rewards proxy admin: ", vm.toString(rewardsProxyAdmin)));
        Logs.log(string.concat("Donation default fee configured", "\n    fee:", vm.toString(donationDefaultFee)));

        Logs.logSimulationLink(feeRegistryProxyAdmin, upgradeFeeRegistryData);
        Logs.logSimulationLink(feeRegistryProxy, setDonationFeeData);
        Logs.logSimulationLink(rewardsProxyAdmin, upgradeRewardsData);
    }

    function _protocolFeeId(uint64 rewardsType) internal pure returns (bytes32) {
        return keccak256(abi.encode(REWARDS_FEE_ID, rewardsType));
    }

    function _proxyAdmin(address proxy) internal view returns (address) {
        return address(uint160(uint256(vm.load(proxy, ERC1967_ADMIN_SLOT))));
    }

    function _implementation(address proxy) internal view returns (address) {
        return address(uint160(uint256(vm.load(proxy, ERC1967_IMPLEMENTATION_SLOT))));
    }
}
