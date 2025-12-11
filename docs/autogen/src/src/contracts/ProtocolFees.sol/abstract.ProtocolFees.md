# ProtocolFees
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/0d1d60e5621e9cba72ce5532e4376d32289bb794/src/contracts/ProtocolFees.sol)

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

### protocolFees

Returns the claimable protocol fees for a token.


```solidity
function protocolFees(address token) public view returns (uint256);
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


### distributionToTotalAmount

Returns a total amount that must be provided (including protocol fees) from the net distribution amount.


```solidity
function distributionToTotalAmount(uint64 rewardsType, address network, uint256 distributionAmount)
    public
    view
    virtual
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
    virtual
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


### _subProtocolFeesFromTotal

Subtracts protocol fees from total amount.


```solidity
function _subProtocolFeesFromTotal(
    uint64 rewardsType,
    address network,
    address token,
    uint256 totalDistributionAmount
) internal returns (uint256 distributionAmount);
```

### _addProtocolFeesToDistribution

Adds protocol fees to distribution amount.


```solidity
function _addProtocolFeesToDistribution(
    uint64 rewardsType,
    address network,
    address token,
    uint256 distributionAmount
) internal returns (uint256 totalDistributionAmount);
```

### _accountProtocolFees

Account protocol fees.


```solidity
function _accountProtocolFees(
    uint64 rewardsType,
    address network,
    address token,
    uint256 totalDistributionAmount,
    uint256 distributionAmount
) internal;
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

