# IRewardsBase
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/3cbad0f2cc56619be51e1c9d028be930315a0a61/src/interfaces/IRewardsBase.sol)

**Title:**
IRewardsBase

Base interface for any Rewards contract.


## Functions
### claimRewards

Claims rewards via a unified entrypoint.


```solidity
function claimRewards(address recipient, address token, bytes calldata data) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|The recipient address.|
|`token`|`address`|The token address.|
|`data`|`bytes`|The encoded claim data containing reward type and specific data.|


