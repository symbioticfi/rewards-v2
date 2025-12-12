# IVaultSnapshotRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/11fedf69e0d9e707626e9a4943efc07727c3876f/src/interfaces/IVaultSnapshotRewards.sol)

**Inherits:**
[IRewardsBase](/src/interfaces/IRewardsBase.sol/interface.IRewardsBase.md)

**Title:**
IVaultSnapshotRewards

Interface for the VaultSnapshotRewards contract.


## Functions
### VAULT_FACTORY

Returns the vault factory address.


```solidity
function VAULT_FACTORY() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The vault factory address.|


### NETWORK_REGISTRY

Returns the network registry address.


```solidity
function NETWORK_REGISTRY() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The network registry address.|


### NETWORK_MIDDLEWARE_SERVICE

Returns the network middleware service address.


```solidity
function NETWORK_MIDDLEWARE_SERVICE() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The network middleware service address.|


### CURATOR_REGISTRY

Returns the curator registry address.


```solidity
function CURATOR_REGISTRY() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The curator registry address.|


### rewardsLength

Returns the number of reward distributions for a vault, network, and token.


```solidity
function rewardsLength(address vault, address network, address token) external view returns (uint256);
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
    external
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
    external
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
    external
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


### curatorFees

Returns the curator fees for a vault and token.


```solidity
function curatorFees(address vault, address token) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|The vault address.|
|`token`|`address`|The token address.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The curator fees.|


### distributeVaultSnapshotRewards

Distributes vault snapshot rewards (only network or middleware).


```solidity
function distributeVaultSnapshotRewards(
    bytes32 subnetwork,
    address token,
    address vault,
    uint256 amount,
    uint48 timestamp,
    DistributeVaultSnapshotRewardsHints calldata hints
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`subnetwork`|`bytes32`|The subnetwork identifier.|
|`token`|`address`|The token address.|
|`vault`|`address`|The vault address.|
|`amount`|`uint256`|The amount to distribute.|
|`timestamp`|`uint48`|The distribution timestamp.|
|`hints`|`DistributeVaultSnapshotRewardsHints`|Hints for active shares and fee lookups.|


### claimVaultSnapshotRewards

Claims vault snapshot rewards.

firstRewardToClaim allows to skip not only empty distributions, but also the ones with rewards.


```solidity
function claimVaultSnapshotRewards(
    address recipient,
    address network,
    address token,
    address vault,
    uint256 lastUnclaimedRewards,
    uint256 firstRewardToClaim,
    uint256 rewardsToClaim,
    bytes[] memory activeSharesOfHints
) external;
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
|`rewardsToClaim`|`uint256`|The maximum number of rewards to process.|
|`activeSharesOfHints`|`bytes[]`|Hints for active shares calculation.|


### claimOperatorFees

Claims the operator fees.

firstRewardToClaim allows to skip not only empty distributions, but also the ones with rewards.


