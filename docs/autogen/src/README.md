**[Symbiotic Protocol](https://symbiotic.fi) is an extremely flexible and permissionless shared security system.**

This repository contains Symbiotic Rewards V2 smart contracts.

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/symbioticfi/rewards-v2)
[![codecov](https://codecov.io/github/symbioticfi/rewards-v2/graph/badge.svg?token=B78TWDVARN)](https://codecov.io/github/symbioticfi/rewards-v2)

## Documentation

- [What are Rewards?](https://docs.symbiotic.fi/modules/extensions/rewards)

## Usage

### Dependencies

- Git ([installation](https://git-scm.com/downloads))
- Foundry ([installation](https://getfoundry.sh/introduction/installation/))

### Prerequisites

**Clone the repository**

```
git clone --recurse-submodules https://github.com/symbioticfi/core.git
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
