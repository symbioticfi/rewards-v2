//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ICumulativeMerkleRewards
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iCumulativeMerkleRewardsAbi = [
  {
    type: "function",
    inputs: [
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
    ],
    name: "balance",
    outputs: [{ name: "amount", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      {
        name: "leaf",
        internalType: "struct ICumulativeMerkleRewards.CumulativeDistributionLeaf",
        type: "tuple",
        components: [
          { name: "token", internalType: "address", type: "address" },
          { name: "rewardeeType", internalType: "uint256", type: "uint256" },
          { name: "amount", internalType: "uint256", type: "uint256" },
          { name: "rewardeeDataHash", internalType: "bytes32", type: "bytes32" },
        ],
      },
      { name: "proof", internalType: "bytes32[]", type: "bytes32[]" },
      { name: "merkleRoot", internalType: "bytes32", type: "bytes32" },
    ],
    name: "claimCumulativeMerkleRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" },
    ],
    name: "claimRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "rewardee", internalType: "address", type: "address" },
      { name: "rewardeeType", internalType: "uint256", type: "uint256" },
    ],
    name: "claimed",
    outputs: [{ name: "amount", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
    ],
    name: "depositCumulativeMerkleRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "network", internalType: "address", type: "address" },
      {
        name: "cumulativeDistribution",
        internalType: "struct ICumulativeMerkleRewards.CumulativeDistribution",
        type: "tuple",
        components: [
          { name: "timestamp", internalType: "uint48", type: "uint48" },
          { name: "merkleRoot", internalType: "bytes32", type: "bytes32" },
        ],
      },
      {
        name: "totalAmounts",
        internalType: "struct ICumulativeMerkleRewards.TokenAmount[]",
        type: "tuple[]",
        components: [
          { name: "chainId", internalType: "uint64", type: "uint64" },
          { name: "token", internalType: "address", type: "address" },
          { name: "amount", internalType: "uint256", type: "uint256" },
        ],
      },
      { name: "protocolSignature", internalType: "bytes", type: "bytes" },
      { name: "rewarderSignature", internalType: "bytes", type: "bytes" },
    ],
    name: "distributeCumulativeMerkleRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "network", internalType: "address", type: "address" },
      { name: "root", internalType: "bytes32", type: "bytes32" },
    ],
    name: "isCumulativeDistributionRoot",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "network", internalType: "address", type: "address" }],
    name: "lastCumulativeDistribution",
    outputs: [
      {
        name: "",
        internalType: "struct ICumulativeMerkleRewards.CumulativeDistribution",
        type: "tuple",
        components: [
          { name: "timestamp", internalType: "uint48", type: "uint48" },
          { name: "merkleRoot", internalType: "bytes32", type: "bytes32" },
        ],
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
    ],
    name: "lastTotalAmount",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [],
    name: "protocol",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "network", internalType: "address", type: "address" }],
    name: "rewarder",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "protocol", internalType: "address", type: "address" }],
    name: "setProtocol",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [{ name: "rewarder", internalType: "address", type: "address" }],
    name: "setRewarder",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
    ],
    name: "withdrawCumulativeMerkleRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "rewardee", internalType: "address", type: "address", indexed: true },
      { name: "network", internalType: "address", type: "address", indexed: true },
      {
        name: "leaf",
        internalType: "struct ICumulativeMerkleRewards.CumulativeDistributionLeaf",
        type: "tuple",
        components: [
          { name: "token", internalType: "address", type: "address" },
          { name: "rewardeeType", internalType: "uint256", type: "uint256" },
          { name: "amount", internalType: "uint256", type: "uint256" },
          { name: "rewardeeDataHash", internalType: "bytes32", type: "bytes32" },
        ],
        indexed: false,
      },
    ],
    name: "ClaimCumulativeMerkleRewards",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "token", internalType: "address", type: "address", indexed: true },
      { name: "amount", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "DepositCumulativeMerkleRewards",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "network", internalType: "address", type: "address", indexed: true },
      {
        name: "cumulativeDistribution",
        internalType: "struct ICumulativeMerkleRewards.CumulativeDistribution",
        type: "tuple",
        components: [
          { name: "timestamp", internalType: "uint48", type: "uint48" },
          { name: "merkleRoot", internalType: "bytes32", type: "bytes32" },
        ],
        indexed: false,
      },
    ],
    name: "DistributeCumulativeMerkleRewards",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [{ name: "protocol", internalType: "address", type: "address", indexed: true }],
    name: "SetProtocol",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "rewarder", internalType: "address", type: "address", indexed: false },
    ],
    name: "SetRewarder",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "token", internalType: "address", type: "address", indexed: true },
      { name: "amount", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "WithdrawCumulativeMerkleRewards",
  },
  { type: "error", inputs: [], name: "InsufficientDeposit" },
  { type: "error", inputs: [], name: "InvalidMerkleProof" },
  { type: "error", inputs: [], name: "InvalidMerkleRoot" },
  { type: "error", inputs: [], name: "InvalidSignature" },
  { type: "error", inputs: [], name: "InvalidTimestamp" },
  { type: "error", inputs: [], name: "InvalidToken" },
  { type: "error", inputs: [], name: "NoCumulativeRewardsToClaim" },
  { type: "error", inputs: [], name: "NotRewarder" },
  { type: "error", inputs: [], name: "RootAlreadySet" },
] as const;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ICuratorRegistry
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iCuratorRegistryAbi = [
  {
    type: "function",
    inputs: [{ name: "vault", internalType: "address", type: "address" }],
    name: "getCurator",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "timestamp", internalType: "uint48", type: "uint48" },
      { name: "hint", internalType: "bytes", type: "bytes" },
    ],
    name: "getCuratorAt",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "curator", internalType: "address", type: "address" },
    ],
    name: "setCurator",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "vault", internalType: "address", type: "address", indexed: true },
      { name: "curator", internalType: "address", type: "address", indexed: true },
    ],
    name: "SetCurator",
  },
  { type: "error", inputs: [], name: "NotAuthorized" },
] as const;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IFeeRegistry
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iFeeRegistryAbi = [
  {
    type: "function",
    inputs: [],
    name: "CURATOR_REGISTRY",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [],
    name: "MAX_FEE",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [],
    name: "MAX_PARTICIPANT_FEE",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "vault", internalType: "address", type: "address" }],
    name: "getCuratorDefaultFee",
    outputs: [{ name: "fee", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "timestamp", internalType: "uint48", type: "uint48" },
      { name: "hint", internalType: "bytes", type: "bytes" },
    ],
    name: "getCuratorDefaultFeeAt",
    outputs: [{ name: "fee", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
    ],
    name: "getCuratorFee",
    outputs: [{ name: "fee", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "timestamp", internalType: "uint48", type: "uint48" },
      { name: "hints", internalType: "bytes", type: "bytes" },
    ],
    name: "getCuratorFeeAt",
    outputs: [{ name: "fee", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
    ],
    name: "getCuratorNetworkFee",
    outputs: [
      { name: "isEnabled", internalType: "bool", type: "bool" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "timestamp", internalType: "uint48", type: "uint48" },
      { name: "hint", internalType: "bytes", type: "bytes" },
    ],
    name: "getCuratorNetworkFeeAt",
    outputs: [
      { name: "isEnabled", internalType: "bool", type: "bool" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "vault", internalType: "address", type: "address" }],
    name: "getOperatorsDefaultFee",
    outputs: [{ name: "fee", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "timestamp", internalType: "uint48", type: "uint48" },
      { name: "hint", internalType: "bytes", type: "bytes" },
    ],
    name: "getOperatorsDefaultFeeAt",
    outputs: [{ name: "fee", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
    ],
    name: "getOperatorsFee",
    outputs: [{ name: "fee", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "timestamp", internalType: "uint48", type: "uint48" },
      { name: "hints", internalType: "bytes", type: "bytes" },
    ],
    name: "getOperatorsFeeAt",
    outputs: [{ name: "fee", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
    ],
    name: "getOperatorsNetworkFee",
    outputs: [
      { name: "isEnabled", internalType: "bool", type: "bool" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "timestamp", internalType: "uint48", type: "uint48" },
      { name: "hint", internalType: "bytes", type: "bytes" },
    ],
    name: "getOperatorsNetworkFeeAt",
    outputs: [
      { name: "isEnabled", internalType: "bool", type: "bool" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "id", internalType: "bytes32", type: "bytes32" }],
    name: "getProtocolFee",
    outputs: [
      { name: "isEnabled", internalType: "bool", type: "bool" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    name: "setCuratorFee",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "enable", internalType: "bool", type: "bool" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    name: "setCuratorNetworkFee",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    name: "setOperatorsFee",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "enable", internalType: "bool", type: "bool" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    name: "setOperatorsNetworkFee",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "id", internalType: "bytes32", type: "bytes32" },
      { name: "enable", internalType: "bool", type: "bool" },
      { name: "fee", internalType: "uint256", type: "uint256" },
    ],
    name: "setProtocolFee",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "vault", internalType: "address", type: "address", indexed: true },
      { name: "fee", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "SetCuratorFee",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "vault", internalType: "address", type: "address", indexed: true },
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "enable", internalType: "bool", type: "bool", indexed: false },
      { name: "fee", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "SetCuratorNetworkFee",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "vault", internalType: "address", type: "address", indexed: true },
      { name: "fee", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "SetOperatorsFee",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "vault", internalType: "address", type: "address", indexed: true },
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "enable", internalType: "bool", type: "bool", indexed: false },
      { name: "fee", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "SetOperatorsNetworkFee",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "id", internalType: "bytes32", type: "bytes32", indexed: true },
      { name: "enable", internalType: "bool", type: "bool", indexed: false },
      { name: "fee", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "SetProtocolFee",
  },
  { type: "error", inputs: [], name: "FeeTooHigh" },
  { type: "error", inputs: [], name: "NotCurator" },
] as const;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IOzEIP712
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iOzEip712Abi = [
  {
    type: "function",
    inputs: [],
    name: "eip712Domain",
    outputs: [
      { name: "fields", internalType: "bytes1", type: "bytes1" },
      { name: "name", internalType: "string", type: "string" },
      { name: "version", internalType: "string", type: "string" },
      { name: "chainId", internalType: "uint256", type: "uint256" },
      { name: "verifyingContract", internalType: "address", type: "address" },
      { name: "salt", internalType: "bytes32", type: "bytes32" },
      { name: "extensions", internalType: "uint256[]", type: "uint256[]" },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "structHash", internalType: "bytes32", type: "bytes32" }],
    name: "hashTypedDataV4",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "structHash", internalType: "bytes32", type: "bytes32" }],
    name: "hashTypedDataV4CrossChain",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view",
  },
  { type: "event", anonymous: false, inputs: [], name: "EIP712DomainChanged" },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "name", internalType: "string", type: "string", indexed: false },
      { name: "version", internalType: "string", type: "string", indexed: false },
    ],
    name: "InitEIP712",
  },
] as const;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IProtocolFees
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iProtocolFeesAbi = [
  {
    type: "function",
    inputs: [],
    name: "FEE_REGISTRY",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [],
    name: "MAX_FEE",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
    ],
    name: "claimProtocolFees",
    outputs: [{ name: "fees", internalType: "uint256", type: "uint256" }],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "rewardsType", internalType: "uint64", type: "uint64" },
      { name: "network", internalType: "address", type: "address" },
      { name: "distributionAmount", internalType: "uint256", type: "uint256" },
    ],
    name: "distributionToTotalAmount",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "rewardsType", internalType: "uint64", type: "uint64" },
      { name: "network", internalType: "address", type: "address" },
    ],
    name: "protocolFee",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [{ name: "token", internalType: "address", type: "address" }],
    name: "protocolFees",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "rewardsType", internalType: "uint64", type: "uint64" },
      { name: "network", internalType: "address", type: "address" },
      { name: "totalDistributionAmount", internalType: "uint256", type: "uint256" },
    ],
    name: "totalToDistributionAmount",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "token", internalType: "address", type: "address", indexed: true },
      { name: "fees", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "ClaimProtocolFee",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "rewardsType", internalType: "uint64", type: "uint64", indexed: true },
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "token", internalType: "address", type: "address", indexed: true },
      { name: "fees", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "DeductProtocolFee",
  },
  { type: "error", inputs: [], name: "InsufficientClaimableFees" },
] as const;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IRewards
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iRewardsAbi = [
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" },
    ],
    name: "claimRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  { type: "error", inputs: [], name: "InvalidRewardType" },
] as const;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IRewardsBase
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iRewardsBaseAbi = [
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" },
    ],
    name: "claimRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
] as const;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IVaultSnapshotRewards
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iVaultSnapshotRewardsAbi = [
  {
    type: "function",
    inputs: [],
    name: "CURATOR_REGISTRY",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [],
    name: "NETWORK_MIDDLEWARE_SERVICE",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [],
    name: "NETWORK_REGISTRY",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [],
    name: "VAULT_FACTORY",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "vault", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
    ],
    name: "claimCuratorFees",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "vault", internalType: "address", type: "address" },
      { name: "lastUnclaimedRewards", internalType: "uint256", type: "uint256" },
      { name: "firstRewardToClaim", internalType: "uint256", type: "uint256" },
      { name: "rewardsToClaim", internalType: "uint256", type: "uint256" },
      { name: "extraData", internalType: "bytes", type: "bytes" },
    ],
    name: "claimOperatorFees",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" },
    ],
    name: "claimRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "recipient", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "vault", internalType: "address", type: "address" },
      { name: "lastUnclaimedRewards", internalType: "uint256", type: "uint256" },
      { name: "firstRewardToClaim", internalType: "uint256", type: "uint256" },
      { name: "rewardsToClaim", internalType: "uint256", type: "uint256" },
      { name: "activeSharesOfHints", internalType: "bytes[]", type: "bytes[]" },
    ],
    name: "claimVaultSnapshotRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
    ],
    name: "curatorFees",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "subnetwork", internalType: "bytes32", type: "bytes32" },
      { name: "token", internalType: "address", type: "address" },
      { name: "vault", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "timestamp", internalType: "uint48", type: "uint48" },
      {
        name: "hints",
        internalType: "struct IVaultSnapshotRewards.DistributeVaultSnapshotRewardsHints",
        type: "tuple",
        components: [
          { name: "activeSharesHint", internalType: "bytes", type: "bytes" },
          { name: "curatorFeeHint", internalType: "bytes", type: "bytes" },
          { name: "operatorsFeeHint", internalType: "bytes", type: "bytes" },
        ],
      },
    ],
    name: "distributeVaultSnapshotRewards",
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
    ],
    name: "lastUnclaimedOperatorReward",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
    ],
    name: "lastUnclaimedReward",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
      { name: "index", internalType: "uint256", type: "uint256" },
    ],
    name: "rewards",
    outputs: [
      {
        name: "",
        internalType: "struct IVaultSnapshotRewards.RewardDistribution",
        type: "tuple",
        components: [
          { name: "subnetworkId", internalType: "uint96", type: "uint96" },
          { name: "delegator", internalType: "address", type: "address" },
          { name: "delegatorType", internalType: "uint64", type: "uint64" },
          { name: "timestamp", internalType: "uint48", type: "uint48" },
          { name: "amount", internalType: "uint256", type: "uint256" },
          { name: "operatorsFees", internalType: "uint256", type: "uint256" },
        ],
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    inputs: [
      { name: "vault", internalType: "address", type: "address" },
      { name: "network", internalType: "address", type: "address" },
      { name: "token", internalType: "address", type: "address" },
    ],
    name: "rewardsLength",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "vault", internalType: "address", type: "address", indexed: true },
      { name: "token", internalType: "address", type: "address", indexed: true },
      { name: "amount", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "ClaimCuratorFees",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "operator", internalType: "address", type: "address", indexed: true },
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "token", internalType: "address", type: "address", indexed: true },
      { name: "vault", internalType: "address", type: "address", indexed: false },
      { name: "amount", internalType: "uint256", type: "uint256", indexed: false },
      { name: "firstClaimedReward", internalType: "uint256", type: "uint256", indexed: false },
      { name: "rewardsClaimed", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "ClaimOperatorFees",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "staker", internalType: "address", type: "address", indexed: true },
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "token", internalType: "address", type: "address", indexed: true },
      { name: "vault", internalType: "address", type: "address", indexed: false },
      { name: "amount", internalType: "uint256", type: "uint256", indexed: false },
      { name: "firstClaimedReward", internalType: "uint256", type: "uint256", indexed: false },
      { name: "rewardsClaimed", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "ClaimVaultSnapshotRewards",
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "network", internalType: "address", type: "address", indexed: true },
      { name: "token", internalType: "address", type: "address", indexed: true },
      { name: "vault", internalType: "address", type: "address", indexed: true },
      { name: "subnetworkId", internalType: "uint96", type: "uint96", indexed: false },
      { name: "timestamp", internalType: "uint48", type: "uint48", indexed: false },
      { name: "amount", internalType: "uint256", type: "uint256", indexed: false },
      { name: "curatorFees", internalType: "uint256", type: "uint256", indexed: false },
      { name: "operatorsFees", internalType: "uint256", type: "uint256", indexed: false },
    ],
    name: "DistributeVaultSnapshotRewards",
  },
  { type: "error", inputs: [], name: "InsufficientReward" },
  { type: "error", inputs: [], name: "InvalidDelegatorType" },
  { type: "error", inputs: [], name: "InvalidLastUnclaimedReward" },
  { type: "error", inputs: [], name: "InvalidRecipient" },
  { type: "error", inputs: [], name: "InvalidRewardTimestamp" },
  { type: "error", inputs: [], name: "InvalidVault" },
  { type: "error", inputs: [], name: "NoRewardsToClaim" },
  { type: "error", inputs: [], name: "NotCurator" },
  { type: "error", inputs: [], name: "NotNetworkOrMiddleware" },
  { type: "error", inputs: [], name: "NotOperator" },
] as const;
