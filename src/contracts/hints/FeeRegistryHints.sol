// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Hints} from "./Hints.sol";

import {FeeRegistry} from "../FeeRegistry.sol";
import {Checkpoints} from "../libraries/Checkpoints.sol";

import {IFeeRegistry} from "../../interfaces/IFeeRegistry.sol";

/// @title FeeRegistryHints
/// @notice Contract for FeeRegistry checkpoint hint construction.
contract FeeRegistryHints is Hints, FeeRegistry {
    using Checkpoints for Checkpoints.Trace208;

    /* CONSTRUCTOR */

    constructor() FeeRegistry(address(0)) {}

    /* HINTS: OPERATORS */

    function operatorsDefaultFeeHintInternal(address vault, uint48 timestamp)
        external
        view
        internalFunction
        returns (bool exists, uint32 hint)
    {
        (exists,,, hint) = _feeRegistryStorage()._operatorsFee[vault].upperLookupRecentCheckpoint(timestamp);
    }

    function operatorsDefaultFeeHint(address feeRegistry, address vault, uint48 timestamp)
        public
        view
        returns (bytes memory hint)
    {
        (bool exists, uint32 hint_) = abi.decode(
            _selfStaticDelegateCall(
                feeRegistry, abi.encodeCall(FeeRegistryHints.operatorsDefaultFeeHintInternal, (vault, timestamp))
            ),
            (bool, uint32)
        );

        if (exists) {
            hint = abi.encode(hint_);
        }
    }

    function operatorsNetworkFeeHintInternal(address vault, address network, uint48 timestamp)
        external
        view
        internalFunction
        returns (bool exists, uint32 hint)
    {
        (exists,,, hint) = _feeRegistryStorage()._operatorsNetworkFee[vault][network].upperLookupRecentCheckpoint(
            timestamp
        );
    }

    function operatorsNetworkFeeHint(address feeRegistry, address vault, address network, uint48 timestamp)
        public
        view
        returns (bytes memory hint)
    {
        (bool exists, uint32 hint_) = abi.decode(
            _selfStaticDelegateCall(
                feeRegistry,
                abi.encodeCall(FeeRegistryHints.operatorsNetworkFeeHintInternal, (vault, network, timestamp))
            ),
            (bool, uint32)
        );

        if (exists) {
            hint = abi.encode(hint_);
        }
    }

    function operatorsFeeAtHints(address feeRegistry, address vault, address network, uint48 timestamp)
        external
        view
        returns (bytes memory hints)
    {
        bytes memory operatorsNetworkFeeHint_ = operatorsNetworkFeeHint(feeRegistry, vault, network, timestamp);
        bytes memory operatorsDefaultFeeHint_ = operatorsDefaultFeeHint(feeRegistry, vault, timestamp);

        if (operatorsNetworkFeeHint_.length > 0 || operatorsDefaultFeeHint_.length > 0) {
            hints = abi.encode(
                IFeeRegistry.OperatorsFeeAtHints({
                    operatorsNetworkFeeHint: operatorsNetworkFeeHint_,
                    operatorsDefaultFeeHint: operatorsDefaultFeeHint_
                })
            );
        }
    }

    /* HINTS: CURATOR */

    function curatorDefaultFeeHintInternal(address vault, uint48 timestamp)
        external
        view
        internalFunction
        returns (bool exists, uint32 hint)
    {
        (exists,,, hint) = _feeRegistryStorage()._curatorFee[vault].upperLookupRecentCheckpoint(timestamp);
    }

    function curatorDefaultFeeHint(address feeRegistry, address vault, uint48 timestamp)
        public
        view
        returns (bytes memory hint)
    {
        (bool exists, uint32 hint_) = abi.decode(
            _selfStaticDelegateCall(
                feeRegistry, abi.encodeCall(FeeRegistryHints.curatorDefaultFeeHintInternal, (vault, timestamp))
            ),
            (bool, uint32)
        );

        if (exists) {
            hint = abi.encode(hint_);
        }
    }

    function curatorNetworkFeeHintInternal(address vault, address network, uint48 timestamp)
        external
        view
        internalFunction
        returns (bool exists, uint32 hint)
    {
        (exists,,, hint) = _feeRegistryStorage()._curatorNetworkFee[vault][network].upperLookupRecentCheckpoint(
            timestamp
        );
    }

    function curatorNetworkFeeHint(address feeRegistry, address vault, address network, uint48 timestamp)
        public
        view
        returns (bytes memory hint)
    {
        (bool exists, uint32 hint_) = abi.decode(
            _selfStaticDelegateCall(
                feeRegistry, abi.encodeCall(FeeRegistryHints.curatorNetworkFeeHintInternal, (vault, network, timestamp))
            ),
            (bool, uint32)
        );

        if (exists) {
            hint = abi.encode(hint_);
        }
    }

    function curatorFeeAtHints(address feeRegistry, address vault, address network, uint48 timestamp)
        external
        view
        returns (bytes memory hints)
    {
        bytes memory curatorNetworkFeeHint_ = curatorNetworkFeeHint(feeRegistry, vault, network, timestamp);
        bytes memory curatorDefaultFeeHint_ = curatorDefaultFeeHint(feeRegistry, vault, timestamp);

        if (curatorNetworkFeeHint_.length > 0 || curatorDefaultFeeHint_.length > 0) {
            hints = abi.encode(
                IFeeRegistry.CuratorFeeAtHints({
                    curatorNetworkFeeHint: curatorNetworkFeeHint_,
                    curatorDefaultFeeHint: curatorDefaultFeeHint_
                })
            );
        }
    }
}
