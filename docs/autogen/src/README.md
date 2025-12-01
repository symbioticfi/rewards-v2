**[Symbiotic Protocol](https://symbiotic.fi) is an extremely flexible and permissionless shared security system.**

This repository contains Symbiotic Rewards V2 smart contracts.

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/symbioticfi/rewards-v2)
[![codecov](https://codecov.io/github/symbioticfi/rewards-v2/graph/badge.svg?token=B78TWDVARN)](https://codecov.io/github/symbioticfi/rewards-v2)

## Rewards V2 overview

Symbiotic introduces:

- **Full outsourcing of rewards construction and commitment** through Symbiotic Rewards Service
- **3 new singleton-style smart contracts per chain** with Symbiotic Core contracts

  - **Rewards** - a single rewards contract to, currently, combine 2 types of rewards:

    **Cumulative Merkle Rewards vs Vault Snapshot Rewards**

    - **Cumulative Merkle Rewards**
      - It works using Merkle Trees, which allow for various complex schemas of reward distribution while enabling the distribution of rewards across all vaults, operators, and other entities in a single, low-cost transaction. Additionally, it allows for cumulative rewards, meaning that claim costs will remain low and near constant, regardless of the number of distributions.
      - Due to the need for Merkle Trees construction, it needs an off-chain party to process it
      - Symbiotic supports distributing rewards either:
        - by using a snapshot timestamp to fetch all stake data (useful, e.g., for epoch-driven systems utilising capture timestamps as snapshot timestamps)
        - by using cumulative data across a specified time range (useful for more continuous systems, where, e.g., the stake is utilised at any time point).
    - **Vault Snapshot Rewards**
      - It provides a reward distribution using an on-chain state. Hence, it doesn’t require any off-chain part to exist, which can be useful for purely on-chain protocols.
      - However, it doesn’t provide the "cumulative" characteristic for rewards. Also, its distribution process needs a separate distribution call for each vault.
      - It uses a snapshot timestamp to retrieve the necessary data for the distribution (deposits, fees, etc.).

  - **CuratorRegistry** - a registry to map vaults to their curators (fee receivers)
    - Initially, only the vault’s `owner` can set a curator
    - Once set, only the curator can set another curator for the vault instead of him
  - **FeeRegistry** - fee registry for operators and curators
    - Curators are responsible for setting fee percentages for themselves for each vault
      - Also, it is possible to set the curator fee percentage applied depending on the distributing network
    - Curators are responsible for setting fee percentages for all operators (e.g., 5% for all operators) for each vault (later, during rewards distribution, the fees are split between operators pro rata according to their contribution shares)
      - Also, it is possible to set the operators’ fee percentages applied depending on the distributing network
    - Initially, all fees are set to zero, so manual configuration is needed for each vault

- **Optimised number of transactions** needed for claiming by users and for distribution by networks
- **Symbiotic CLI for management-like operations** and fees claiming for operators and curators
- **New Symbiotic UI page for networks** to simplify rewards distribution
- **The distribution validation tooling** to remove any additional trust assumption to Symbiotic team

### What benefits does it provide?

- **For Networks**
  - **Shorten the development timeline of rewards integration.**
    - For a rewards airdrop, the process can be completed in minutes using only the Symbiotic UI.
    - For continuous rewards distribution, validators just issue lightweight API requests that respect network’s consensus rules.
  - **Reduce the rewards maintenance costs almost to zero.** Now nodes or the rewards distributor only need to perform lightweight API requests to the Symbiotic Rewards Service.
  - **Reward across multiple chains.** Allocate rewards to stake sourced from multiple chains.
- **For Stakers**
  - **Receive rewards sooner.** Faster network integrations reduce the lead time before rewards start landing in staker wallets.
  - **Decrease gas costs for rewards claiming.** Significantly reduce claim gas usage through:
    - batching separate distributions into one
    - batching separate vaults’ claims into one
  - At the moment (17.09.2025), the cost of one claim for a network on Ethereum is about $0.17.
- **For Curators**
  - **Receive rewards sooner.** Faster network integrations shorten the time before curator fees become claimable.
  - **Configurable fees.** Configure your and your operators' fees through **Symbiotic CLI** (using only a single contract).
- **For Operators**
  - **Receive rewards sooner.** Faster network integrations shorten the time before operator fees become claimable.

## Documentation

- [What are Rewards?](https://docs.symbiotic.fi/modules/extensions/rewards)

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
