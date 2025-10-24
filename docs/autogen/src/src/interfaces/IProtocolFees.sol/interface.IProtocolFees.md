# IProtocolFees
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/b1edbdbf4eef5695a1b8375af57d0645f32535e2/src/interfaces/IProtocolFees.sol)

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


### claimableProtocolFees

Returns the claimable protocol fees for a token.


```solidity
function claimableProtocolFees(address token) external view returns (uint256);
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
### DeductProtocolFee
Emitted when protocol fees are deducted for a distribution.


```solidity
event DeductProtocolFee(uint64 indexed rewardsType, address indexed network, address indexed token, uint256 fees);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rewardsType`|`uint64`|Type identifier for the rewards flow.|
|`network`|`address`|The network whose rewards incurred the fee.|
|`token`|`address`|ERC20 token from which the fee was deducted.|
|`fees`|`uint256`|Amount of tokens reserved as protocol fees.|

### ClaimProtocolFee
Emitted when protocol fees are claimed.


```solidity
event ClaimProtocolFee(address indexed token, uint256 fees);
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

