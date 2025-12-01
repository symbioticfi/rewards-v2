# IFeeRegistry
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/1a74025d9c2bbe71abf013585bb862f9492e7d28/src/interfaces/IFeeRegistry.sol)

**Title:**
IFeeRegistry

Interface for the FeeRegistry contract.


## Functions
### MAX_FEE

Returns the maximum fee value (100%).


```solidity
function MAX_FEE() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The maximum fee value.|


### MAX_PARTICIPANT_FEE

Returns the maximum fee value for operators, curators, and protocol rewards.

Set to 50%, so participants' fees collectively cannot exceed 100%.


```solidity
function MAX_PARTICIPANT_FEE() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The maximum fee value.|


### CURATOR_REGISTRY

Returns the curator registry address.


```solidity
function CURATOR_REGISTRY() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The curator registry address.|


### getOperatorsFeeAt

Returns the operator fee for a vault and network at a specific timestamp.


```solidity
function getOperatorsFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
    external
    view
    returns (uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`timestamp`|`uint48`|The timestamp to query.|
|`hint`|`bytes`|Optional hint for optimization.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`fee`|`uint256`|The fee amount.|


### getOperatorsFee

Returns the operator fee for a vault and network.


```solidity
function getOperatorsFee(address vault, address network) external view returns (uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`fee`|`uint256`|The fee amount.|


### getOperatorsNetworkFeeAt

Returns the operator network fee at a specific timestamp.


```solidity
function getOperatorsNetworkFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
    external
    view
    returns (bool isEnabled, uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`timestamp`|`uint48`|The timestamp to query.|
|`hint`|`bytes`|Optional hint for optimization.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isEnabled`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


### getOperatorsNetworkFee

Returns the operator network fee.


```solidity
function getOperatorsNetworkFee(address vault, address network) external view returns (bool isEnabled, uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isEnabled`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


### getOperatorsDefaultFeeAt

Returns the default operator fee at a specific timestamp.


```solidity
function getOperatorsDefaultFeeAt(address vault, uint48 timestamp, bytes memory hint)
    external
    view
    returns (uint256 fee);
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
|`fee`|`uint256`|The fee amount.|


### getOperatorsDefaultFee

Returns the default operator fee.


```solidity
function getOperatorsDefaultFee(address vault) external view returns (uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`fee`|`uint256`|The fee amount.|


### getCuratorFeeAt

Returns the curator fee at a specific timestamp.


```solidity
function getCuratorFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
    external
    view
    returns (uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`timestamp`|`uint48`|The timestamp to query.|
|`hint`|`bytes`|Optional hint for optimization.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`fee`|`uint256`|The fee amount.|


### getCuratorFee

Returns the curator fee.


```solidity
function getCuratorFee(address vault, address network) external view returns (uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`fee`|`uint256`|The fee amount.|


### getCuratorNetworkFeeAt

Returns the curator network fee at a specific timestamp.


```solidity
function getCuratorNetworkFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
    external
    view
    returns (bool isEnabled, uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`timestamp`|`uint48`|The timestamp to query.|
|`hint`|`bytes`|Optional hint for optimization.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isEnabled`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


### getCuratorNetworkFee

Returns the curator network fee.


```solidity
function getCuratorNetworkFee(address vault, address network) external view returns (bool isEnabled, uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isEnabled`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


### getCuratorDefaultFeeAt

Returns the default curator fee at a specific timestamp.


```solidity
function getCuratorDefaultFeeAt(address vault, uint48 timestamp, bytes memory hint)
    external
    view
    returns (uint256 fee);
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
|`fee`|`uint256`|The fee amount.|


### getCuratorDefaultFee

Returns the default curator fee.


```solidity
function getCuratorDefaultFee(address vault) external view returns (uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`fee`|`uint256`|The fee amount.|


### getProtocolFee

Returns the protocol fee.


```solidity
function getProtocolFee(bytes32 id) external view returns (bool isEnabled, uint256 fee);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`bytes32`|The id of the protocol.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`isEnabled`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


### setOperatorsFee

Sets the operator fee for a vault (only curator).


```solidity
function setOperatorsFee(address vault, uint256 fee) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`fee`|`uint256`|The fee amount.|


### setOperatorsNetworkFee

Sets the operator network fee for a vault (only curator).


```solidity
function setOperatorsNetworkFee(address vault, address network, bool enable, uint256 fee) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`enable`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


### setCuratorFee

Sets the curator fee for a vault (only curator).


```solidity
function setCuratorFee(address vault, uint256 fee) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`fee`|`uint256`|The fee amount.|


### setCuratorNetworkFee

Sets the curator network fee for a vault (only curator).


```solidity
function setCuratorNetworkFee(address vault, address network, bool enable, uint256 fee) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`enable`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


### setProtocolFee

Sets the protocol fee.


```solidity
function setProtocolFee(bytes32 id, bool enable, uint256 fee) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`bytes32`|The id of the protocol.|
|`enable`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


## Events
### SetOperatorsFee
Emitted when the operator fee is set for a vault.


```solidity
event SetOperatorsFee(address indexed vault, uint256 fee);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`fee`|`uint256`|The fee amount.|

### SetOperatorsNetworkFee
Emitted when an operator network fee is set for a vault.


```solidity
event SetOperatorsNetworkFee(address indexed vault, address indexed network, bool enable, uint256 fee);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`enable`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|

### SetCuratorFee
Emitted when the curator fee is set for a vault.


```solidity
event SetCuratorFee(address indexed vault, uint256 fee);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`fee`|`uint256`|The fee amount.|

### SetCuratorNetworkFee
Emitted when a curator network fee is set for a vault.


```solidity
event SetCuratorNetworkFee(address indexed vault, address indexed network, bool enable, uint256 fee);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`enable`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|

### SetProtocolFee
Emitted when the protocol fee is set.


```solidity
event SetProtocolFee(bytes32 indexed id, bool enable, uint256 fee);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`bytes32`|The id of the protocol.|
|`enable`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|

## Errors
### FeeTooHigh
Raised when a supplied fee exceeds the configured limit.


```solidity
error FeeTooHigh();
```

### NotCurator
Raised when the caller is not the curator authorized for a vault.


```solidity
error NotCurator();
```

