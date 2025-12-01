# CuratorRegistry
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/1a74025d9c2bbe71abf013585bb862f9492e7d28/src/contracts/CuratorRegistry.sol)

**Inherits:**
StaticDelegateCallable, MulticallUpgradeable, [ICuratorRegistry](/src/interfaces/ICuratorRegistry.sol/interface.ICuratorRegistry.md)

**Title:**
CuratorRegistry

Contract for managing curator assignments for vaults with historical tracking.


## State Variables
### CURATOR_REGISTRY_STORAGE_POSITION

```solidity
bytes32 private constant CURATOR_REGISTRY_STORAGE_POSITION =
    0x50b0c8278802d3abbb2e677eb0a65452a0e12cbdc7ef8b06b4325691f656bc00
```


## Functions
### _curatorRegistryStorage


```solidity
function _curatorRegistryStorage() private pure returns (CuratorRegistryStorage storage $);
```

### constructor


```solidity
constructor() ;
```

### initialize


```solidity
function initialize() public initializer;
```

### getCuratorAt

Returns the curator for a vault at a specific timestamp.


```solidity
function getCuratorAt(address vault, uint48 timestamp, bytes memory hint) public view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`timestamp`|`uint48`|The timestamp to query.|
|`hint`|`bytes`|Optional hint for optimization.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The curator address at the specified timestamp.|


### getCurator

Returns the current curator for a vault.


```solidity
function getCurator(address vault) public view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The current curator address.|


### setCurator

Sets the curator for a vault.

Access control:
- If a curator is already set, only the current curator can change it.
- If the vault has an owner, only the owner can set the curator.


```solidity
function setCurator(address vault, address curator) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`curator`|`address`|The curator address to set.|


## Structs
### CuratorRegistryStorage
**Note:**
storage-location: erc7201:symbiotic.rewards.CuratorRegistry


```solidity
struct CuratorRegistryStorage {
    mapping(address vault => Checkpoints.Trace208) _curators;
}
```

