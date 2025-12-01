# Rewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/4091a663d0facca5e5584288b3402ae4532908bf/src/contracts/Rewards.sol)

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

### distributionToTotalAmount

Returns a total amount that must be provided (including protocol fees) from the net distribution amount.


```solidity
function distributionToTotalAmount(uint64 rewardsType, address network, uint256 distributionAmount)
    public
    view
    override(VaultSnapshotRewards, CumulativeMerkleRewards)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rewardsType`|`uint64`|Identifier of the rewards flow.|
|`network`|`address`|The network for which the protocol fee will be applied.|
|`distributionAmount`|`uint256`|Amount intended to reach recipients, excluding protocol fees.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Gross amount required to cover the distribution plus protocol fees.|


### totalToDistributionAmount

Returns a net distribution amount from the total provided amount (inclusive of protocol fees).


```solidity
function totalToDistributionAmount(uint64 rewardsType, address network, uint256 totalDistributionAmount)
    public
    view
    override(VaultSnapshotRewards, CumulativeMerkleRewards)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rewardsType`|`uint64`|Identifier of the rewards flow.|
|`network`|`address`|The network for which the protocol fee will be applied.|
|`totalDistributionAmount`|`uint256`|Gross amount supplied for the distribution, including protocol fees.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Net amount available for recipients after protocol fees are removed.|


### claimRewards

Claims rewards via a unified entrypoint.

The function routes to the appropriate reward type based on the first 8 bytes (uint64)
of the payload that identify the rewards type. Remaining bytes are reward-specific data.


```solidity
function claimRewards(address recipient, address token, bytes calldata data)
    public
    override(VaultSnapshotRewards, CumulativeMerkleRewards, IRewardsBase);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`token`|`address`|The token address.|
|`data`|`bytes`|The encoded claim data containing reward type and specific data.|


