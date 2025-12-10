# IRewardsBase
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/4555481c4419ee7ee9503a885d502652a941f620/src/interfaces/IRewardsBase.sol)

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


