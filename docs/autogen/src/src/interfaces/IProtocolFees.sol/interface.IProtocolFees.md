# IProtocolFees
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/7420a9b04d75b1dec8c5eb0720d16cf567ba64f6/src/interfaces/IProtocolFees.sol)

**Title:**
IProtocolFees

Interface for the ProtocolFees contract.


## Functions
### MAX_FEE

Returns the maximum fee value.


```solidity
function MAX_FEE() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The maximum fee value.|


### FEE_REGISTRY

Returns the FeeRegistry contract address.


```solidity
function FEE_REGISTRY() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The FeeRegistry address.|


### protocolFees

Returns the claimable protocol fees for a token.


```solidity
function protocolFees(address token) external view returns (uint256);
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
function protocolFee(uint64 rewardsType, address network) external view returns (uint256);
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
    external
    view
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
    external
    view
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
function claimProtocolFees(address recipient, address token) external returns (uint256 fees);
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


## Events
### AccountProtocolFees
Emitted when protocol fees are accounted for a distribution.


```solidity
event AccountProtocolFees(uint64 indexed rewardsType, address indexed network, address indexed token, uint256 fees);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rewardsType`|`uint64`|Type identifier for the rewards flow.|
|`network`|`address`|The network whose rewards incurred the fee.|
|`token`|`address`|ERC20 token the fee was accounted at.|
|`fees`|`uint256`|Amount of tokens reserved as protocol fees.|

### ClaimProtocolFees
Emitted when protocol fees are claimed.


```solidity
event ClaimProtocolFees(address indexed token, uint256 fees);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|ERC20 token that was transferred to the claimant.|
|`fees`|`uint256`|Amount of protocol fees disbursed.|

## Errors
### InsufficientClaimableFees
Raised when no fees are available to claim for a token.


```solidity
error InsufficientClaimableFees();
```

