# IRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/4555481c4419ee7ee9503a885d502652a941f620/src/interfaces/IRewards.sol)

**Inherits:**
[IRewardsBase](/src/interfaces/IRewardsBase.sol/interface.IRewardsBase.md)

**Title:**
IRewards

Interface for the Rewards contract.


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

