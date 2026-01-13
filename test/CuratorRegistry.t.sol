// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import {CuratorRegistry} from "../src/contracts/CuratorRegistry.sol";
import {ICuratorRegistry} from "../src/interfaces/ICuratorRegistry.sol";
import {MockVault} from "./mocks/MockVault.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {SimpleRegistry} from "@symbioticfi/core/test/mocks/SimpleRegistry.sol";

contract CuratorRegistryTest is Test {
    CuratorRegistry curatorRegistry;
    SimpleRegistry vaultFactory;

    address owner;
    address curator1;
    address curator2;
    address unauthorized;
    MockVault vault1;
    MockVault vault2;
    MockVault vaultWithoutOwner;

    event SetCurator(address indexed vault, address indexed curator);

    function setUp() public {
        owner = makeAddr("owner");
        curator1 = makeAddr("curator1");
        curator2 = makeAddr("curator2");
        unauthorized = makeAddr("unauthorized");

        // Deploy CuratorRegistry
        vaultFactory = new SimpleRegistry();

        curatorRegistry = new CuratorRegistry(address(vaultFactory));
        curatorRegistry = CuratorRegistry(
            address(
                new TransparentUpgradeableProxy(
                    address(curatorRegistry), address(this), abi.encodeCall(curatorRegistry.initialize, ())
                )
            )
        );

        // Deploy mock vaults
        vault1 = new MockVault(owner, address(0x2), address(0x3));
        vault2 = new MockVault(owner, address(0x5), address(0x6));
        vaultWithoutOwner = new MockVault(address(0x7), address(0x8), address(0x9));

        // Register vaults in the mock factory
        vm.prank(address(vault1));
        vaultFactory.register();
        vm.prank(address(vault2));
        vaultFactory.register();
        vm.prank(address(vaultWithoutOwner));
        vaultFactory.register();
    }

    function test_SetCurator_OwnerSetsFirstCurator() public {
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);

        assertEq(curatorRegistry.getCurator(address(vault1)), curator1);
    }

    function test_SetCurator_EmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit SetCurator(address(vault1), curator1);

        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);
    }

    function test_SetCurator_CurrentCuratorChangesCurator() public {
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);

        vm.prank(curator1);
        curatorRegistry.setCurator(address(vault1), curator2);

        assertEq(curatorRegistry.getCurator(address(vault1)), curator2);
    }

    function test_SetCurator_UnauthorizedCannotChangeExistingCurator() public {
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);

        vm.prank(unauthorized);
        vm.expectRevert(ICuratorRegistry.NotAuthorized.selector);
        curatorRegistry.setCurator(address(vault1), curator2);
    }

    function test_SetCurator_NonCuratorCannotChangeExistingCurator() public {
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);

        vm.prank(curator2);
        vm.expectRevert(ICuratorRegistry.NotAuthorized.selector);
        curatorRegistry.setCurator(address(vault1), curator2);
    }

    function test_SetCurator_ZeroAddressCurator() public {
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), address(0));

        assertEq(curatorRegistry.getCurator(address(vault1)), address(0));
    }

    function test_GetCurator_NoCuratorSet() public view {
        assertEq(curatorRegistry.getCurator(address(vault1)), address(0));
    }

    function test_GetCurator_ReturnsCurrentCurator() public {
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);

        assertEq(curatorRegistry.getCurator(address(vault1)), curator1);
    }

    function test_GetCurator_ReturnsLatestCurator() public {
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);

        vm.prank(curator1);
        curatorRegistry.setCurator(address(vault1), curator2);

        assertEq(curatorRegistry.getCurator(address(vault1)), curator2);
    }

    function test_SetCurator_RevertWhen_NotVault() public {
        MockVault unregisteredVault = new MockVault(owner, address(0x10), address(0x11));

        vm.expectRevert(ICuratorRegistry.NotVault.selector);
        vm.prank(owner);
        curatorRegistry.setCurator(address(unregisteredVault), curator1);
    }

    function test_GetCuratorAt_NoCuratorSet() public view {
        assertEq(curatorRegistry.getCuratorAt(address(vault1), uint48(block.timestamp), new bytes(0)), address(0));
    }

    function test_GetCuratorAt_ReturnsCuratorAtSpecificTimestamp() public {
        // Set initial curator at timestamp 1
        vm.warp(1);
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);
        uint48 timestamp1 = 1;

        // Set second curator at timestamp 1001
        vm.warp(1001);
        vm.prank(curator1);
        curatorRegistry.setCurator(address(vault1), curator2);
        uint48 timestamp2 = 1001;

        // Check curator at first timestamp (should return curator1)
        assertEq(curatorRegistry.getCuratorAt(address(vault1), timestamp1, new bytes(0)), curator1);

        // Check curator at second timestamp (should return curator2)
        assertEq(curatorRegistry.getCuratorAt(address(vault1), timestamp2, new bytes(0)), curator2);

        // Check curator at a timestamp between the two (should return curator1)
        uint48 timestampBetween = 500;
        assertEq(curatorRegistry.getCuratorAt(address(vault1), timestampBetween, new bytes(0)), curator1);

        // Check current curator
        assertEq(curatorRegistry.getCurator(address(vault1)), curator2);
    }

    function test_MultipleVaults_IndependentCurators() public {
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);

        vm.prank(owner);
        curatorRegistry.setCurator(address(vault2), curator2);

        assertEq(curatorRegistry.getCurator(address(vault1)), curator1);
        assertEq(curatorRegistry.getCurator(address(vault2)), curator2);
    }

    function test_MultipleVaults_CuratorCanOnlyChangeOwnVault() public {
        // Set curators for both vaults
        vm.prank(owner);
        curatorRegistry.setCurator(address(vault1), curator1);

        vm.prank(owner);
        curatorRegistry.setCurator(address(vault2), curator2);

        // curator1 should not be able to change curator for vault2
        vm.prank(curator1);
        vm.expectRevert(ICuratorRegistry.NotAuthorized.selector);
        curatorRegistry.setCurator(address(vault2), curator1);

        // curator1 should be able to change curator for vault1
        vm.prank(curator1);
        curatorRegistry.setCurator(address(vault1), curator2);

        assertEq(curatorRegistry.getCurator(address(vault1)), curator2);
        assertEq(curatorRegistry.getCurator(address(vault2)), curator2);
    }
}
