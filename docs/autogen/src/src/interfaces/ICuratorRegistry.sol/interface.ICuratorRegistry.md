# ICuratorRegistry
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/75106d07ed170944160a088b3f8fb334459d9567/src/interfaces/ICuratorRegistry.sol)

**Title:**
ICuratorRegistry

Interface for the CuratorRegistry contract.


## Functions
### getCuratorAt

Returns the curator for a vault at a specific timestamp.


```solidity
function getCuratorAt(address vault, uint48 timestamp, bytes memory hint) external view returns (address);
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
function getCurator(address vault) external view returns (address);
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
function setCurator(address vault, address curator) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`curator`|`address`|The curator address to set.|


## Events
### SetCurator
Emitted when a curator is set for a vault.


```solidity
event SetCurator(address indexed vault, address indexed curator);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`curator`|`address`|The curator address.|

## Errors
### NotAuthorized
Raised when the caller lacks permission to manage curators.


```solidity
error NotAuthorized();
```

