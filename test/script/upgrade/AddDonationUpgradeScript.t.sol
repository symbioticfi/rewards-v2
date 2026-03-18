// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {StdConstants} from "forge-std/StdConstants.sol";

import {AddDonationUpgradeScript} from "../../../script/upgrade/AddDonationUpgrade.s.sol";
import {FeeRegistry} from "../../../src/contracts/FeeRegistry.sol";
import {IFeeRegistry} from "../../../src/interfaces/IFeeRegistry.sol";
import {IRewards} from "../../../src/interfaces/IRewards.sol";
import {SymbioticRewardsConstants} from "../../integration/SymbioticRewardsConstants.sol";

import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract DummyImplementation {}

contract AddDonationUpgradeHarness is AddDonationUpgradeScript {
    address internal constant HARNESS_BROADCAST_SENDER = StdConstants.DEFAULT_SENDER;
    address[] internal _targets;
    bytes[] internal _payloads;

    function sendTransaction(address target, bytes memory data) public override {
        _targets.push(target);
        _payloads.push(data);

        vm.prank(HARNESS_BROADCAST_SENDER);
        (bool success,) = target.call(data);
        if (!success) {
            revert("Transaction failed");
        }
    }

    function transactionCount() external view returns (uint256) {
        return _targets.length;
    }

    function transactionTarget(uint256 index) external view returns (address) {
        return _targets[index];
    }

    function transactionData(uint256 index) external view returns (bytes memory) {
        return _payloads[index];
    }
}

contract MockUpgradeableProxy {
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function upgradeToAndCall(address newImplementation, bytes calldata data) external payable {
        bytes32 implementationSlot = IMPLEMENTATION_SLOT;
        assembly {
            sstore(implementationSlot, newImplementation)
        }

        if (data.length > 0) {
            (bool success, bytes memory returnData) = newImplementation.delegatecall(data);
            if (!success) {
                assembly ("memory-safe") {
                    revert(add(returnData, 32), mload(returnData))
                }
            }
        }
    }

    fallback() external payable {
        bytes32 implementationSlot = IMPLEMENTATION_SLOT;
        assembly ("memory-safe") {
            let implementation := sload(implementationSlot)
            calldatacopy(0, 0, calldatasize())
            let success := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch success
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}

contract AddDonationUpgradeScriptTest is Test {
    address internal constant BROADCAST_SENDER = StdConstants.DEFAULT_SENDER;
    uint256 internal constant HOODI_CHAIN_ID = 560_048;
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    AddDonationUpgradeHarness internal script;

    address internal curatorRegistry;
    address internal feeRegistryProxy;
    address internal rewardsProxy;
    address internal feeRegistryProxyAdmin;
    address internal rewardsProxyAdmin;
    address internal oldFeeRegistryImplementation;
    address internal oldRewardsImplementation;

    function setUp() public {
        vm.chainId(HOODI_CHAIN_ID);

        script = new AddDonationUpgradeHarness();

        SymbioticRewardsConstants.Rewards memory currentRewards = SymbioticRewardsConstants.rewards();
        curatorRegistry = address(currentRewards.curatorRegistry);
        feeRegistryProxy = address(currentRewards.feeRegistry);
        rewardsProxy = address(currentRewards.rewards);

        _installProxy(feeRegistryProxy);
        _installProxy(rewardsProxy);

        feeRegistryProxyAdmin = address(new ProxyAdmin(BROADCAST_SENDER));
        rewardsProxyAdmin = address(new ProxyAdmin(BROADCAST_SENDER));
        oldFeeRegistryImplementation = address(new FeeRegistry(curatorRegistry));
        oldRewardsImplementation = address(new DummyImplementation());

        _setProxyAdmin(feeRegistryProxy, feeRegistryProxyAdmin);
        _setProxyAdmin(rewardsProxy, rewardsProxyAdmin);
        _setImplementation(feeRegistryProxy, oldFeeRegistryImplementation);
        _setImplementation(rewardsProxy, oldRewardsImplementation);

        FeeRegistry(feeRegistryProxy).initialize(BROADCAST_SENDER);
    }

    function test_RunBase_UpgradesBothProxiesAndSetsDonationFee() public {
        uint256 donationDefaultFee = 123_456;

        script.runBase(donationDefaultFee);

        address newFeeRegistryImplementation = _implementation(feeRegistryProxy);
        address newRewardsImplementation = _implementation(rewardsProxy);
        (bool isEnabled, uint256 fee) =
            IFeeRegistry(feeRegistryProxy).getProtocolFee(_protocolFeeId(uint64(IRewards.RewardsType.DONATION)));

        assertNotEq(newFeeRegistryImplementation, oldFeeRegistryImplementation);
        assertNotEq(newRewardsImplementation, oldRewardsImplementation);
        assertEq(FeeRegistry(feeRegistryProxy).owner(), BROADCAST_SENDER);
        assertTrue(isEnabled);
        assertEq(fee, donationDefaultFee);
        assertEq(script.transactionCount(), 3);
        assertEq(script.transactionTarget(0), feeRegistryProxyAdmin);
        assertEq(script.transactionTarget(1), feeRegistryProxy);
        assertEq(script.transactionTarget(2), rewardsProxyAdmin);
        assertEq(_selector(script.transactionData(0)), ProxyAdmin.upgradeAndCall.selector);
        assertEq(_selector(script.transactionData(1)), IFeeRegistry.setProtocolFee.selector);
        assertEq(_selector(script.transactionData(2)), ProxyAdmin.upgradeAndCall.selector);
    }

    function test_Run_UsesDonationDefaultFeeConstant() public {
        script.run();

        (bool isEnabled, uint256 fee) =
            IFeeRegistry(feeRegistryProxy).getProtocolFee(_protocolFeeId(uint64(IRewards.RewardsType.DONATION)));

        assertTrue(isEnabled);
        assertEq(fee, script.DONATION_DEFAULT_FEE());
    }

    function test_RunBase_RevertWhen_FeeRegistryProxyAdminHasNoCode() public {
        _setProxyAdmin(feeRegistryProxy, makeAddr("feeRegistryProxyAdminWithoutCode"));

        vm.expectRevert("AddDonationUpgradeBaseScript.runBase(): invalid FeeRegistry proxy admin");
        script.runBase(1);
    }

    function test_RunBase_RevertWhen_RewardsProxyAdminHasNoCode() public {
        _setProxyAdmin(rewardsProxy, makeAddr("rewardsProxyAdminWithoutCode"));

        vm.expectRevert("AddDonationUpgradeBaseScript.runBase(): invalid Rewards proxy admin");
        script.runBase(1);
    }

    function _installProxy(address proxy) internal {
        vm.etch(proxy, type(MockUpgradeableProxy).runtimeCode);
    }

    function _setImplementation(address proxy, address implementation) internal {
        vm.store(proxy, IMPLEMENTATION_SLOT, bytes32(uint256(uint160(implementation))));
    }

    function _setProxyAdmin(address proxy, address admin) internal {
        vm.store(proxy, ADMIN_SLOT, bytes32(uint256(uint160(admin))));
    }

    function _implementation(address proxy) internal view returns (address) {
        return address(uint160(uint256(vm.load(proxy, IMPLEMENTATION_SLOT))));
    }

    function _protocolFeeId(uint64 rewardsType) internal pure returns (bytes32) {
        return keccak256(abi.encode("rewards", rewardsType));
    }

    function _selector(bytes memory data) internal pure returns (bytes4 value) {
        assembly ("memory-safe") {
            value := mload(add(data, 32))
        }
    }
}
