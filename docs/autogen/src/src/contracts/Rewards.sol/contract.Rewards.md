# Rewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/ea533e8a8c25f8a67c26f45a7da52beeee4efd9e/src/contracts/Rewards.sol)

**Inherits:**
[VaultSnapshotRewards](/src/contracts/VaultSnapshotRewards.sol/abstract.VaultSnapshotRewards.md), [CumulativeMerkleRewards](/src/contracts/CumulativeMerkleRewards.sol/abstract.CumulativeMerkleRewards.md), MulticallUpgradeable, [IRewards](/src/interfaces/IRewards.sol/interface.IRewards.md)

**Title:**
Rewards

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


