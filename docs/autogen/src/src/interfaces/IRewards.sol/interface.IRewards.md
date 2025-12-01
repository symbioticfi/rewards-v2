# IRewards
[Git Source](https://github.com/symbioticfi/rewards-v2/blob/7420a9b04d75b1dec8c5eb0720d16cf567ba64f6/src/interfaces/IRewards.sol)

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

