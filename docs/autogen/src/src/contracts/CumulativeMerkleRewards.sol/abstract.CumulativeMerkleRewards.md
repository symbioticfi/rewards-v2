# CumulativeMerkleRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/2d5845a497cbd7fb2b3fbd104f0b6d6c69745cbb/src/contracts/CumulativeMerkleRewards.sol)

**Inherits:**
[OzEIP712](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/contracts/base/OzEIP712.sol/abstract.OzEIP712.md), [ProtocolFees](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/contracts/ProtocolFees.sol/abstract.ProtocolFees.md), [ICumulativeMerkleRewards](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/interfaces/ICumulativeMerkleRewards.sol/interface.ICumulativeMerkleRewards.md)

Contract for managing cumulative Merkle-based rewards distributions.

The protocol fee is taken on top of the distribution amount.


## State Variables
### TOKEN_AMOUNT_TYPEHASH

```solidity
bytes32 internal constant TOKEN_AMOUNT_TYPEHASH =
    keccak256("TokenAmount(uint64 chainId,address token,uint256 amount)")
```


### CUMULATIVE_DISTRIBUTION_PAYLOAD_TYPEHASH

```solidity
bytes32 internal constant CUMULATIVE_DISTRIBUTION_PAYLOAD_TYPEHASH = keccak256(
    "CumulativeDistributionPayload(uint48 timestamp,bytes32 merkleRoot,TokenAmount[] totalAmounts)TokenAmount(uint64 chainId,address token,uint256 amount)"
)
```


### CUMULATIVE_MERKLE_REWARDS_STORAGE_POSITION

```solidity
bytes32 private constant CUMULATIVE_MERKLE_REWARDS_STORAGE_POSITION =
    0xb35d10d93f469d2505237bd5d8067e02fbabfe765e611799bdbd03de345d3300
```


## Functions
### _cumulativeMerkleRewardsStorage


```solidity
function _cumulativeMerkleRewardsStorage() private pure returns (CumulativeMerkleRewardsStorage storage $);
```

### __CumulativeMerkleRewards_init


```solidity
function __CumulativeMerkleRewards_init() internal onlyInitializing;
```

### lastCumulativeDistribution

Returns the last cumulative distribution for a network.


```solidity
function lastCumulativeDistribution(address network) public view returns (CumulativeDistribution memory);
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
function lastTotalAmount(address network, address token) public view returns (uint256);
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
function isCumulativeDistributionRoot(address network, bytes32 root) public view returns (bool);
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
function balance(address network, address token) public view returns (uint256 amount);
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
    public
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
function rewarder(address network) public view returns (address);
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
function protocol() public view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The protocol address.|


### setProtocol

Sets the protocol address.


```solidity
function setProtocol(address protocol_) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`protocol_`|`address`||


### distributeCumulativeMerkleRewards

Distributes cumulative merkle rewards for a network.


```solidity
function distributeCumulativeMerkleRewards(
    address network,
    CumulativeDistribution calldata cumulativeDistribution,
    TokenAmount[] calldata totalAmounts,
    bytes calldata protocolSignature,
    bytes calldata rewarderSignature
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|The network address.|
|`cumulativeDistribution`|`CumulativeDistribution`|The cumulative distribution data.|
|`totalAmounts`|`TokenAmount[]`|Array of total amounts per token and chainId.|
|`protocolSignature`|`bytes`||
|`rewarderSignature`|`bytes`|Signature by the network rewarder over the payload.|


### depositCumulativeMerkleRewards

Deposits tokens to fund cumulative merkle rewards.


```solidity
function depositCumulativeMerkleRewards(address network, address token, uint256 amount) public;
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
function withdrawCumulativeMerkleRewards(address recipient, address network, address token, uint256 amount) public;
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
) public;
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
function setRewarder(address rewarder_) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rewarder_`|`address`||


### claimRewards

Claims rewards via the cumulative merkle path.


```solidity
function claimRewards(address recipient, address token, bytes calldata data) public virtual;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`token`|`address`|The token address.|
|`data`|`bytes`|The encoded claim data.|


## Structs
### CumulativeMerkleRewardsStorage
**Note:**
storage-location: erc7201:symbiotic.rewards.CumulativeMerkleRewards


```solidity
struct CumulativeMerkleRewardsStorage {
    mapping(address network => CumulativeDistribution) _lastCumulativeDistribution;
    mapping(address network => mapping(address token => uint256 amount)) _lastTotalAmounts;
    mapping(address network => mapping(bytes32 root => bool value)) _isCumulativeDistributionRoot;
    mapping(address network => mapping(address token => uint256 amount)) _balances;
    mapping(
        address network
            => mapping(
            address token => mapping(address rewardee => mapping(uint256 rewardeeType => uint256 amount))
        )
    ) _claimed;
    mapping(address network => address value) _rewarder;
    address protocol;
}
```