```solidity
function claimOperatorFees(
    address recipient,
    address network,
    address token,
    address vault,
    uint256 lastUnclaimedRewards,
    uint256 firstRewardToClaim,
    uint256 rewardsToClaim,
    bytes calldata extraData
) external;
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
|`rewardsToClaim`|`uint256`|The maximum number of rewards to process.|
|`extraData`|`bytes`|Additional data for operator type-specific logic.|


### claimCuratorFees

Claims the curator fees (only curator).

If the vault's curator is changed, the past fees go to the new curator.


```solidity
function claimCuratorFees(address recipient, address vault, address token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`vault`|`address`|The vault address.|
|`token`|`address`|The token address.|


## Events
### DistributeVaultSnapshotRewards
Emitted when vault snapshot rewards are distributed.


```solidity
event DistributeVaultSnapshotRewards(
    address indexed network,
    address indexed token,
    address indexed vault,
    uint96 subnetworkId,
    uint48 timestamp,
    uint256 amount,
    uint256 curatorFees,
    uint256 operatorsFees
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`network`|`address`|Network receiving the distribution.|
|`token`|`address`|ERC20 token distributed to the vault.|
|`vault`|`address`|Vault that recorded the distribution.|
|`subnetworkId`|`uint96`|Identifier of the subnetwork within the network.|
|`timestamp`|`uint48`|Timestamp associated with the distribution snapshot.|
|`amount`|`uint256`|Net reward amount made available for stakers.|
|`curatorFees`|`uint256`|Portion of the reward allocated to the curator.|
|`operatorsFees`|`uint256`|Portion of the reward allocated to operators.|

### ClaimVaultSnapshotRewards
Emitted when a staker claims vault snapshot rewards.


```solidity
event ClaimVaultSnapshotRewards(
    address indexed staker,
    address indexed network,
    address indexed token,
    address vault,
    uint256 amount,
    uint256 firstClaimedReward,
    uint256 rewardsClaimed
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`staker`|`address`|Address of the reward claimant.|
|`network`|`address`|Network whose rewards were claimed.|
|`token`|`address`|ERC20 token distributed to the claimant.|
|`vault`|`address`|Vault that sourced the reward.|
|`amount`|`uint256`|Amount of tokens transferred to the claimant.|
|`firstClaimedReward`|`uint256`|First claimed reward index.|
|`rewardsClaimed`|`uint256`|Number of rewards distributions that were claimed.|

### ClaimOperatorFees
Emitted when operator fees are claimed.


```solidity
event ClaimOperatorFees(
    address indexed operator,
    address indexed network,
    address indexed token,
    address vault,
    uint256 amount,
    uint256 firstClaimedReward,
    uint256 rewardsClaimed
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`operator`|`address`|Operator claiming the fees.|
|`network`|`address`|Network whose operator fees were withdrawn.|
|`token`|`address`|ERC20 token transferred to the operator.|
|`vault`|`address`|Vault that generated the operator fees.|
|`amount`|`uint256`|Amount transferred to the operator.|
|`firstClaimedReward`|`uint256`|First claimed reward index.|
|`rewardsClaimed`|`uint256`|Number of rewards distributions that were claimed.|

### ClaimCuratorFees
Emitted when curator fees are claimed.


```solidity
event ClaimCuratorFees(address indexed vault, address indexed token, uint256 amount);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|Vault whose curator fees were withdrawn.|
|`token`|`address`|ERC20 token claimed by the curator.|
|`amount`|`uint256`|Amount transferred to the curator.|

## Errors
### InsufficientReward
Raised when no reward tokens are received during transfer.


```solidity
error InsufficientReward();
```

### InvalidDelegatorType
Raised when an unsupported delegator type is encountered.


```solidity
error InvalidDelegatorType();
```

### InvalidLastUnclaimedReward
Raised when the provided last unclaimed reward index mismatches storage.


```solidity
error InvalidLastUnclaimedReward();
```

### InvalidRecipient
Raised when the recipient address is zero.


```solidity
error InvalidRecipient();
```

### InvalidRewardTimestamp
Raised when a reward timestamp is invalid for distribution.


```solidity
error InvalidRewardTimestamp();
```

### NoRewardsToClaim
Raised when there are no rewards available to claim.


```solidity
error NoRewardsToClaim();
```

### NotCurator
Raised when the caller is not the registered curator.


```solidity
error NotCurator();
```

### NotNetworkOrMiddleware
Raised when the caller is neither the network nor its middleware.


```solidity
error NotNetworkOrMiddleware();
```

### NotOperator
Raised when the caller is not the operator entitled to fees.


```solidity
error NotOperator();
```

### NotVault
Raised when the address is not a vault.


```solidity
error NotVault();
```

## Structs
### RewardDistribution
Snapshot of a vault reward distribution.


```solidity
struct RewardDistribution {
    uint96 subnetworkId;
    address delegator;
    uint64 delegatorType;
    uint48 timestamp;
    uint256 amount;
    uint256 operatorsFees;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`subnetworkId`|`uint96`|Identifier of the subnetwork the reward targets.|
|`delegator`|`address`|Delegator contract responsible for distribution.|
|`delegatorType`|`uint64`|Type identifier that classifies the delegator.|
|`timestamp`|`uint48`|Block timestamp when the reward was recorded.|
|`amount`|`uint256`|Reward amount allocated to stakers.|
|`operatorsFees`|`uint256`|Portion of the reward reserved for operators.|

### DistributeVaultSnapshotRewardsHints
Hints for distributing vault snapshot rewards.


```solidity
struct DistributeVaultSnapshotRewardsHints {
    bytes activeSharesHint;
    bytes curatorFeeHint;
    bytes operatorsFeeHint;
    bytes totalOperatorNetworkSharesHint;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`activeSharesHint`|`bytes`|Hint for active shares lookup.|
|`curatorFeeHint`|`bytes`|Hint for curator fee lookup.|
|`operatorsFeeHint`|`bytes`|Hint for operators fee lookup.|
|`totalOperatorNetworkSharesHint`|`bytes`|Hint for total operator network shares lookup.|

## Enums
### DelegatorType
The types of the delegator.


```solidity
enum DelegatorType {
    NETWORK_RESTAKE,
    FULL_RESTAKE,
    OPERATOR_SPECIFIC,
    OPERATOR_NETWORK_SPECIFIC
}
```

