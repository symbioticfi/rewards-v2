// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {StdConstants} from "forge-std/StdConstants.sol";

import {ClearDeployScript} from "../../../script/upgrade/ClearDeploy.s.sol";
import {ClearUpgradeBaseScript} from "../../../script/upgrade/base/ClearUpgradeBase.s.sol";
import {AddDonationDeployScript} from "../../../script/upgrade/AddDonationDeploy.s.sol";
import {AddDonationUpgradeBaseScript} from "../../../script/upgrade/base/AddDonationUpgradeBase.s.sol";
import {FeeRegistry} from "../../../src/contracts/FeeRegistry.sol";
import {Rewards} from "../../../src/contracts/Rewards.sol";
import {Checkpoints} from "../../../src/contracts/libraries/Checkpoints.sol";
import {ICumulativeMerkleRewards} from "../../../src/interfaces/ICumulativeMerkleRewards.sol";
import {IFeeRegistry} from "../../../src/interfaces/IFeeRegistry.sol";
import {IRewards} from "../../../src/interfaces/IRewards.sol";
import {IVaultSnapshotRewards} from "../../../src/interfaces/IVaultSnapshotRewards.sol";
import {SymbioticRewardsConstants} from "../../integration/SymbioticRewardsConstants.sol";

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract ClearUpgradeHarness is ClearUpgradeBaseScript {
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

    function runConfigured(address rewardsImplementation) external {
        runBase(rewardsImplementation);
    }
}

