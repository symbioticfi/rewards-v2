# ICumulativeMerkleRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/5948220cedfb0e575381199e718d1538678c4d9a/src/interfaces/ICumulativeMerkleRewards.sol)

**Inherits:**
[IRewardsBase](/src/interfaces/IRewardsBase.sol/interface.IRewardsBase.md)

**Title:**
ICumulativeMerkleRewards

Interface for the CumulativeMerkleRewards contract.


## Functions
### lastCumulativeDistribution

Returns the last cumulative distribution for a network.


```solidity
function lastCumulativeDistribution(address network) external view returns (CumulativeDistribution memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`CumulativeDistribution`|The last cumulative distribution.|


### lastTotalAmount

Returns the last total amount for a network and token.


```solidity
function lastTotalAmount(address network, address token) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The last total amount.|


### isCumulativeDistributionRoot

Returns whether a cumulative distribution root exists for a network.


```solidity
function isCumulativeDistributionRoot(address network, bytes32 root) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|
|`root`|`bytes32`|The merkle root to check.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the root exists.|


### balance

Returns the balance for a network and token.


```solidity
function balance(address network, address token) external view returns (uint256 amount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount`|`uint256`|The balance amount.|


### claimed

Returns the claimed amount for a rewardee.


```solidity
function claimed(address network, address token, address rewardee, uint256 rewardeeType)
    external
    view
    returns (uint256 amount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|
|`rewardee`|`address`|The rewardee address.|
|`rewardeeType`|`uint256`|The rewardee type.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount`|`uint256`|The claimed amount.|


### rewarder

Returns the rewarder for a network.


```solidity
function rewarder(address network) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The rewarder address.|


### protocol

Returns the protocol address.


```solidity
function protocol() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The protocol address.|


### distributeCumulativeMerkleRewards

Distributes cumulative merkle rewards for a network.


```solidity
function distributeCumulativeMerkleRewards(
    address network,
    CumulativeDistribution calldata cumulativeDistribution,
    TokenAmount[] calldata totalAmounts,
    bytes calldata protocolSignature,
    bytes calldata rewarderSignature
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|
|`cumulativeDistribution`|`CumulativeDistribution`|The cumulative distribution data.|
|`totalAmounts`|`TokenAmount[]`|Array of total amounts per token and chainId.|
|`protocolSignature`|`bytes`|Signature by the protocol over the payload.|
|`rewarderSignature`|`bytes`|Signature by the network rewarder over the payload.|


### depositCumulativeMerkleRewards

Deposits tokens to fund cumulative merkle rewards.


```solidity
function depositCumulativeMerkleRewards(address network, address token, uint256 amount) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|
|`amount`|`uint256`|The amount to deposit.|


### withdrawCumulativeMerkleRewards

Withdraws cumulative merkle rewards for a network (only rewarder).


```solidity
function withdrawCumulativeMerkleRewards(address recipient, address network, address token, uint256 amount) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|
|`amount`|`uint256`|The amount to withdraw.|


### claimCumulativeMerkleRewards

Claims cumulative merkle rewards for a recipient.


```solidity
function claimCumulativeMerkleRewards(
    address recipient,
    address network,
    CumulativeDistributionLeaf calldata leaf,
    bytes32[] calldata proof,
    bytes32 merkleRoot
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`network`|`address`|The network address.|
|`leaf`|`CumulativeDistributionLeaf`|The distribution leaf data.|
|`proof`|`bytes32[]`|The merkle proof.|
|`merkleRoot`|`bytes32`|The merkle root.|


### setRewarder

Sets the rewarder for a network.


```solidity
function setRewarder(address rewarder) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rewarder`|`address`|The rewarder address.|


### setProtocol

Sets the protocol address.


```solidity
function setProtocol(address protocol) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`protocol`|`address`|The protocol address.|


## Events
### DistributeCumulativeMerkleRewards
Emitted when cumulative merkle rewards are distributed for a network.


```solidity
event DistributeCumulativeMerkleRewards(address indexed network, CumulativeDistribution cumulativeDistribution);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network whose distribution is updated.|
|`cumulativeDistribution`|`CumulativeDistribution`|Distribution metadata that was published.|

### DepositCumulativeMerkleRewards
Emitted when tokens are deposited for a network's balance.


```solidity
event DepositCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network receiving the deposited tokens.|
|`token`|`address`|ERC20 token deposited into the rewards pool.|
|`amount`|`uint256`|Net token amount received.|

### WithdrawCumulativeMerkleRewards
Emitted when tokens are withdrawn from a network's balance.


```solidity
event WithdrawCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network whose balance decreased.|
|`token`|`address`|ERC20 token withdrawn from the rewards pool.|
|`amount`|`uint256`|Token amount transferred out.|

### ClaimCumulativeMerkleRewards
Emitted when a rewardee claims rewards.


```solidity
event ClaimCumulativeMerkleRewards(
    address indexed rewardee, address indexed network, CumulativeDistributionLeaf leaf
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rewardee`|`address`|Address of the account that initiated the claim.|
|`network`|`address`|The network under which the claim was made.|
|`leaf`|`CumulativeDistributionLeaf`|Leaf data that defines the claimed allocation.|

### SetRewarder
Emitted when a rewarder is set for a network.


```solidity
event SetRewarder(address indexed network, address rewarder);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network whose rewarder changed.|
|`rewarder`|`address`|The address now authorized to manage rewards.|

### SetProtocol
Emitted when the protocol address is updated.


```solidity
event SetProtocol(address indexed protocol);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`protocol`|`address`|The new protocol address.|

## Errors
### InsufficientDeposit
Raised when trying to deposit zero tokens.


```solidity
error InsufficientDeposit();
```

### InvalidMerkleProof
Raised when a supplied merkle proof is invalid.


```solidity
error InvalidMerkleProof();
```

### InvalidMerkleRoot
Raised when a supplied merkle root is not recognized.


```solidity
error InvalidMerkleRoot();
```

### InvalidSignature
Raised when a signature validation fails.


```solidity
error InvalidSignature();
```

### InvalidTimestamp
Raised when a distribution timestamp is not strictly increasing.


```solidity
error InvalidTimestamp();
```

### InvalidToken
Raised when a provided token address does not match expectations.


```solidity
error InvalidToken();
```

### NoCumulativeRewardsToClaim
Raised when a claimant has no rewards to withdraw.


```solidity
error NoCumulativeRewardsToClaim();
```

### NotRewarder
Raised when the caller is not authorized as the rewarder for a network.


```solidity
error NotRewarder();
```

### RootAlreadySet
Raised when attempting to register a merkle root that has already been stored.


```solidity
error RootAlreadySet();
```

## Structs
### CumulativeDistribution
Distribution checkpoint recorded for a network.


```solidity
struct CumulativeDistribution {
    uint48 timestamp;
    bytes32 merkleRoot;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`timestamp`|`uint48`|Timestamp of the cumulative distribution.|
|`merkleRoot`|`bytes32`|Merkle root that defines the distribution state.|

### TokenAmount
Token amount snapshot that is used in reward distribution.


```solidity
struct TokenAmount {
    uint64 chainId;
    address token;
    uint256 amount;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`chainId`|`uint64`|Chain identifier where the amount applies.|
|`token`|`address`|ERC20 token address tied to the amount.|
|`amount`|`uint256`|Total amount accumulated for the token.|

### CumulativeDistributionLeaf
Leaf payload used to verify an individual cumulative reward claim.


```solidity
struct CumulativeDistributionLeaf {
    // address rewardee;
    // uint64 chainId;
    address token;
    uint256 rewardeeType;
    uint256 amount;
    bytes32 rewardeeDataHash;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|ERC20 token address being claimed.|
|`rewardeeType`|`uint256`|Encoded rewardee type for downstream accounting.|
|`amount`|`uint256`|Total cumulative amount allocated to the rewardee.|
|`rewardeeDataHash`|`bytes32`|Hash of rewardee-specific data that parametrizes the claim.|

