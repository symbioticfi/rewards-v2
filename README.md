**[Symbiotic Protocol](https://symbiotic.fi) is an extremely flexible and permissionless shared security system.**

This repository contains Symbiotic Rewards V2 smart contracts.

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/symbioticfi/rewards-v2)
[![codecov](https://codecov.io/github/symbioticfi/rewards-v2/graph/badge.svg?token=9F5PUM6HB0)](https://codecov.io/github/symbioticfi/rewards-v2)

## Usage

### Env

Create `.env` file using a template:

```
ETH_RPC_URL=
ETH_RPC_URL_HOLESKY=
ETHERSCAN_API_KEY=
```

\* ETH_RPC_URL is optional.<br/>\* ETH_RPC_URL_HOLESKY is optional.<br/>\* ETHERSCAN_API_KEY is optional.

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Format

```shell
forge fmt
```

### Gas Snapshots

```shell
forge snapshot
```
