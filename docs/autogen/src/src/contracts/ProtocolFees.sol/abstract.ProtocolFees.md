# ProtocolFees
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/ea533e8a8c25f8a67c26f45a7da52beeee4efd9e/src/contracts/ProtocolFees.sol)

**Inherits:**
OwnableUpgradeable, [IProtocolFees](/src/interfaces/IProtocolFees.sol/interface.IProtocolFees.md)

**Title:**
ProtocolFees

Contract for processing protocol fees.


## State Variables
### MAX_FEE
Returns the maximum fee value.


```solidity
uint256 public constant MAX_FEE = 1_000_000
```


### REWARDS_FEE_ID

```solidity
string internal constant REWARDS_FEE_ID = "rewards"
```


### FEE_REGISTRY
Returns the FeeRegistry contract address.


```solidity
address public immutable FEE_REGISTRY
```


### PROTOCOL_FEES_STORAGE_POSITION

```solidity
bytes32 private constant PROTOCOL_FEES_STORAGE_POSITION =
    0xaca04fd08ff691cdb4ae78510a180bcc9e13b5c0befede355a0801aecf227800
```


## Functions
### _protocolFeesStorage


```solidity
function _protocolFeesStorage() private pure returns (ProtocolFeesStorage storage $);
```

### constructor


```solidity
constructor(address feeRegistry) ;
```

### __ProtocolFees_init


```solidity
function __ProtocolFees_init(address owner) internal onlyInitializing;
```

### claimableProtocolFees

Returns the claimable protocol fees for a token.


```solidity
function claimableProtocolFees(address token) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The claimable fee amount.|


### protocolFee

Returns the protocol fee for a reward type and network.


```solidity
function protocolFee(uint64 rewardsType, address network) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rewardsType`|`uint64`|The reward type identifier.|
|`network`|`address`|The network address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The protocol fee amount.|


### claimProtocolFees

Claims protocol fees for a token (only owner).


```solidity
function claimProtocolFees(address recipient, address token) public onlyOwner returns (uint256 fees);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`fees`|`uint256`|The amount of fees claimed.|


### _deductProtocolFees

Calculates protocol fees from an amount and stores the claimable fees.


```solidity
function _deductProtocolFees(uint64 rewardsType, address network, address token, uint256 amount)
    internal
    returns (uint256 fees);
```

## Structs
### ProtocolFeesStorage
**Note:**
storage-location: erc7201:symbiotic.rewards.ProtocolFees


```solidity
struct ProtocolFeesStorage {
    mapping(address token => uint256 fee) _claimableFee;
}
```

