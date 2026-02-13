**[Symbiotic Protocol](https://symbiotic.fi) is an extremely flexible and permissionless shared security system.**

This repository contains Symbiotic Rewards V2 smart contracts.

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/symbioticfi/rewards-v2)
[![codecov](https://codecov.io/github/symbioticfi/rewards-v2/graph/badge.svg?token=B78TWDVARN)](https://codecov.io/github/symbioticfi/rewards-v2)

## Overview

**3 singleton-style smart contracts per chain** with Symbiotic Core contracts

- **Rewards** - a single rewards contract to, currently, combine 2 types of rewards:
  - **Vault Snapshot Rewards**
    - It provides a reward distribution using an on-chain state. Hence, it doesn’t require any off-chain part to exist, which can be useful for purely on-chain protocols.
    - However, it doesn’t provide the "cumulative" characteristic for rewards. Also, its distribution process needs a separate distribution call for each vault.
    - It uses a snapshot timestamp to retrieve the necessary data for the distribution (deposits, fees, etc.).

  - **Cumulative Merkle Rewards**
    - It works using Merkle Trees, which allow for various complex schemas of reward distribution while enabling the distribution of rewards across all vaults, operators, and other entities in a single, low-cost transaction. Additionally, it allows for cumulative rewards, meaning that claim costs will remain low and near constant, regardless of the number of distributions.
    - Due to the need for Merkle Trees construction, it needs an off-chain party to process it

- **CuratorRegistry** - a registry to map vaults to their curators (fee receivers)
  - Initially, only the vault’s `owner` can set a curator
  - Once set, only the curator can set another curator for the vault instead of him
- **FeeRegistry** - fee registry for operators and curators
  - Curators are responsible for setting fee percentages for themselves for each vault
    - Also, it is possible to set the curator fee percentage applied depending on the distributing network
  - Curators are responsible for setting fee percentages for all operators (e.g., 5% for all operators) for each vault (later, during rewards distribution, the fees are split between operators pro rata according to their contribution shares)
    - Also, it is possible to set the operators’ fee percentages applied depending on the distributing network
  - Initially, all fees are set to zero, so manual configuration is needed for each vault

## Documentation

- [What are Rewards?](https://docs.symbiotic.fi/modules/extensions/rewards)
- [How to distribute? (for Networks)](https://docs.symbiotic.fi/integrate/networks/rewards)
- [How to claim? (for Operators)](https://docs.symbiotic.fi/integrate/operators/claim-rewards)
- [How to configure and claim fees? (for Curators)](https://docs.symbiotic.fi/integrate/curators/registry-and-fees)

## Usage

### Dependencies

- Git ([installation](https://git-scm.com/downloads))
- Foundry ([installation](https://getfoundry.sh/introduction/installation/))

### Prerequisites

**Clone the repository**

```
git clone --recurse-submodules https://github.com/symbioticfi/rewards-v2.git
```

### Build, Test, and Format

```
forge build
forge test
forge fmt
```

**Configure environment**

Create `.env` based on the template:

```
ETH_RPC_URL=
ETHERSCAN_API_KEY=
```

## Security

Security audits are aggregated in `./audits`.
