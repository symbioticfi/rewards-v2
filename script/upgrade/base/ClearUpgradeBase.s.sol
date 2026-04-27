// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {ITransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {SymbioticRewardsConstants} from "../../../test/integration/SymbioticRewardsConstants.sol";
import {Logs} from "../../utils/Logs.sol";

contract ClearUpgradeBaseScript is ScriptBase {
    // keccak256("eip1967.proxy.implementation") - 1
    bytes32 internal constant ERC1967_IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    // keccak256("eip1967.proxy.admin") - 1
    bytes32 internal constant ERC1967_ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    function runBase(address rewardsImplementation) public returns (bytes memory data, address target) {
        if (!SymbioticRewardsConstants.rewardsSupported()) {
            revert("ClearUpgradeBaseScript.runBase(): rewards not supported");
        }

        SymbioticRewardsConstants.Rewards memory currentRewards = SymbioticRewardsConstants.rewards();
        address rewardsProxy = address(currentRewards.rewards);
        address rewardsProxyAdmin = _proxyAdmin(rewardsProxy);

        if (rewardsProxyAdmin.code.length == 0) {
            revert("ClearUpgradeBaseScript.runBase(): invalid Rewards proxy admin");
        }
        if (rewardsImplementation.code.length == 0) {
            revert("ClearUpgradeBaseScript.runBase(): invalid Rewards implementation");
        }

        target = rewardsProxyAdmin;
        data = abi.encodeCall(
            ProxyAdmin.upgradeAndCall,
            (ITransparentUpgradeableProxy(payable(rewardsProxy)), rewardsImplementation, new bytes(0))
        );

        sendTransaction(target, data);

        assert(_implementation(rewardsProxy) == rewardsImplementation);
        assert(_proxyAdmin(rewardsProxy) == rewardsProxyAdmin);

        Logs.log(string.concat("Rewards implementation: ", vm.toString(rewardsImplementation)));
        Logs.log(string.concat("Rewards proxy: ", vm.toString(rewardsProxy)));
        Logs.log(string.concat("Rewards proxy admin: ", vm.toString(rewardsProxyAdmin)));

        Logs.logSimulationLink(target, data);

        return (data, target);
    }

    function _proxyAdmin(address proxy) internal view returns (address) {
        return address(uint160(uint256(vm.load(proxy, ERC1967_ADMIN_SLOT))));
    }

    function _implementation(address proxy) internal view returns (address) {
        return address(uint160(uint256(vm.load(proxy, ERC1967_IMPLEMENTATION_SLOT))));
    }
}
