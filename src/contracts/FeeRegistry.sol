// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import {Checkpoints} from "./libraries/Checkpoints.sol";

import {ICuratorRegistry} from "../interfaces/ICuratorRegistry.sol";
import {IFeeRegistry} from "../interfaces/IFeeRegistry.sol";

import {MulticallUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/MulticallUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {StaticDelegateCallable} from "@symbioticfi/core/src/contracts/common/StaticDelegateCallable.sol";

/// @title FeeRegistry
/// @notice Contract for storing curators', operators', and protocol's fee configurations with historical tracking.
contract FeeRegistry is OwnableUpgradeable, MulticallUpgradeable, StaticDelegateCallable, IFeeRegistry {
    using Checkpoints for Checkpoints.Trace208;

    /* CONSTANTS */

    /// @inheritdoc IFeeRegistry
    uint256 public constant MAX_FEE = 1_000_000;

    /// @inheritdoc IFeeRegistry
    uint256 public constant MAX_PARTICIPANT_FEE = 500_000;

    /* IMMUTABLES */

    /// @inheritdoc IFeeRegistry
    address public immutable CURATOR_REGISTRY;

    /* STORAGE */

    /// @custom:storage-location erc7201:symbiotic.rewards.FeeRegistry
    struct FeeRegistryStorage {
        mapping(address vault => Checkpoints.Trace208 value) _operatorsFee;
        mapping(address vault => mapping(address network => Checkpoints.Trace208 value)) _operatorsNetworkFee;
        mapping(address vault => Checkpoints.Trace208 value) _curatorFee;
        mapping(address vault => mapping(address network => Checkpoints.Trace208 value)) _curatorNetworkFee;
        mapping(bytes32 id => uint208 fee) _protocolFee;
    }

    // keccak256(abi.encode(uint256(keccak256("symbiotic.rewards.FeeRegistry")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant FEE_REGISTRY_STORAGE_POSITION =
        0x93d27e35e5186e4ea21573d1a25649cf5417be8a9fc60183b644027fed662100;

    function _feeRegistryStorage() private pure returns (FeeRegistryStorage storage $) {
        assembly {
            $.slot := FEE_REGISTRY_STORAGE_POSITION
        }
    }

    /* MODIFIERS */

    modifier onlyCurator(address vault) {
        if (ICuratorRegistry(CURATOR_REGISTRY).getCurator(vault) != msg.sender) {
            revert NotCurator();
        }
        _;
    }

    /* CONSTRUCTOR */

    constructor(address curatorRegistry_) {
        CURATOR_REGISTRY = curatorRegistry_;

        _disableInitializers();
    }

    /* PUBLIC FUNCTIONS */

    function initialize(address owner) public initializer {
        __Ownable_init(owner);
    }

    /// @inheritdoc IFeeRegistry
    function getOperatorsFeeAt(address vault, address network, uint48 timestamp, bytes memory hints)
        public
        view
        returns (uint256)
    {
        OperatorsFeeAtHints memory operatorsFeeAtHints;
        if (hints.length > 0) {
            operatorsFeeAtHints = abi.decode(hints, (OperatorsFeeAtHints));
        }

        (bool isEnabled, uint256 networkFee) =
            getOperatorsNetworkFeeAt(vault, network, timestamp, operatorsFeeAtHints.operatorsNetworkFeeHint);
        if (isEnabled) {
            return networkFee;
        }

        return getOperatorsDefaultFeeAt(vault, timestamp, operatorsFeeAtHints.operatorsDefaultFeeHint);
    }

    /// @inheritdoc IFeeRegistry
    function getOperatorsFee(address vault, address network) public view returns (uint256) {
        (bool isEnabled, uint256 networkFee) = getOperatorsNetworkFee(vault, network);
        if (isEnabled) {
            return networkFee;
        }

        return getOperatorsDefaultFee(vault);
    }

    /// @inheritdoc IFeeRegistry
    function getOperatorsNetworkFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
        public
        view
        returns (bool isEnabled, uint256 fee)
    {
        return _deserializeFeeData(
            _feeRegistryStorage()._operatorsNetworkFee[vault][network].upperLookupRecent(timestamp, hint)
        );
    }

    /// @inheritdoc IFeeRegistry
    function getOperatorsNetworkFee(address vault, address network) public view returns (bool isEnabled, uint256 fee) {
        return _deserializeFeeData(_feeRegistryStorage()._operatorsNetworkFee[vault][network].latest());
    }

    /// @inheritdoc IFeeRegistry
    function getOperatorsDefaultFeeAt(address vault, uint48 timestamp, bytes memory hint)
        public
        view
        returns (uint256)
    {
        return _feeRegistryStorage()._operatorsFee[vault].upperLookupRecent(timestamp, hint);
    }

    /// @inheritdoc IFeeRegistry
    function getOperatorsDefaultFee(address vault) public view returns (uint256) {
        return _feeRegistryStorage()._operatorsFee[vault].latest();
    }

    /// @inheritdoc IFeeRegistry
    function getCuratorFeeAt(address vault, address network, uint48 timestamp, bytes memory hints)
        public
        view
        returns (uint256)
    {
        CuratorFeeAtHints memory curatorFeeAtHints;
        if (hints.length > 0) {
            curatorFeeAtHints = abi.decode(hints, (CuratorFeeAtHints));
        }

        (bool isEnabled, uint256 networkFee) =
            getCuratorNetworkFeeAt(vault, network, timestamp, curatorFeeAtHints.curatorNetworkFeeHint);
        if (isEnabled) {
            return networkFee;
        }

        return getCuratorDefaultFeeAt(vault, timestamp, curatorFeeAtHints.curatorDefaultFeeHint);
    }

    /// @inheritdoc IFeeRegistry
    function getCuratorFee(address vault, address network) public view returns (uint256) {
        (bool isEnabled, uint256 networkFee) = getCuratorNetworkFee(vault, network);
        if (isEnabled) {
            return networkFee;
        }

        return getCuratorDefaultFee(vault);
    }

    /// @inheritdoc IFeeRegistry
    function getCuratorNetworkFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
        public
        view
        returns (bool isEnabled, uint256 fee)
    {
        return _deserializeFeeData(
            _feeRegistryStorage()._curatorNetworkFee[vault][network].upperLookupRecent(timestamp, hint)
        );
    }

    /// @inheritdoc IFeeRegistry
    function getCuratorNetworkFee(address vault, address network) public view returns (bool isEnabled, uint256 fee) {
        return _deserializeFeeData(_feeRegistryStorage()._curatorNetworkFee[vault][network].latest());
    }

    /// @inheritdoc IFeeRegistry
    function getCuratorDefaultFeeAt(address vault, uint48 timestamp, bytes memory hint) public view returns (uint256) {
        return _feeRegistryStorage()._curatorFee[vault].upperLookupRecent(timestamp, hint);
    }

    /// @inheritdoc IFeeRegistry
    function getCuratorDefaultFee(address vault) public view returns (uint256) {
        return _feeRegistryStorage()._curatorFee[vault].latest();
    }

    /// @inheritdoc IFeeRegistry
    function getProtocolFee(bytes32 id) public view returns (bool isEnabled, uint256 fee) {
        return _deserializeFeeData(_feeRegistryStorage()._protocolFee[id]);
    }

    /// @inheritdoc IFeeRegistry
    function setOperatorsFee(address vault, uint256 fee) public onlyCurator(vault) {
        if (fee > MAX_PARTICIPANT_FEE) {
            revert FeeTooHigh();
        }

        _feeRegistryStorage()._operatorsFee[vault].push(uint48(block.timestamp), uint208(fee));
        emit SetOperatorsFee(vault, fee);
    }

    /// @inheritdoc IFeeRegistry
    function setOperatorsNetworkFee(address vault, address network, bool enable, uint256 fee)
        public
        onlyCurator(vault)
    {
        if (fee > MAX_PARTICIPANT_FEE) {
            revert FeeTooHigh();
        }

        _feeRegistryStorage()
        ._operatorsNetworkFee[vault][network].push(uint48(block.timestamp), _serializeFeeData(enable, fee));
        emit SetOperatorsNetworkFee(vault, network, enable, fee);
    }

    /// @inheritdoc IFeeRegistry
    function setCuratorFee(address vault, uint256 fee) public onlyCurator(vault) {
        if (fee > MAX_PARTICIPANT_FEE) {
            revert FeeTooHigh();
        }

        _feeRegistryStorage()._curatorFee[vault].push(uint48(block.timestamp), uint208(fee));
        emit SetCuratorFee(vault, fee);
    }

    /// @inheritdoc IFeeRegistry
    function setCuratorNetworkFee(address vault, address network, bool enable, uint256 fee) public onlyCurator(vault) {
        if (fee > MAX_PARTICIPANT_FEE) {
            revert FeeTooHigh();
        }

        _feeRegistryStorage()
        ._curatorNetworkFee[vault][network].push(uint48(block.timestamp), _serializeFeeData(enable, fee));
        emit SetCuratorNetworkFee(vault, network, enable, fee);
    }

    /// @inheritdoc IFeeRegistry
    function setProtocolFee(bytes32 id, bool enable, uint256 fee) public onlyOwner {
        if (fee >= MAX_FEE) {
            revert FeeTooHigh();
        }

        _feeRegistryStorage()._protocolFee[id] = _serializeFeeData(enable, fee);
        emit SetProtocolFee(id, enable, fee);
    }

    /* INTERNAL FUNCTIONS */

    /// @dev Serializes fee data (enable + fee).
    function _serializeFeeData(bool isEnabled, uint256 fee) internal pure returns (uint208) {
        return uint208((fee << 1) | (isEnabled ? 1 : 0));
    }

    /// @dev Deserializes fee data (enable + fee).
    function _deserializeFeeData(uint208 data) internal pure returns (bool, uint256) {
        return (data & 1 > 0, data >> 1);
    }
}