contract AddDonationUpgradeHarnessV2 is AddDonationUpgradeBaseScript {
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

    function runConfigured(address feeRegistryImplementation, address rewardsImplementation, uint256 donationDefaultFee)
        external
    {
        runBase(feeRegistryImplementation, rewardsImplementation, donationDefaultFee);
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

contract StorageSeedFeeRegistry is OwnableUpgradeable {
    using Checkpoints for Checkpoints.Trace208;

    struct FeeRegistryStorage {
        mapping(address vault => Checkpoints.Trace208 value) _operatorsFee;
        mapping(address vault => mapping(address network => Checkpoints.Trace208 value)) _operatorsNetworkFee;
        mapping(address vault => Checkpoints.Trace208 value) _curatorFee;
        mapping(address vault => mapping(address networkOrAdapter => Checkpoints.Trace208 value))
            _curatorNetworkOrAdapterFee;
        mapping(bytes32 id => uint208 fee) _protocolFee;
        mapping(address vault => uint256 value) _instantWithdrawFee;
    }

    bytes32 private constant FEE_REGISTRY_STORAGE_POSITION =
        0x93d27e35e5186e4ea21573d1a25649cf5417be8a9fc60183b644027fed662100;

    function initialize(address owner) external initializer {
        __Ownable_init(owner);
    }

    function seedOperatorsFee(address vault, uint256 fee) external {
        _feeRegistryStorage()._operatorsFee[vault].push(uint48(block.timestamp), uint208(fee));
    }

    function seedOperatorsNetworkFee(address vault, address network, bool enable, uint256 fee) external {
        _feeRegistryStorage()
        ._operatorsNetworkFee[vault][network].push(uint48(block.timestamp), _serializeFeeData(enable, fee));
    }

    function seedCuratorFee(address vault, uint256 fee) external {
        _feeRegistryStorage()._curatorFee[vault].push(uint48(block.timestamp), uint208(fee));
    }

    function seedCuratorNetworkFee(address vault, address networkOrAdapter, bool enable, uint256 fee) external {
        _feeRegistryStorage()
        ._curatorNetworkOrAdapterFee[vault][networkOrAdapter].push(
            uint48(block.timestamp), _serializeFeeData(enable, fee)
        );
    }

    function seedProtocolFee(bytes32 id, bool enable, uint256 fee) external {
        _feeRegistryStorage()._protocolFee[id] = _serializeFeeData(enable, fee);
    }

    function seedInstantWithdrawFee(address vault, uint256 fee) external {
        _feeRegistryStorage()._instantWithdrawFee[vault] = fee;
    }

    function _feeRegistryStorage() private pure returns (FeeRegistryStorage storage $) {
        assembly {
            $.slot := FEE_REGISTRY_STORAGE_POSITION
        }
    }

    function _serializeFeeData(bool isEnabled, uint256 fee) internal pure returns (uint208) {
        return uint208((fee << 1) | (isEnabled ? 1 : 0));
    }
}

contract StorageSeedRewards is OwnableUpgradeable {
    struct ProtocolFeesStorage {
        mapping(address token => uint256 fee) _claimableFee;
    }

    struct CuratorFeesStorage {
        mapping(address vault => mapping(address token => uint256 fee)) _curatorFees;
    }

    struct CumulativeMerkleRewardsStorage {
        mapping(address network => ICumulativeMerkleRewards.CumulativeDistribution) _lastCumulativeDistribution;
        mapping(address network => mapping(address token => uint256 amount)) _lastTotalAmounts;
        mapping(address network => mapping(bytes32 root => bool value)) _isCumulativeDistributionRoot;
        mapping(address network => mapping(address token => uint256 amount)) _balances;
        mapping(
            address network
                => mapping(
                address token => mapping(address rewardee => mapping(uint256 rewardeeType => uint256 amount))
            )
        ) _claimed;
        mapping(address network => address value) _rewarder;
        address protocol;
    }

    struct VaultSnapshotRewardsStorage {
        mapping(address vault => mapping(address network => mapping(address token => uint256 value))) _rewardsLength;
        mapping(
            address vault
                => mapping(
                address network
                    => mapping(address token => mapping(uint256 index => IVaultSnapshotRewards.RewardDistribution))
            )
        ) _rewards;
        mapping(
            address account
                => mapping(address vault => mapping(address network => mapping(address token => uint256 rewardIndex)))
        ) _lastUnclaimedReward;
        mapping(
            address account
                => mapping(address vault => mapping(address network => mapping(address token => uint256 rewardIndex)))
        ) _lastUnclaimedOperatorReward;
        mapping(address vault => mapping(uint48 timestamp => uint256 amount)) _activeSharesCache;
        bytes32 __gap;
        mapping(address vault => mapping(bytes32 subnetwork => mapping(uint48 timestamp => uint256 amount)))
            _totalOperatorNetworkSharesCache;
        mapping(address vault => mapping(bytes32 subnetwork => mapping(uint48 timestamp => uint256 amount)))
            _subnetworkFilledCache;
        mapping(address vault => mapping(uint48 timestamp => uint256 amount)) _activeWithdrawalSharesCache;
    }

    bytes32 private constant PROTOCOL_FEES_STORAGE_POSITION =
        0xaca04fd08ff691cdb4ae78510a180bcc9e13b5c0befede355a0801aecf227800;
    bytes32 private constant CURATOR_FEES_STORAGE_POSITION =
        0xea7ec811d4da20f680ecf87dbad2b956cc74e833cd99b5f63865df6b3d6b6804;
    bytes32 private constant CUMULATIVE_MERKLE_REWARDS_STORAGE_POSITION =
        0xb35d10d93f469d2505237bd5d8067e02fbabfe765e611799bdbd03de345d3300;
    bytes32 private constant VAULT_SNAPSHOT_REWARDS_STORAGE_POSITION =
        0xea7ec811d4da20f680ecf87dbad2b956cc74e833cd99b5f63865df6b3d6b6800;

    function initialize(address owner) external initializer {
        __Ownable_init(owner);
    }

    function seedProtocolFees(address token, uint256 fee) external {
        _protocolFeesStorage()._claimableFee[token] = fee;
    }

    function seedCuratorFees(address vault, address token, uint256 fee) external {
        _curatorFeesStorage()._curatorFees[vault][token] = fee;
    }

    function seedLastCumulativeDistribution(address network, uint48 timestamp, bytes32 merkleRoot) external {
        _cumulativeMerkleRewardsStorage()._lastCumulativeDistribution[network] =
            ICumulativeMerkleRewards.CumulativeDistribution({timestamp: timestamp, merkleRoot: merkleRoot});
    }

    function seedLastTotalAmount(address network, address token, uint256 amount) external {
        _cumulativeMerkleRewardsStorage()._lastTotalAmounts[network][token] = amount;
    }

    function seedCumulativeDistributionRoot(address network, bytes32 root, bool value) external {
        _cumulativeMerkleRewardsStorage()._isCumulativeDistributionRoot[network][root] = value;
    }

    function seedCumulativeBalance(address network, address token, uint256 amount) external {
        _cumulativeMerkleRewardsStorage()._balances[network][token] = amount;
    }

    function seedClaimed(address network, address token, address rewardee, uint256 rewardeeType, uint256 amount)
        external
    {
        _cumulativeMerkleRewardsStorage()._claimed[network][token][rewardee][rewardeeType] = amount;
    }

    function seedRewarder(address network, address rewarder_) external {
        _cumulativeMerkleRewardsStorage()._rewarder[network] = rewarder_;
    }

    function seedProtocol(address protocol_) external {
        _cumulativeMerkleRewardsStorage().protocol = protocol_;
    }

    function seedRewardsLength(address vault, address network, address token, uint256 length) external {
        _vaultSnapshotRewardsStorage()._rewardsLength[vault][network][token] = length;
    }

    function seedRewardDistribution(
        address vault,
        address network,
        address token,
        uint256 index,
        IVaultSnapshotRewards.RewardDistribution calldata distribution
    ) external {
        _vaultSnapshotRewardsStorage()._rewards[vault][network][token][index] = distribution;
    }

    function seedLastUnclaimedReward(address account, address vault, address network, address token, uint256 index)
        external
    {
        _vaultSnapshotRewardsStorage()._lastUnclaimedReward[account][vault][network][token] = index;
    }

    function seedLastUnclaimedOperatorReward(
        address account,
        address vault,
        address network,
        address token,
        uint256 index
    ) external {
        _vaultSnapshotRewardsStorage()._lastUnclaimedOperatorReward[account][vault][network][token] = index;
    }

    function _protocolFeesStorage() private pure returns (ProtocolFeesStorage storage $) {
        assembly {
            $.slot := PROTOCOL_FEES_STORAGE_POSITION
        }
    }

    function _curatorFeesStorage() private pure returns (CuratorFeesStorage storage $) {
        assembly {
            $.slot := CURATOR_FEES_STORAGE_POSITION
        }
    }

    function _cumulativeMerkleRewardsStorage() private pure returns (CumulativeMerkleRewardsStorage storage $) {
        assembly {
            $.slot := CUMULATIVE_MERKLE_REWARDS_STORAGE_POSITION
        }
    }

    function _vaultSnapshotRewardsStorage() private pure returns (VaultSnapshotRewardsStorage storage $) {
        assembly {
            $.slot := VAULT_SNAPSHOT_REWARDS_STORAGE_POSITION
        }
    }
}

contract ClearUpgradeScriptTest is Test {
    address internal constant BROADCAST_SENDER = StdConstants.DEFAULT_SENDER;
    uint256 internal constant HOODI_CHAIN_ID = 560_048;
    uint256 internal constant DONATION_DEFAULT_FEE = 0.1 * 1e6;
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    address internal constant VAULT = address(0x1111);
    address internal constant NETWORK = address(0x2222);
    address internal constant TOKEN = address(0x3333);
    address internal constant TOKEN_2 = address(0x4444);
    address internal constant ACCOUNT = address(0x5555);
    address internal constant REWARDER = address(0x6666);
    address internal constant PROTOCOL = address(0x7777);

    ClearDeployScript internal clearDeployScript;
    ClearUpgradeHarness internal clearUpgradeScript;
    AddDonationDeployScript internal addDonationDeployScript;
    AddDonationUpgradeHarnessV2 internal addDonationUpgradeScript;

    address internal curatorRegistry;
    address internal feeRegistryProxy;
    address internal rewardsProxy;
    address internal feeRegistryProxyAdmin;
    address internal rewardsProxyAdmin;
    address internal seedFeeRegistryImplementation;
    address internal seedRewardsImplementation;

    function setUp() public {
        vm.chainId(HOODI_CHAIN_ID);

        clearDeployScript = new ClearDeployScript();
        clearUpgradeScript = new ClearUpgradeHarness();
        addDonationDeployScript = new AddDonationDeployScript();
        addDonationUpgradeScript = new AddDonationUpgradeHarnessV2();

        SymbioticRewardsConstants.Rewards memory currentRewards = SymbioticRewardsConstants.rewards();
        curatorRegistry = address(currentRewards.curatorRegistry);
        feeRegistryProxy = address(currentRewards.feeRegistry);
        rewardsProxy = address(currentRewards.rewards);

        _installProxy(feeRegistryProxy);
        _installProxy(rewardsProxy);

        feeRegistryProxyAdmin = address(new ProxyAdmin(BROADCAST_SENDER));
        rewardsProxyAdmin = address(new ProxyAdmin(BROADCAST_SENDER));
        seedFeeRegistryImplementation = address(new StorageSeedFeeRegistry());
        seedRewardsImplementation = address(new StorageSeedRewards());

        _setProxyAdmin(feeRegistryProxy, feeRegistryProxyAdmin);
        _setProxyAdmin(rewardsProxy, rewardsProxyAdmin);
        _setImplementation(feeRegistryProxy, seedFeeRegistryImplementation);
        _setImplementation(rewardsProxy, seedRewardsImplementation);

        StorageSeedFeeRegistry(feeRegistryProxy).initialize(BROADCAST_SENDER);
        StorageSeedRewards(rewardsProxy).initialize(BROADCAST_SENDER);
    }

    function test_ClearDeploy_DeploysEmptyImplementation() public {
        address rewardsImplementation = clearDeployScript.run();

        assertTrue(rewardsImplementation.code.length > 0);
    }

    function test_ClearDeploy_RevertWhen_RewardsUnsupported() public {
        vm.chainId(31_337);

        vm.expectRevert("ClearDeployBaseScript.runBase(): rewards not supported");
        clearDeployScript.run();
    }

    function test_ClearUpgrade_UpgradesRewardsProxyToEmptyImplementation() public {
        address clearImplementation = clearDeployScript.run();

        clearUpgradeScript.runConfigured(clearImplementation);

        assertEq(_implementation(rewardsProxy), clearImplementation);
        assertEq(clearUpgradeScript.transactionCount(), 1);
        assertEq(clearUpgradeScript.transactionTarget(0), rewardsProxyAdmin);
        assertEq(_selector(clearUpgradeScript.transactionData(0)), ProxyAdmin.upgradeAndCall.selector);
    }

    function test_ClearUpgrade_RevertWhen_RewardsImplementationHasNoCode() public {
        vm.expectRevert("ClearUpgradeBaseScript.runBase(): invalid Rewards implementation");
        clearUpgradeScript.runConfigured(address(0));
    }

    function test_ClearUpgrade_RevertWhen_RewardsProxyAdminHasNoCode() public {
        _setProxyAdmin(rewardsProxy, makeAddr("rewardsProxyAdminWithoutCode"));
        address clearImplementation = clearDeployScript.run();

        vm.expectRevert("ClearUpgradeBaseScript.runBase(): invalid Rewards proxy admin");
        clearUpgradeScript.runConfigured(clearImplementation);
    }

    function test_ClearUpgrade_RevertWhen_RewardsUnsupported() public {
        address clearImplementation = clearDeployScript.run();
        vm.chainId(31_337);

        vm.expectRevert("ClearUpgradeBaseScript.runBase(): rewards not supported");
        clearUpgradeScript.runConfigured(clearImplementation);
    }

    function test_ClearThenAddDonationUpgrade_PreservesStorage() public {
        bytes32 oldProtocolFeeId = _protocolFeeId(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE));
        bytes32 donationFeeId = _protocolFeeId(uint64(IRewards.RewardsType.DONATION));
        bytes32 merkleRoot = keccak256("clear-upgrade-root");
        IVaultSnapshotRewards.RewardDistribution memory distribution = IVaultSnapshotRewards.RewardDistribution({
            subnetworkId: 7,
            delegator: address(0x8888),
            delegatorType: 3,
            timestamp: 1_717_171,
            amountToDeposits: 1234,
            operatorsFees: 567,
            amountToWithdrawals: 89
        });

        _seedFeeRegistryState(oldProtocolFeeId);
        _seedRewardsState(merkleRoot, distribution);

        address clearImplementation = clearDeployScript.run();
        clearUpgradeScript.runConfigured(clearImplementation);
        assertEq(_implementation(rewardsProxy), clearImplementation);

        (address newFeeRegistryImplementation, address newRewardsImplementation) = addDonationDeployScript.run();
        addDonationUpgradeScript.runConfigured(
            newFeeRegistryImplementation, newRewardsImplementation, DONATION_DEFAULT_FEE
        );

        assertEq(_implementation(feeRegistryProxy), newFeeRegistryImplementation);
        assertEq(_implementation(rewardsProxy), newRewardsImplementation);

        assertEq(FeeRegistry(feeRegistryProxy).owner(), BROADCAST_SENDER);
        assertEq(Rewards(rewardsProxy).owner(), BROADCAST_SENDER);

        assertEq(FeeRegistry(feeRegistryProxy).getOperatorsDefaultFee(VAULT), 11_000);
        assertEq(FeeRegistry(feeRegistryProxy).getOperatorsFee(VAULT, NETWORK), 22_000);
        assertEq(FeeRegistry(feeRegistryProxy).getCuratorDefaultFee(VAULT), 33_000);
        assertEq(FeeRegistry(feeRegistryProxy).getCuratorFee(VAULT, NETWORK), 44_000);
        assertEq(FeeRegistry(feeRegistryProxy).getInstantWithdrawFee(VAULT), 55_000);

        (bool oldProtocolFeeEnabled, uint256 oldProtocolFee) =
            FeeRegistry(feeRegistryProxy).getProtocolFee(oldProtocolFeeId);
        assertTrue(oldProtocolFeeEnabled);
        assertEq(oldProtocolFee, 66_000);

        (bool donationFeeEnabled, uint256 donationFee) = FeeRegistry(feeRegistryProxy).getProtocolFee(donationFeeId);
        assertTrue(donationFeeEnabled);
        assertEq(donationFee, DONATION_DEFAULT_FEE);

        assertEq(Rewards(rewardsProxy).protocolFees(TOKEN), 777);
        assertEq(Rewards(rewardsProxy).curatorFees(VAULT, TOKEN), 888);
        assertEq(Rewards(rewardsProxy).balance(NETWORK, TOKEN), 999);
        assertEq(Rewards(rewardsProxy).claimed(NETWORK, TOKEN, ACCOUNT, 3), 111);
        assertEq(Rewards(rewardsProxy).rewarder(NETWORK), REWARDER);
        assertEq(Rewards(rewardsProxy).protocol(), PROTOCOL);
        assertEq(Rewards(rewardsProxy).lastTotalAmount(NETWORK, TOKEN), 222);
        assertEq(Rewards(rewardsProxy).lastCumulativeDistribution(NETWORK).timestamp, 123_456);
        assertEq(Rewards(rewardsProxy).lastCumulativeDistribution(NETWORK).merkleRoot, merkleRoot);
        assertTrue(Rewards(rewardsProxy).isCumulativeDistributionRoot(NETWORK, merkleRoot));

        assertEq(Rewards(rewardsProxy).rewardsLength(VAULT, NETWORK, TOKEN), 1);
        IVaultSnapshotRewards.RewardDistribution memory storedDistribution =
            Rewards(rewardsProxy).rewards(VAULT, NETWORK, TOKEN, 0);
        assertEq(storedDistribution.subnetworkId, distribution.subnetworkId);
        assertEq(storedDistribution.delegator, distribution.delegator);
        assertEq(storedDistribution.delegatorType, distribution.delegatorType);
        assertEq(storedDistribution.timestamp, distribution.timestamp);
        assertEq(storedDistribution.amountToDeposits, distribution.amountToDeposits);
        assertEq(storedDistribution.operatorsFees, distribution.operatorsFees);
        assertEq(storedDistribution.amountToWithdrawals, distribution.amountToWithdrawals);
        assertEq(Rewards(rewardsProxy).lastUnclaimedReward(ACCOUNT, VAULT, NETWORK, TOKEN), 12);
        assertEq(Rewards(rewardsProxy).lastUnclaimedOperatorReward(ACCOUNT, VAULT, NETWORK, TOKEN), 13);

        vm.expectRevert(Initializable.InvalidInitialization.selector);
        Rewards(rewardsProxy).initialize(makeAddr("reinitializer"));

        assertEq(addDonationUpgradeScript.transactionCount(), 3);
        assertEq(addDonationUpgradeScript.transactionTarget(0), feeRegistryProxyAdmin);
        assertEq(addDonationUpgradeScript.transactionTarget(1), feeRegistryProxy);
        assertEq(addDonationUpgradeScript.transactionTarget(2), rewardsProxyAdmin);
        assertEq(_selector(addDonationUpgradeScript.transactionData(0)), ProxyAdmin.upgradeAndCall.selector);
        assertEq(_selector(addDonationUpgradeScript.transactionData(1)), IFeeRegistry.setProtocolFee.selector);
        assertEq(_selector(addDonationUpgradeScript.transactionData(2)), ProxyAdmin.upgradeAndCall.selector);
    }

    function _seedFeeRegistryState(bytes32 oldProtocolFeeId) internal {
        StorageSeedFeeRegistry feeRegistry = StorageSeedFeeRegistry(feeRegistryProxy);

        feeRegistry.seedOperatorsFee(VAULT, 11_000);
        feeRegistry.seedOperatorsNetworkFee(VAULT, NETWORK, true, 22_000);
        feeRegistry.seedCuratorFee(VAULT, 33_000);
        feeRegistry.seedCuratorNetworkFee(VAULT, NETWORK, true, 44_000);
        feeRegistry.seedInstantWithdrawFee(VAULT, 55_000);
        feeRegistry.seedProtocolFee(oldProtocolFeeId, true, 66_000);
    }

    function _seedRewardsState(bytes32 merkleRoot, IVaultSnapshotRewards.RewardDistribution memory distribution)
        internal
    {
        StorageSeedRewards rewards = StorageSeedRewards(rewardsProxy);

        rewards.seedProtocolFees(TOKEN, 777);
        rewards.seedCuratorFees(VAULT, TOKEN, 888);
        rewards.seedLastCumulativeDistribution(NETWORK, 123_456, merkleRoot);
        rewards.seedLastTotalAmount(NETWORK, TOKEN, 222);
        rewards.seedCumulativeDistributionRoot(NETWORK, merkleRoot, true);
        rewards.seedCumulativeBalance(NETWORK, TOKEN, 999);
        rewards.seedClaimed(NETWORK, TOKEN, ACCOUNT, 3, 111);
        rewards.seedRewarder(NETWORK, REWARDER);
        rewards.seedProtocol(PROTOCOL);
        rewards.seedRewardsLength(VAULT, NETWORK, TOKEN, 1);
        rewards.seedRewardDistribution(VAULT, NETWORK, TOKEN, 0, distribution);
        rewards.seedLastUnclaimedReward(ACCOUNT, VAULT, NETWORK, TOKEN, 12);
        rewards.seedLastUnclaimedOperatorReward(ACCOUNT, VAULT, NETWORK, TOKEN, 13);
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
