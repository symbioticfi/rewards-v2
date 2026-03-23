// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {
    ICumulativeMerkleRewards as ISymbioticCumulativeMerkleRewards
} from "../../src/interfaces/ICumulativeMerkleRewards.sol";
import {ICuratorFees as ISymbioticCuratorFees} from "../../src/interfaces/ICuratorFees.sol";
import {ICuratorRegistry as ISymbioticCuratorRegistry} from "../../src/interfaces/ICuratorRegistry.sol";
import {IDonationRewards as ISymbioticDonationRewards} from "../../src/interfaces/IDonationRewards.sol";
import {IFeeRegistry as ISymbioticFeeRegistry} from "../../src/interfaces/IFeeRegistry.sol";
import {IProtocolFees as ISymbioticProtocolFees} from "../../src/interfaces/IProtocolFees.sol";
import {IRewards as ISymbioticRewards} from "../../src/interfaces/IRewards.sol";
import {IRewardsBase as ISymbioticRewardsBase} from "../../src/interfaces/IRewardsBase.sol";
import {IRewardsErrors as ISymbioticRewardsErrors} from "../../src/interfaces/IRewardsErrors.sol";
import {IUniversalDelegator as ISymbioticUniversalDelegator} from "../../src/interfaces/IUniversalDelegator.sol";
import {IVaultSnapshotRewards as ISymbioticVaultSnapshotRewards} from "../../src/interfaces/IVaultSnapshotRewards.sol";
import {IVaultV2 as ISymbioticVaultV2} from "../../src/interfaces/IVaultV2.sol";
import {IOzEIP712 as ISymbioticOzEIP712} from "../../src/interfaces/base/IOzEIP712.sol";

interface SymbioticRewardsImports {}
