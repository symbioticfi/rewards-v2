// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {RewardsV2TestBase} from "../../RewardsV2TestBase.sol";
import {CumulativeMerkleRewards} from "../../../src/contracts/CumulativeMerkleRewards.sol";
import {ProtocolFees} from "../../../src/contracts/ProtocolFees.sol";
import {ICumulativeMerkleRewards} from "../../../src/interfaces/ICumulativeMerkleRewards.sol";
import {IRewards} from "../../../src/interfaces/IRewards.sol";
import {MerkleTreeUtils} from "../../utils/MerkleTreeUtils.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract TestableCumulativeMerkleRewards is CumulativeMerkleRewards {
    constructor(address feeRegistry) ProtocolFees(feeRegistry) {}

    function initialize(address owner) external initializer {
        __CumulativeMerkleRewards_init();
        __ProtocolFees_init(owner);
    }

    function hashCumulativeDistributionPayload(
        address network,
        ICumulativeMerkleRewards.CumulativeDistribution calldata cumulativeDistribution,
        ICumulativeMerkleRewards.TokenAmount[] calldata totalAmounts
    ) external view returns (bytes32) {
        bytes32[] memory tokenAmountHashes = new bytes32[](totalAmounts.length);
        for (uint256 i; i < totalAmounts.length; ++i) {
            tokenAmountHashes[i] = keccak256(abi.encode(TOKEN_AMOUNT_TYPEHASH, totalAmounts[i]));
        }
        return hashTypedDataV4CrossChain(
            keccak256(
                abi.encode(
                    CUMULATIVE_DISTRIBUTION_PAYLOAD_TYPEHASH,
                    network,
                    cumulativeDistribution,
                    keccak256(abi.encodePacked(tokenAmountHashes))
                )
            )
        );
    }
}

