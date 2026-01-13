// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {OzEIP712} from "../../../src/contracts/base/OzEIP712.sol";
import {ICumulativeMerkleRewards} from "../../../src/interfaces/ICumulativeMerkleRewards.sol";

import {ScriptBase} from "@symbioticfi/core/script/utils/ScriptBase.s.sol";
import {Logs} from "@symbioticfi/core/script/utils/Logs.sol";

contract SignDistributionBaseScript is ScriptBase, OzEIP712 {
    string private constant EIP712_NAME = "CumulativeMerkleRewards";
    string private constant EIP712_VERSION = "1";

    bytes32 internal constant TOKEN_AMOUNT_TYPEHASH =
        keccak256("TokenAmount(uint64 chainId,address token,uint256 amount)");

    bytes32 internal constant CUMULATIVE_DISTRIBUTION_PAYLOAD_TYPEHASH = keccak256(
        "CumulativeDistributionPayload(address network,uint48 timestamp,bytes32 merkleRoot,TokenAmount[] totalAmounts)TokenAmount(uint64 chainId,address token,uint256 amount)"
    );

    function runBase(
        uint256 privateKey,
        address network,
        ICumulativeMerkleRewards.CumulativeDistribution memory cumulativeDistribution,
        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts
    ) public returns (bytes memory signature) {
        bytes32 hash = hashCumulativeDistributionPayload(network, cumulativeDistribution, totalAmounts);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, hash);
        signature = abi.encodePacked(r, s, v);
        Logs.log(string.concat("Signature:", "\n    signature:", vm.toString(signature)));
    }

    function hashCumulativeDistributionPayload(
        address network,
        ICumulativeMerkleRewards.CumulativeDistribution memory cumulativeDistribution,
        ICumulativeMerkleRewards.TokenAmount[] memory totalAmounts
    ) public view returns (bytes32) {
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

    function _EIP712Name() internal pure override returns (string memory) {
        return EIP712_NAME;
    }

    function _EIP712Version() internal pure override returns (string memory) {
        return EIP712_VERSION;
    }
}
