# IRewardsBase
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/7420a9b04d75b1dec8c5eb0720d16cf567ba64f6/src/interfaces/IRewardsBase.sol)

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