/// @title CumulativeMerkleRewardsHandler
/// @notice Contract for driving invariant tests around CumulativeMerkleRewards behaviour.
contract CumulativeMerkleRewardsHandler is RewardsV2TestBase {
    struct NetworkConfig {
        address rewarder;
        uint256 rewarderKey;
        uint48 lastTimestamp;
        bool exists;
    }

    struct RewardeeConfig {
        address account;
        address network;
        uint256 rewardeeType;
    }

    struct LeafInfo {
        bytes32 merkleRoot;
        ICumulativeMerkleRewards.CumulativeDistributionLeaf leaf;
        bytes32[] proof;
        bool exists;
    }

    uint256 internal constant OWNER_PRIVATE_KEY = 1;
    uint256 internal constant NETWORK_KEY_START = 100;
    uint256 internal constant REWARDER_KEY_START = 200;
    uint256 internal constant REWARDEE_KEY_START = 300;
    uint256 internal constant MAX_NETWORKS = 5;
    uint256 internal constant INITIAL_REWARDEES_PER_NETWORK = 10;
    uint256 internal constant MAX_DEPOSIT = 1_000_000e18;
    uint256 internal constant MAX_DISTRIBUTION_INCREMENT = 100_000e18;
    uint256 internal constant MIN_DISTRIBUTION_INCREMENT = 1e16;
    uint256 internal constant PROTOCOL_FEE = 50_000;

    string internal constant REWARDS_FEE_ID = "rewards";

    TestableCumulativeMerkleRewards public cumulativeMerkleRewards;
    MerkleTreeUtils public merkleUtils;

    address public owner;

    address[] internal networks;
    mapping(address => NetworkConfig) internal networkConfig;
    mapping(address => RewardeeConfig[]) internal rewardeesByNetwork;
    mapping(address => mapping(address => mapping(uint256 => LeafInfo))) internal leafInfos;
    mapping(address => mapping(address => mapping(uint256 => uint256))) internal outstandingPerRewardee;
    mapping(address => mapping(address => uint256)) internal outstandingByNetworkToken;
    mapping(address => uint256) internal totalOutstandingTokenValue;

    constructor() {
        _initialize();
    }

    function depositCumulativeRewards(uint256 seed) public {
        address network = _selectOrCreateNetwork(seed);
        uint256 amount = _bound(seed, 1e18, MAX_DEPOSIT);
        _ensureBalance(address(this), amount);
        rewardsToken.approve(address(cumulativeMerkleRewards), type(uint256).max);
        cumulativeMerkleRewards.depositCumulativeMerkleRewards(network, address(rewardsToken), amount);
    }

    function withdrawCumulativeRewards(uint256 seed) public {
        if (networks.length == 0) {
            return;
        }

        address network = networks[seed % networks.length];
        NetworkConfig storage config = networkConfig[network];
        uint256 balance = cumulativeMerkleRewards.balance(network, address(rewardsToken));

        uint256 amount = _bound(seed, 1, balance);
        vm.prank(config.rewarder);
        cumulativeMerkleRewards.withdrawCumulativeMerkleRewards(config.rewarder, network, address(rewardsToken), amount);
    }

    function distributeRewards(uint256 seed) public {
        address network = _selectOrCreateNetwork(seed);
        RewardeeConfig[] storage networkRewardees = rewardeesByNetwork[network];
        if (networkRewardees.length == 0) {
            return;
        }

        uint256 leavesCount = networkRewardees.length;
        ICumulativeMerkleRewards.CumulativeDistributionLeaf[] memory leaves =
            new ICumulativeMerkleRewards.CumulativeDistributionLeaf[](leavesCount);
        address[] memory rewardeeAccounts = new address[](leavesCount);

        uint256 distributionAmount;

        for (uint256 i; i < leavesCount; ++i) {
            RewardeeConfig storage rewardeeCfg = networkRewardees[i];
            rewardeeAccounts[i] = rewardeeCfg.account;
            LeafInfo storage info = leafInfos[network][rewardeeCfg.account][rewardeeCfg.rewardeeType];
            uint256 increment = _bound(seed + i, MIN_DISTRIBUTION_INCREMENT, MAX_DISTRIBUTION_INCREMENT);
            uint256 newAmount = info.leaf.amount + increment;

            leaves[i] = ICumulativeMerkleRewards.CumulativeDistributionLeaf({
                chainId: uint64(block.chainid),
                token: address(rewardsToken),
                rewardeeType: rewardeeCfg.rewardeeType,
                amount: newAmount,
                rewardeeDataHash: keccak256(abi.encodePacked(rewardeeCfg.account, seed, i))
            });

            distributionAmount += increment;
        }

        (bytes32 merkleRoot, bytes32[][] memory proofs) = _buildMerkleTree(rewardeeAccounts, leaves);

        uint256 lastTotal = cumulativeMerkleRewards.lastTotalAmount(network, address(rewardsToken));
        uint256 newTotal = lastTotal + distributionAmount;

        uint256 feeRate = cumulativeMerkleRewards.protocolFee(uint64(IRewards.RewardsType.CUMULATIVE_MERKLE), network);
        uint256 fees = (distributionAmount * feeRate) / cumulativeMerkleRewards.MAX_FEE();
        uint256 available = cumulativeMerkleRewards.balance(network, address(rewardsToken));

        if (available < distributionAmount + fees) {
            uint256 shortfall = distributionAmount + fees - available;
            _ensureBalance(address(this), shortfall);
            rewardsToken.approve(address(cumulativeMerkleRewards), type(uint256).max);
            cumulativeMerkleRewards.depositCumulativeMerkleRewards(network, address(rewardsToken), shortfall);
        }

        uint256 timeJump = _bound(seed, 1 minutes, 1 days);
        vm.warp(block.timestamp + timeJump);

        ICumulativeMerkleRewards.CumulativeDistribution memory distribution =
            ICumulativeMerkleRewards.CumulativeDistribution({
                timestamp: uint48(block.timestamp), merkleRoot: merkleRoot
            });

        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts = new ICumulativeMerkleRewards.TokenAmount[](1);
        totalAmounts[0] = ICumulativeMerkleRewards.TokenAmount({
            chainId: uint64(block.chainid), token: address(rewardsToken), amount: newTotal
        });

        bytes32 digest = cumulativeMerkleRewards.hashCumulativeDistributionPayload(network, distribution, totalAmounts);
        bytes memory ownerSignature = _signTyped(OWNER_PRIVATE_KEY, digest);
        bytes memory rewarderSignature = _signTyped(networkConfig[network].rewarderKey, digest);

        vm.prank(owner);
        cumulativeMerkleRewards.distributeCumulativeMerkleRewards(
            network, distribution, totalAmounts, ownerSignature, rewarderSignature
        );

        networkConfig[network].lastTimestamp = distribution.timestamp;

        for (uint256 i; i < leavesCount; ++i) {
            RewardeeConfig storage rewardeeCfg = networkRewardees[i];
            LeafInfo storage info = leafInfos[network][rewardeeCfg.account][rewardeeCfg.rewardeeType];
            info.merkleRoot = merkleRoot;
            info.leaf = leaves[i];
            delete info.proof;
            for (uint256 j; j < proofs[i].length; ++j) {
                info.proof.push(proofs[i][j]);
            }
            info.exists = true;

            uint256 claimedBefore = cumulativeMerkleRewards.claimed(
                network, address(rewardsToken), rewardeeCfg.account, rewardeeCfg.rewardeeType
            );
            uint256 newOutstanding = leaves[i].amount - claimedBefore;
            uint256 previousOutstanding = outstandingPerRewardee[network][rewardeeCfg.account][rewardeeCfg.rewardeeType];

            if (newOutstanding >= previousOutstanding) {
                uint256 delta = newOutstanding - previousOutstanding;
                outstandingByNetworkToken[network][leaves[i].token] += delta;
                totalOutstandingTokenValue[leaves[i].token] += delta;
            } else {
                uint256 delta = previousOutstanding - newOutstanding;
                outstandingByNetworkToken[network][leaves[i].token] -= delta;
                totalOutstandingTokenValue[leaves[i].token] -= delta;
            }

            outstandingPerRewardee[network][rewardeeCfg.account][rewardeeCfg.rewardeeType] = newOutstanding;
        }
    }

    function claim(uint256 seed) public {
        (RewardeeConfig memory rewardeeCfg, LeafInfo storage info) = _selectClaimableRewardee(seed);

        uint256 claimedBefore = cumulativeMerkleRewards.claimed(
            rewardeeCfg.network, address(rewardsToken), rewardeeCfg.account, rewardeeCfg.rewardeeType
        );

        bytes32[] memory proof = _copyProof(info.proof);

        vm.prank(rewardeeCfg.account);
        cumulativeMerkleRewards.claimCumulativeMerkleRewards(
            rewardeeCfg.account, rewardeeCfg.network, info.leaf, proof, info.merkleRoot
        );

        uint256 claimAmount = info.leaf.amount - claimedBefore;
        outstandingPerRewardee[rewardeeCfg.network][rewardeeCfg.account][rewardeeCfg.rewardeeType] -= claimAmount;
        outstandingByNetworkToken[rewardeeCfg.network][info.leaf.token] -= claimAmount;
        totalOutstandingTokenValue[info.leaf.token] -= claimAmount;
    }

    function claimViaRouter(uint256 seed) public {
        (RewardeeConfig memory rewardeeCfg, LeafInfo storage info) = _selectClaimableRewardee(seed);

        uint256 claimedBefore = cumulativeMerkleRewards.claimed(
            rewardeeCfg.network, address(rewardsToken), rewardeeCfg.account, rewardeeCfg.rewardeeType
        );

        bytes memory data = abi.encode(rewardeeCfg.network, info.merkleRoot, info.leaf, _copyProof(info.proof));

        vm.prank(rewardeeCfg.account);
        cumulativeMerkleRewards.claimRewards(rewardeeCfg.account, info.leaf.token, data);

        uint256 claimAmount = info.leaf.amount - claimedBefore;
        outstandingPerRewardee[rewardeeCfg.network][rewardeeCfg.account][rewardeeCfg.rewardeeType] -= claimAmount;
        outstandingByNetworkToken[rewardeeCfg.network][info.leaf.token] -= claimAmount;
        totalOutstandingTokenValue[info.leaf.token] -= claimAmount;
    }

    function claimProtocolFees(uint256) public {
        vm.prank(owner);
        cumulativeMerkleRewards.claimProtocolFees(owner, address(rewardsToken));
    }

    function networksLength() external view returns (uint256) {
        return networks.length;
    }

    function networkAt(uint256 index) external view returns (address) {
        return networks[index];
    }

    function totalOutstandingByToken(address token) external view returns (uint256) {
        return totalOutstandingTokenValue[token];
    }

    function _initialize() internal {
        owner = vm.addr(OWNER_PRIVATE_KEY);
        _deployRewardsInfra(owner);
        merkleUtils = new MerkleTreeUtils();

        cumulativeMerkleRewards = new TestableCumulativeMerkleRewards(address(feeRegistry));
        cumulativeMerkleRewards = TestableCumulativeMerkleRewards(
            address(
                new TransparentUpgradeableProxy(
                    address(cumulativeMerkleRewards),
                    address(this),
                    abi.encodeCall(TestableCumulativeMerkleRewards.initialize, (owner))
                )
            )
        );
        vm.prank(owner);
        cumulativeMerkleRewards.setProtocol(owner);

        vm.prank(owner);
        feeRegistry.setProtocolFee(
            keccak256(abi.encode(REWARDS_FEE_ID, uint64(IRewards.RewardsType.CUMULATIVE_MERKLE))), true, PROTOCOL_FEE
        );

        rewardsToken.approve(address(cumulativeMerkleRewards), type(uint256).max);

        _createNetwork();
    }

    function _createNetwork() internal returns (address network) {
        uint256 idx = networks.length;
        uint256 networkKey = NETWORK_KEY_START + idx;
        uint256 rewarderKey = REWARDER_KEY_START + idx;

        network = vm.addr(networkKey);
        address rewarder = vm.addr(rewarderKey);

        networks.push(network);
        networkConfig[network] =
            NetworkConfig({rewarder: rewarder, rewarderKey: rewarderKey, lastTimestamp: 0, exists: true});

        vm.prank(network);
        cumulativeMerkleRewards.setRewarder(rewarder);

        for (uint256 i; i < INITIAL_REWARDEES_PER_NETWORK; ++i) {
            uint256 rewardeeKey = REWARDEE_KEY_START + idx * INITIAL_REWARDEES_PER_NETWORK + i;
            address rewardee = vm.addr(rewardeeKey);
            RewardeeConfig memory cfg = RewardeeConfig({account: rewardee, network: network, rewardeeType: i});
            rewardeesByNetwork[network].push(cfg);
        }

        uint256 initialDeposit = 200_000e18;
        _ensureBalance(address(this), initialDeposit);
        rewardsToken.approve(address(cumulativeMerkleRewards), type(uint256).max);
        cumulativeMerkleRewards.depositCumulativeMerkleRewards(network, address(rewardsToken), initialDeposit);
    }

    function _selectOrCreateNetwork(uint256 seed) internal returns (address) {
        if (networks.length == 0) {
            return _createNetwork();
        }

        if (networks.length < MAX_NETWORKS && seed % 10 == 0) {
            return _createNetwork();
        }

        return networks[seed % networks.length];
    }

    function _ensureBalance(address account, uint256 amount) internal {
        uint256 balance = rewardsToken.balanceOf(account);
        if (balance < amount) {
            deal(address(rewardsToken), account, amount, true);
        }
    }

    function _buildMerkleTree(
        address[] memory rewardeeAccounts,
        ICumulativeMerkleRewards.CumulativeDistributionLeaf[] memory leaves
    ) internal view returns (bytes32 root, bytes32[][] memory proofs) {
        bytes32[] memory leafHashes = new bytes32[](leaves.length);
        for (uint256 i; i < leaves.length; ++i) {
            leafHashes[i] = keccak256(abi.encode(rewardeeAccounts[i], leaves[i]));
        }
        (root, proofs) = merkleUtils.createMerkleTree(leafHashes);
    }

    function _signTyped(uint256 privateKey, bytes32 digest) internal returns (bytes memory signature) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        signature = abi.encodePacked(r, s, v);
    }

    function _selectClaimableRewardee(uint256 seed)
        internal
        view
        returns (RewardeeConfig memory rewardeeCfg, LeafInfo storage info)
    {
        address network = networks[seed % networks.length];
        uint256 len = rewardeesByNetwork[network].length;
        RewardeeConfig storage rewardeeCfg = rewardeesByNetwork[network][seed % len];
        LeafInfo storage info = leafInfos[network][rewardeeCfg.account][rewardeeCfg.rewardeeType];
        return (rewardeeCfg, info);
    }

    function _copyProof(bytes32[] storage proof) internal view returns (bytes32[] memory copied) {
        copied = new bytes32[](proof.length);
        for (uint256 i; i < proof.length; ++i) {
            copied[i] = proof[i];
        }
    }
}
