# Rewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/2d5845a497cbd7fb2b3fbd104f0b6d6c69745cbb/src/contracts/Rewards.sol)

**Inherits:**
[VaultSnapshotRewards](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/contracts/VaultSnapshotRewards.sol/abstract.VaultSnapshotRewards.md), [CumulativeMerkleRewards](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/contracts/CumulativeMerkleRewards.sol/abstract.CumulativeMerkleRewards.md), MulticallUpgradeable, [IRewards](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/interfaces/IRewards.sol/interface.IRewards.md)

Contract for orchestrating cumulative and snapshot-based reward flows.


## Functions
### constructor


```solidity
constructor(
    address vaultFactory,
    address networkRegistry,
    address networkMiddlewareService,
    address curatorRegistry,
    address feeRegistry
)
    VaultSnapshotRewards(vaultFactory, networkRegistry, networkMiddlewareService, curatorRegistry)
    ProtocolFees(feeRegistry);
```

### initialize


```solidity
function initialize(address owner) public initializer;
```

### claimRewards

Claims rewards via a unified entrypoint.

The function routes to the appropriate reward type based on the first 8 bytes (uint64).
of the payload that identify the rewards type. Remaining bytes are reward-specific data.


```solidity
function claimRewards(address recipient, address token, bytes calldata data)
    public
    override(VaultSnapshotRewards, CumulativeMerkleRewards, IRewards);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`token`|`address`|The token address.|
|`data`|`bytes`|The encoded claim data containing reward type and specific data.|


