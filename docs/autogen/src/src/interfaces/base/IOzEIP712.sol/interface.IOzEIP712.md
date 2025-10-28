# IOzEIP712
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/1a02678d8da2496e9aa689307a72bcc819979a57/src/interfaces/base/IOzEIP712.sol)

**Inherits:**
IERC5267

Interface for the OzEIP712 contract.


## Functions
### hashTypedDataV4

Returns the EIP712 hash of the typed data.


```solidity
function hashTypedDataV4(bytes32 structHash) external view returns (bytes32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`structHash`|`bytes32`|The hash of the typed data struct.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The EIP712 formatted hash.|


### hashTypedDataV4CrossChain

Returns the EIP712-formatted hash for cross-chain usage.

It doesn't include `chainId` and `verifyingContract` fields for the domain separator.


```solidity
function hashTypedDataV4CrossChain(bytes32 structHash) external view returns (bytes32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`structHash`|`bytes32`|The hash of the typed data struct.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The EIP712 formatted hash.|


## Events
### InitEIP712
Emitted when the OzEIP712 contract is initialized.


```solidity
event InitEIP712(string name, string version);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`name`|`string`|The name for EIP712.|
|`version`|`string`|The version for EIP712.|

## Structs
### OzEIP712InitParams
Parameters used to initialize the OzEIP712 contract.


```solidity
struct OzEIP712InitParams {
    string name;
    string version;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`name`|`string`|The name for EIP712.|
|`version`|`string`|The version for EIP712.|

