# VaultSnapshotRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/1a74025d9c2bbe71abf013585bb862f9492e7d28/src/contracts/VaultSnapshotRewards.sol)

**Inherits:**
[ProtocolFees](/src/contracts/ProtocolFees.sol/abstract.ProtocolFees.md), [IVaultSnapshotRewards](/src/interfaces/IVaultSnapshotRewards.sol/interface.IVaultSnapshotRewards.md)

**Title:**
VaultSnapshotRewards

Contract for managing vault snapshot-based rewards distributions.

The protocol fee is deducted from the distribution amount.


## State Variables
### VAULT_FACTORY
Returns the vault factory address.


```solidity
address public immutable VAULT_FACTORY
```


### NETWORK_REGISTRY
Returns the network registry address.


```solidity
address public immutable NETWORK_REGISTRY
```


### NETWORK_MIDDLEWARE_SERVICE
Returns the network middleware service address.


```solidity
address public immutable NETWORK_MIDDLEWARE_SERVICE
```


### CURATOR_REGISTRY
Returns the curator registry address.


```solidity
address public immutable CURATOR_REGISTRY
```


### VAULT_SNAPSHOT_REWARDS_STORAGE_POSITION

```solidity
bytes32 private constant VAULT_SNAPSHOT_REWARDS_STORAGE_POSITION =
    0xea7ec811d4da20f680ecf87dbad2b956cc74e833cd99b5f63865df6b3d6b6800
```


## Functions
### _vaultSnapshotRewardsStorage


```solidity
function _vaultSnapshotRewardsStorage() private pure returns (VaultSnapshotRewardsStorage storage $);
```

### constructor


```solidity
constructor(
    address vaultFactory,
    address networkRegistry,
    address networkMiddlewareService,
    address curatorRegistry
) ;
```

### distributionToTotalAmount

Returns a total amount that must be provided (including protocol fees) from the net distribution amount.


```solidity
function distributionToTotalAmount(
    uint64,
    /*rewardsType*/
    address network,
    uint256 distributionAmount
)
    public
    view
    virtual
    override
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint64`||
|`network`|`address`|The network for which the protocol fee will be applied.|
|`distributionAmount`|`uint256`|Amount intended to reach recipients, excluding protocol fees.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Gross amount required to cover the distribution plus protocol fees.|


### totalToDistributionAmount

Returns a net distribution amount from the total provided amount (inclusive of protocol fees).


```solidity
function totalToDistributionAmount(
    uint64,
    /*rewardsType*/
    address network,
    uint256 totalDistributionAmount
)
    public
    view
    virtual
    override
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint64`||
|`network`|`address`|The network for which the protocol fee will be applied.|
|`totalDistributionAmount`|`uint256`|Gross amount supplied for the distribution, including protocol fees.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Net amount available for recipients after protocol fees are removed.|


### rewardsLength

Returns the number of reward distributions for a vault, network, and token.


```solidity
function rewardsLength(address vault, address network, address token) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The number of reward distributions.|


### rewards

Returns a reward distribution by index.


```solidity
function rewards(address vault, address network, address token, uint256 index)
    public
    view
    returns (RewardDistribution memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|
|`index`|`uint256`|The reward index.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`RewardDistribution`|The reward distribution.|


### lastUnclaimedReward

Returns the last unclaimed reward index for an account.


```solidity
function lastUnclaimedReward(address account, address vault, address network, address token)
    public
    view
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The account address.|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The last unclaimed reward index.|


### lastUnclaimedOperatorReward

Returns the last unclaimed operator reward index for an account.


```solidity
function lastUnclaimedOperatorReward(address account, address vault, address network, address token)
    public
    view
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The account address.|
|`vault`|`address`|The vault address.|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The last unclaimed operator reward index.|


### curatorFee

Returns the curator fee for a vault and token.


```solidity
function curatorFee(address vault, address token) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The curator fee.|


### distributeVaultSnapshotRewards

Distributes vault snapshot rewards (only network or middleware).


```solidity
function distributeVaultSnapshotRewards(
    bytes32 subnetwork,
    address token,
    address vault,
    uint256 amount,
    uint48 timestamp,
    bytes calldata activeSharesHint
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`subnetwork`|`bytes32`|The subnetwork identifier.|
|`token`|`address`|The token address.|
|`vault`|`address`|The vault address.|
|`amount`|`uint256`|The amount to distribute.|
|`timestamp`|`uint48`|The distribution timestamp.|
|`activeSharesHint`|`bytes`|Hint for active shares calculation.|


### claimVaultSnapshotRewards

Claims vault snapshot rewards.


```solidity
function claimVaultSnapshotRewards(
    address recipient,
    address network,
    address token,
    address vault,
    uint256 lastUnclaimedRewards,
    uint256 firstRewardToClaim,
    uint256 maxRewards,
    bytes[] memory activeSharesHints
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|
|`vault`|`address`|The vault address.|
|`lastUnclaimedRewards`|`uint256`|The last unclaimed rewards index.|
|`firstRewardToClaim`|`uint256`|The first reward index to claim (optional).|
|`maxRewards`|`uint256`|The maximum number of rewards to process.|
|`activeSharesHints`|`bytes[]`||


### claimCuratorFee

Claims the curator fee (only curator).


```solidity
function claimCuratorFee(address recipient, address vault, address token) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`vault`|`address`|The vault address.|
|`token`|`address`|The token address.|


### claimOperatorFee

Claims the operator fee.


```solidity
function claimOperatorFee(
    address recipient,
    address network,
    address token,
    address vault,
    uint256 lastUnclaimedRewards,
    uint256 firstRewardToClaim,
    uint256 maxRewards,
    bytes calldata extraData
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`network`|`address`|The network address.|
|`token`|`address`|The token address.|
|`vault`|`address`|The vault address.|
|`lastUnclaimedRewards`|`uint256`|The last unclaimed rewards index.|
|`firstRewardToClaim`|`uint256`|The first reward index to claim (optional).|
|`maxRewards`|`uint256`|The maximum number of rewards to process.|
|`extraData`|`bytes`|Additional data for operator type-specific logic.|


### claimRewards

Claims rewards via a unified entrypoint.


```solidity
function claimRewards(address recipient, address token, bytes calldata data) public virtual;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`token`|`address`|The token address.|
|`data`|`bytes`|The encoded claim data containing reward type and specific data.|


## Structs
### VaultSnapshotRewardsStorage
**Note:**
storage-location: erc7201:symbiotic.rewards.VaultSnapshotRewards


```solidity
struct VaultSnapshotRewardsStorage {
    mapping(
        address vault => mapping(address network => mapping(address token => RewardDistribution[] rewards_))
    ) _rewards;
    mapping(
        address account
            => mapping(address vault => mapping(address network => mapping(address token => uint256 rewardIndex)))
    ) _lastUnclaimedReward;
    mapping(
        address account
            => mapping(address vault => mapping(address network => mapping(address token => uint256 rewardIndex)))
    ) _lastUnclaimedOperatorReward;
    mapping(address vault => mapping(uint48 timestamp => uint256 amount)) _activeSharesCache;
    mapping(address vault => mapping(address token => uint256 fee)) _curatorFees;
}
```

