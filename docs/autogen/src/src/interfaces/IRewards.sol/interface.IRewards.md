# IRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/1a02678d8da2496e9aa689307a72bcc819979a57/src/interfaces/IRewards.sol)

Interface for the Rewards contract.


## Functions
### claimRewards

Claims rewards via a unified entrypoint.

The function routes to the appropriate reward type based on the first 8 bytes (uint64).
of the payload that identify the rewards type. Remaining bytes are reward-specific data.


```solidity
function claimRewards(address recipient, address token, bytes calldata data) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`token`|`address`|The token address.|
|`data`|`bytes`|The encoded claim data containing reward type and specific data.|


## Errors
### InvalidRewardType
Raised when the supplied reward type identifier is not supported.


```solidity
error InvalidRewardType();
```

## Enums
### RewardsType
Enumerates supported reward mechanisms.

Used to route unified reward claims.


```solidity
enum RewardsType {
    VAULT_SNAPSHOT,
    CUMULATIVE_MERKLE
}
```

