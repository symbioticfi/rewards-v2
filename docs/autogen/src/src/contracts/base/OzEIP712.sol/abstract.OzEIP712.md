# OzEIP712
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/0d1d60e5621e9cba72ce5532e4376d32289bb794/src/contracts/base/OzEIP712.sol)

**Inherits:**
EIP712Upgradeable, [IOzEIP712](/src/interfaces/base/IOzEIP712.sol/interface.IOzEIP712.md)

**Title:**
OzEIP712

Contract for initializing and exposing OpenZeppelin EIP712 helpers.

Extends OZ's EIP712 implementation with cross-chain hashing utility.


## State Variables
### CROSS_CHAIN_TYPE_HASH

```solidity
bytes32 private constant CROSS_CHAIN_TYPE_HASH = keccak256("EIP712Domain(string name,string version)")
```


## Functions
### __OzEIP712_init


```solidity
function __OzEIP712_init(OzEIP712InitParams memory initParams) internal virtual onlyInitializing;
```

### hashTypedDataV4

Returns the EIP712 hash of the typed data.


```solidity
function hashTypedDataV4(bytes32 structHash) public view returns (bytes32);
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
function hashTypedDataV4CrossChain(bytes32 structHash) public view virtual returns (bytes32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`structHash`|`bytes32`|The hash of the typed data struct.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The EIP712 formatted hash.|


