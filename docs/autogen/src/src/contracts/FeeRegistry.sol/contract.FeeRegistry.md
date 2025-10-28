# FeeRegistry
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/1a02678d8da2496e9aa689307a72bcc819979a57/src/contracts/FeeRegistry.sol)

**Inherits:**
OwnableUpgradeable, MulticallUpgradeable, StaticDelegateCallable, [IFeeRegistry](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/interfaces/IFeeRegistry.sol/interface.IFeeRegistry.md)

Contract for storing curators', operators', and protocol's fee configurations with historical tracking.


## State Variables
### MAX_FEE
Returns the maximum fee value (100%).


```solidity
uint256 public constant MAX_FEE = 1_000_000
```


### MAX_PARTICIPANT_FEE
Returns the maximum fee value for operators and curators.

Set to 50%, so operatorsFee + curatorFee can't exceed 100%.


```solidity
uint256 public constant MAX_PARTICIPANT_FEE = 500_000
```


### CURATOR_REGISTRY
Returns the curator registry address.


```solidity
address public immutable CURATOR_REGISTRY
```


### FEE_REGISTRY_STORAGE_POSITION

```solidity
bytes32 private constant FEE_REGISTRY_STORAGE_POSITION =
    0x93d27e35e5186e4ea21573d1a25649cf5417be8a9fc60183b644027fed662100
```


## Functions
### _feeRegistryStorage


```solidity
function _feeRegistryStorage() private pure returns (FeeRegistryStorage storage $);
```

### onlyCurator


```solidity
modifier onlyCurator(address vault) ;
```

### constructor


```solidity
constructor(address curatorRegistry_) ;
```

### initialize


```solidity
function initialize(address owner) public initializer;
```

### getOperatorsFeeAt

Returns the operator fee for a vault and network at a specific timestamp.


```solidity
function getOperatorsFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
    public
    view
    returns (uint256);
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
|`<none>`|`uint256`|fee The fee amount.|


### getOperatorsFee

Returns the operator fee for a vault and network.


```solidity
function getOperatorsFee(address vault, address network) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|fee The fee amount.|


### getOperatorsNetworkFeeAt

Returns the operator network fee at a specific timestamp.


```solidity
function getOperatorsNetworkFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
    public
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
function getOperatorsNetworkFee(address vault, address network) public view returns (bool isEnabled, uint256 fee);
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
    public
    view
    returns (uint256);
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
|`<none>`|`uint256`|fee The fee amount.|


### getOperatorsDefaultFee

Returns the default operator fee.


```solidity
function getOperatorsDefaultFee(address vault) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|fee The fee amount.|


### getCuratorFeeAt

Returns the curator fee at a specific timestamp.


```solidity
function getCuratorFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
    public
    view
    returns (uint256);
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
|`<none>`|`uint256`|fee The fee amount.|


### getCuratorFee

Returns the curator fee.


```solidity
function getCuratorFee(address vault, address network) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|fee The fee amount.|


### getCuratorNetworkFeeAt

Returns the curator network fee at a specific timestamp.


```solidity
function getCuratorNetworkFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
    public
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
function getCuratorNetworkFee(address vault, address network) public view returns (bool isEnabled, uint256 fee);
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
function getCuratorDefaultFeeAt(address vault, uint48 timestamp, bytes memory hint) public view returns (uint256);
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
|`<none>`|`uint256`|fee The fee amount.|


### getCuratorDefaultFee

Returns the default curator fee.


```solidity
function getCuratorDefaultFee(address vault) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|fee The fee amount.|


### getProtocolFee

Returns the protocol fee.


```solidity
function getProtocolFee(bytes32 id) public view returns (bool isEnabled, uint256 fee);
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
function setOperatorsFee(address vault, uint256 fee) public onlyCurator(vault);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`fee`|`uint256`|The fee amount.|


### setOperatorsNetworkFee

Sets the operator network fee for a vault (only curator).


```solidity
function setOperatorsNetworkFee(address vault, address network, bool enable, uint256 fee)
    public
    onlyCurator(vault);
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
function setCuratorFee(address vault, uint256 fee) public onlyCurator(vault);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`fee`|`uint256`|The fee amount.|


### setCuratorNetworkFee

Sets the curator network fee for a vault (only curator).


```solidity
function setCuratorNetworkFee(address vault, address network, bool enable, uint256 fee) public onlyCurator(vault);
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
function setProtocolFee(bytes32 id, bool enable, uint256 fee) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id`|`bytes32`|The id of the protocol.|
|`enable`|`bool`|Whether the fee is enabled.|
|`fee`|`uint256`|The fee amount.|


### _serializeFeeData

Serializes fee data (enable + fee).


```solidity
function _serializeFeeData(bool isEnabled, uint256 fee) internal pure returns (uint208);
```

### _deserializeFeeData

Deserializes fee data (enable + fee).


```solidity
function _deserializeFeeData(uint208 data) internal pure returns (bool, uint256);
```

## Structs
### FeeRegistryStorage
**Note:**
storage-location: erc7201:symbiotic.rewards.FeeRegistry


```solidity
struct FeeRegistryStorage {
    mapping(address vault => Checkpoints.Trace208 value) _operatorsFee;
    mapping(address vault => mapping(address network => Checkpoints.Trace208 value)) _operatorsNetworkFee;
    mapping(address vault => Checkpoints.Trace208 value) _curatorFee;
    mapping(address vault => mapping(address network => Checkpoints.Trace208 value)) _curatorNetworkFee;
    mapping(bytes32 id => uint208 fee) _protocolFee;
}
```

