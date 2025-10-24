# VaultSnapshotRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/b1edbdbf4eef5695a1b8375af57d0645f32535e2/src/contracts/VaultSnapshotRewards.sol)

**Inherits:**
[ProtocolFees](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/contracts/ProtocolFees.sol/abstract.ProtocolFees.md), [IVaultSnapshotRewards](/Users/andreikorokhov/symbiotic/rewards-v2/docs/autogen/src/src/interfaces/IVaultSnapshotRewards.sol/interface.IVaultSnapshotRewards.md)

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
    bytes[] calldata activeSharesHints
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

Claims rewards via the vault snapshot path.


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
### VaultSnapshotRewardsStorage

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

