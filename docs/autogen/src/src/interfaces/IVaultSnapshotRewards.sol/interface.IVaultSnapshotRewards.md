# IVaultSnapshotRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/1a02678d8da2496e9aa689307a72bcc819979a57/src/interfaces/IVaultSnapshotRewards.sol)

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


### curatorFee

Returns the curator fee for a vault and token.


```solidity
function curatorFee(address vault, address token) external view returns (uint256);
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
|`maxRewards`|`uint256`|The maximum number of rewards to process.|
|`activeSharesOfHints`|`bytes[]`|Hints for active shares calculation.|


### claimCuratorFee

Claims the curator fee (only curator).


```solidity
function claimCuratorFee(address recipient, address vault, address token) external;
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
|`maxRewards`|`uint256`|The maximum number of rewards to process.|
|`extraData`|`bytes`|Additional data for operator type-specific logic.|


### claimRewards

Claims rewards via the vault snapshot path.


```solidity
function claimRewards(address recipient, address token, bytes calldata data) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`token`|`address`|The token address.|
|`data`|`bytes`|The encoded claim data.|


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
    uint256 curatorFee,
    uint256 operatorsFee
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
|`curatorFee`|`uint256`|Portion of the reward allocated to the curator.|
|`operatorsFee`|`uint256`|Portion of the reward allocated to operators.|

### ClaimVaultSnapshotRewards
Emitted when a staker claims vault snapshot rewards.


```solidity
event ClaimVaultSnapshotRewards(
    address indexed staker,
    address indexed network,
    address indexed token,
    address vault,
    uint256 amount,
    uint256 lastUnclaimedIndex
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
|`lastUnclaimedIndex`|`uint256`|Index up to which rewards were claimed.|

### ClaimCuratorFee
Emitted when curator fees are claimed.


```solidity
event ClaimCuratorFee(address indexed vault, address indexed token, uint256 amount);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|Vault whose curator fee was withdrawn.|
|`token`|`address`|ERC20 token claimed by the curator.|
|`amount`|`uint256`|Amount transferred to the curator.|

### ClaimOperatorFee
Emitted when operator fees are claimed.


```solidity
event ClaimOperatorFee(
    address indexed operator,
    address indexed network,
    address indexed token,
    address vault,
    uint256 amount,
    uint256 lastUnclaimedIndex
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
|`lastUnclaimedIndex`|`uint256`|Index up to which operator rewards were claimed.|

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

### InvalidHintsLength
Raised when the supplied hints data does not match expectations.


```solidity
error InvalidHintsLength();
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

### InvalidVault
Raised when the provided vault is not supported.


```solidity
error InvalidVault();
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
    uint256 operatorsFee;
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
|`operatorsFee`|`uint256`|Portion of the reward reserved for operators.|

