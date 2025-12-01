// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package rewardsv2contracts

import (
	"errors"
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = errors.New
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
	_ = abi.ConvertType
)

// ICumulativeMerkleRewardsCumulativeDistribution is an auto generated low-level Go binding around an user-defined struct.
type ICumulativeMerkleRewardsCumulativeDistribution struct {
	Timestamp  *big.Int
	MerkleRoot [32]byte
}

// ICumulativeMerkleRewardsCumulativeDistributionLeaf is an auto generated low-level Go binding around an user-defined struct.
type ICumulativeMerkleRewardsCumulativeDistributionLeaf struct {
	Token            common.Address
	RewardeeType     *big.Int
	Amount           *big.Int
	RewardeeDataHash [32]byte
}

// ICumulativeMerkleRewardsTokenAmount is an auto generated low-level Go binding around an user-defined struct.
type ICumulativeMerkleRewardsTokenAmount struct {
	ChainId uint64
	Token   common.Address
	Amount  *big.Int
}

// ICumulativeMerkleRewardsMetaData contains all meta data concerning the ICumulativeMerkleRewards contract.
var ICumulativeMerkleRewardsMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"balance\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"claimCumulativeMerkleRewards\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"leaf\",\"type\":\"tuple\",\"internalType\":\"structICumulativeMerkleRewards.CumulativeDistributionLeaf\",\"components\":[{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"rewardeeType\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"rewardeeDataHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"name\":\"proof\",\"type\":\"bytes32[]\",\"internalType\":\"bytes32[]\"},{\"name\":\"merkleRoot\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"claimRewards\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"claimed\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"rewardee\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"rewardeeType\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"depositCumulativeMerkleRewards\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"distributeCumulativeMerkleRewards\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"cumulativeDistribution\",\"type\":\"tuple\",\"internalType\":\"structICumulativeMerkleRewards.CumulativeDistribution\",\"components\":[{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"merkleRoot\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"name\":\"totalAmounts\",\"type\":\"tuple[]\",\"internalType\":\"structICumulativeMerkleRewards.TokenAmount[]\",\"components\":[{\"name\":\"chainId\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"name\":\"ownerSignature\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"rewarderSignature\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"isCumulativeDistributionRoot\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"root\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"lastCumulativeDistribution\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structICumulativeMerkleRewards.CumulativeDistribution\",\"components\":[{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"merkleRoot\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"lastTotalAmount\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"protocol\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"rewarder\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"setProtocol\",\"inputs\":[{\"name\":\"protocol\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setRewarder\",\"inputs\":[{\"name\":\"rewarder\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"withdrawCumulativeMerkleRewards\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"ClaimCumulativeMerkleRewards\",\"inputs\":[{\"name\":\"rewardee\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"leaf\",\"type\":\"tuple\",\"indexed\":false,\"internalType\":\"structICumulativeMerkleRewards.CumulativeDistributionLeaf\",\"components\":[{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"rewardeeType\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"rewardeeDataHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"DepositCumulativeMerkleRewards\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"DistributeCumulativeMerkleRewards\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"cumulativeDistribution\",\"type\":\"tuple\",\"indexed\":false,\"internalType\":\"structICumulativeMerkleRewards.CumulativeDistribution\",\"components\":[{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"merkleRoot\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SetProtocol\",\"inputs\":[{\"name\":\"protocol\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SetRewarder\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"rewarder\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"WithdrawCumulativeMerkleRewards\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"InsufficientDeposit\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidMerkleProof\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidMerkleRoot\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidSignature\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidTimestamp\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidToken\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoCumulativeRewardsToClaim\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotRewarder\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"RootAlreadySet\",\"inputs\":[]}]",
}

// ICumulativeMerkleRewardsABI is the input ABI used to generate the binding from.
// Deprecated: Use ICumulativeMerkleRewardsMetaData.ABI instead.
var ICumulativeMerkleRewardsABI = ICumulativeMerkleRewardsMetaData.ABI

// ICumulativeMerkleRewards is an auto generated Go binding around an Ethereum contract.
type ICumulativeMerkleRewards struct {
	ICumulativeMerkleRewardsCaller     // Read-only binding to the contract
	ICumulativeMerkleRewardsTransactor // Write-only binding to the contract
	ICumulativeMerkleRewardsFilterer   // Log filterer for contract events
}

// ICumulativeMerkleRewardsCaller is an auto generated read-only Go binding around an Ethereum contract.
type ICumulativeMerkleRewardsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ICumulativeMerkleRewardsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ICumulativeMerkleRewardsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ICumulativeMerkleRewardsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ICumulativeMerkleRewardsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ICumulativeMerkleRewardsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ICumulativeMerkleRewardsSession struct {
	Contract     *ICumulativeMerkleRewards // Generic contract binding to set the session for
	CallOpts     bind.CallOpts             // Call options to use throughout this session
	TransactOpts bind.TransactOpts         // Transaction auth options to use throughout this session
}

// ICumulativeMerkleRewardsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ICumulativeMerkleRewardsCallerSession struct {
	Contract *ICumulativeMerkleRewardsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts                   // Call options to use throughout this session
}

// ICumulativeMerkleRewardsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ICumulativeMerkleRewardsTransactorSession struct {
	Contract     *ICumulativeMerkleRewardsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts                   // Transaction auth options to use throughout this session
}

// ICumulativeMerkleRewardsRaw is an auto generated low-level Go binding around an Ethereum contract.
type ICumulativeMerkleRewardsRaw struct {
	Contract *ICumulativeMerkleRewards // Generic contract binding to access the raw methods on
}

// ICumulativeMerkleRewardsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ICumulativeMerkleRewardsCallerRaw struct {
	Contract *ICumulativeMerkleRewardsCaller // Generic read-only contract binding to access the raw methods on
}

// ICumulativeMerkleRewardsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ICumulativeMerkleRewardsTransactorRaw struct {
	Contract *ICumulativeMerkleRewardsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewICumulativeMerkleRewards creates a new instance of ICumulativeMerkleRewards, bound to a specific deployed contract.
func NewICumulativeMerkleRewards(address common.Address, backend bind.ContractBackend) (*ICumulativeMerkleRewards, error) {
	contract, err := bindICumulativeMerkleRewards(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewards{ICumulativeMerkleRewardsCaller: ICumulativeMerkleRewardsCaller{contract: contract}, ICumulativeMerkleRewardsTransactor: ICumulativeMerkleRewardsTransactor{contract: contract}, ICumulativeMerkleRewardsFilterer: ICumulativeMerkleRewardsFilterer{contract: contract}}, nil
}

// NewICumulativeMerkleRewardsCaller creates a new read-only instance of ICumulativeMerkleRewards, bound to a specific deployed contract.
func NewICumulativeMerkleRewardsCaller(address common.Address, caller bind.ContractCaller) (*ICumulativeMerkleRewardsCaller, error) {
	contract, err := bindICumulativeMerkleRewards(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsCaller{contract: contract}, nil
}

// NewICumulativeMerkleRewardsTransactor creates a new write-only instance of ICumulativeMerkleRewards, bound to a specific deployed contract.
func NewICumulativeMerkleRewardsTransactor(address common.Address, transactor bind.ContractTransactor) (*ICumulativeMerkleRewardsTransactor, error) {
	contract, err := bindICumulativeMerkleRewards(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsTransactor{contract: contract}, nil
}

// NewICumulativeMerkleRewardsFilterer creates a new log filterer instance of ICumulativeMerkleRewards, bound to a specific deployed contract.
func NewICumulativeMerkleRewardsFilterer(address common.Address, filterer bind.ContractFilterer) (*ICumulativeMerkleRewardsFilterer, error) {
	contract, err := bindICumulativeMerkleRewards(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsFilterer{contract: contract}, nil
}

// bindICumulativeMerkleRewards binds a generic wrapper to an already deployed contract.
func bindICumulativeMerkleRewards(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := ICumulativeMerkleRewardsMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ICumulativeMerkleRewards.Contract.ICumulativeMerkleRewardsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.ICumulativeMerkleRewardsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.ICumulativeMerkleRewardsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ICumulativeMerkleRewards.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.contract.Transact(opts, method, params...)
}

// Balance is a free data retrieval call binding the contract method 0xb203bb99.
//
// Solidity: function balance(address network, address token) view returns(uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCaller) Balance(opts *bind.CallOpts, network common.Address, token common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ICumulativeMerkleRewards.contract.Call(opts, &out, "balance", network, token)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Balance is a free data retrieval call binding the contract method 0xb203bb99.
//
// Solidity: function balance(address network, address token) view returns(uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) Balance(network common.Address, token common.Address) (*big.Int, error) {
	return _ICumulativeMerkleRewards.Contract.Balance(&_ICumulativeMerkleRewards.CallOpts, network, token)
}

// Balance is a free data retrieval call binding the contract method 0xb203bb99.
//
// Solidity: function balance(address network, address token) view returns(uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCallerSession) Balance(network common.Address, token common.Address) (*big.Int, error) {
	return _ICumulativeMerkleRewards.Contract.Balance(&_ICumulativeMerkleRewards.CallOpts, network, token)
}

// Claimed is a free data retrieval call binding the contract method 0xb9c88d0e.
//
// Solidity: function claimed(address network, address token, address rewardee, uint256 rewardeeType) view returns(uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCaller) Claimed(opts *bind.CallOpts, network common.Address, token common.Address, rewardee common.Address, rewardeeType *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ICumulativeMerkleRewards.contract.Call(opts, &out, "claimed", network, token, rewardee, rewardeeType)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Claimed is a free data retrieval call binding the contract method 0xb9c88d0e.
//
// Solidity: function claimed(address network, address token, address rewardee, uint256 rewardeeType) view returns(uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) Claimed(network common.Address, token common.Address, rewardee common.Address, rewardeeType *big.Int) (*big.Int, error) {
	return _ICumulativeMerkleRewards.Contract.Claimed(&_ICumulativeMerkleRewards.CallOpts, network, token, rewardee, rewardeeType)
}

// Claimed is a free data retrieval call binding the contract method 0xb9c88d0e.
//
// Solidity: function claimed(address network, address token, address rewardee, uint256 rewardeeType) view returns(uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCallerSession) Claimed(network common.Address, token common.Address, rewardee common.Address, rewardeeType *big.Int) (*big.Int, error) {
	return _ICumulativeMerkleRewards.Contract.Claimed(&_ICumulativeMerkleRewards.CallOpts, network, token, rewardee, rewardeeType)
}

// IsCumulativeDistributionRoot is a free data retrieval call binding the contract method 0xe0ac9d0f.
//
// Solidity: function isCumulativeDistributionRoot(address network, bytes32 root) view returns(bool)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCaller) IsCumulativeDistributionRoot(opts *bind.CallOpts, network common.Address, root [32]byte) (bool, error) {
	var out []interface{}
	err := _ICumulativeMerkleRewards.contract.Call(opts, &out, "isCumulativeDistributionRoot", network, root)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsCumulativeDistributionRoot is a free data retrieval call binding the contract method 0xe0ac9d0f.
//
// Solidity: function isCumulativeDistributionRoot(address network, bytes32 root) view returns(bool)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) IsCumulativeDistributionRoot(network common.Address, root [32]byte) (bool, error) {
	return _ICumulativeMerkleRewards.Contract.IsCumulativeDistributionRoot(&_ICumulativeMerkleRewards.CallOpts, network, root)
}

// IsCumulativeDistributionRoot is a free data retrieval call binding the contract method 0xe0ac9d0f.
//
// Solidity: function isCumulativeDistributionRoot(address network, bytes32 root) view returns(bool)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCallerSession) IsCumulativeDistributionRoot(network common.Address, root [32]byte) (bool, error) {
	return _ICumulativeMerkleRewards.Contract.IsCumulativeDistributionRoot(&_ICumulativeMerkleRewards.CallOpts, network, root)
}

// LastCumulativeDistribution is a free data retrieval call binding the contract method 0x06677049.
//
// Solidity: function lastCumulativeDistribution(address network) view returns((uint48,bytes32))
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCaller) LastCumulativeDistribution(opts *bind.CallOpts, network common.Address) (ICumulativeMerkleRewardsCumulativeDistribution, error) {
	var out []interface{}
	err := _ICumulativeMerkleRewards.contract.Call(opts, &out, "lastCumulativeDistribution", network)

	if err != nil {
		return *new(ICumulativeMerkleRewardsCumulativeDistribution), err
	}

	out0 := *abi.ConvertType(out[0], new(ICumulativeMerkleRewardsCumulativeDistribution)).(*ICumulativeMerkleRewardsCumulativeDistribution)

	return out0, err

}

// LastCumulativeDistribution is a free data retrieval call binding the contract method 0x06677049.
//
// Solidity: function lastCumulativeDistribution(address network) view returns((uint48,bytes32))
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) LastCumulativeDistribution(network common.Address) (ICumulativeMerkleRewardsCumulativeDistribution, error) {
	return _ICumulativeMerkleRewards.Contract.LastCumulativeDistribution(&_ICumulativeMerkleRewards.CallOpts, network)
}

// LastCumulativeDistribution is a free data retrieval call binding the contract method 0x06677049.
//
// Solidity: function lastCumulativeDistribution(address network) view returns((uint48,bytes32))
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCallerSession) LastCumulativeDistribution(network common.Address) (ICumulativeMerkleRewardsCumulativeDistribution, error) {
	return _ICumulativeMerkleRewards.Contract.LastCumulativeDistribution(&_ICumulativeMerkleRewards.CallOpts, network)
}

// LastTotalAmount is a free data retrieval call binding the contract method 0xd35e10bf.
//
// Solidity: function lastTotalAmount(address network, address token) view returns(uint256)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCaller) LastTotalAmount(opts *bind.CallOpts, network common.Address, token common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ICumulativeMerkleRewards.contract.Call(opts, &out, "lastTotalAmount", network, token)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// LastTotalAmount is a free data retrieval call binding the contract method 0xd35e10bf.
//
// Solidity: function lastTotalAmount(address network, address token) view returns(uint256)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) LastTotalAmount(network common.Address, token common.Address) (*big.Int, error) {
	return _ICumulativeMerkleRewards.Contract.LastTotalAmount(&_ICumulativeMerkleRewards.CallOpts, network, token)
}

// LastTotalAmount is a free data retrieval call binding the contract method 0xd35e10bf.
//
// Solidity: function lastTotalAmount(address network, address token) view returns(uint256)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCallerSession) LastTotalAmount(network common.Address, token common.Address) (*big.Int, error) {
	return _ICumulativeMerkleRewards.Contract.LastTotalAmount(&_ICumulativeMerkleRewards.CallOpts, network, token)
}

// Protocol is a free data retrieval call binding the contract method 0x8ce74426.
//
// Solidity: function protocol() view returns(address)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCaller) Protocol(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _ICumulativeMerkleRewards.contract.Call(opts, &out, "protocol")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Protocol is a free data retrieval call binding the contract method 0x8ce74426.
//
// Solidity: function protocol() view returns(address)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) Protocol() (common.Address, error) {
	return _ICumulativeMerkleRewards.Contract.Protocol(&_ICumulativeMerkleRewards.CallOpts)
}

// Protocol is a free data retrieval call binding the contract method 0x8ce74426.
//
// Solidity: function protocol() view returns(address)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCallerSession) Protocol() (common.Address, error) {
	return _ICumulativeMerkleRewards.Contract.Protocol(&_ICumulativeMerkleRewards.CallOpts)
}

// Rewarder is a free data retrieval call binding the contract method 0xed21fed0.
//
// Solidity: function rewarder(address network) view returns(address)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCaller) Rewarder(opts *bind.CallOpts, network common.Address) (common.Address, error) {
	var out []interface{}
	err := _ICumulativeMerkleRewards.contract.Call(opts, &out, "rewarder", network)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Rewarder is a free data retrieval call binding the contract method 0xed21fed0.
//
// Solidity: function rewarder(address network) view returns(address)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) Rewarder(network common.Address) (common.Address, error) {
	return _ICumulativeMerkleRewards.Contract.Rewarder(&_ICumulativeMerkleRewards.CallOpts, network)
}

// Rewarder is a free data retrieval call binding the contract method 0xed21fed0.
//
// Solidity: function rewarder(address network) view returns(address)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsCallerSession) Rewarder(network common.Address) (common.Address, error) {
	return _ICumulativeMerkleRewards.Contract.Rewarder(&_ICumulativeMerkleRewards.CallOpts, network)
}

// ClaimCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0xad8320fd.
//
// Solidity: function claimCumulativeMerkleRewards(address recipient, address network, (address,uint256,uint256,bytes32) leaf, bytes32[] proof, bytes32 merkleRoot) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactor) ClaimCumulativeMerkleRewards(opts *bind.TransactOpts, recipient common.Address, network common.Address, leaf ICumulativeMerkleRewardsCumulativeDistributionLeaf, proof [][32]byte, merkleRoot [32]byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.contract.Transact(opts, "claimCumulativeMerkleRewards", recipient, network, leaf, proof, merkleRoot)
}

// ClaimCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0xad8320fd.
//
// Solidity: function claimCumulativeMerkleRewards(address recipient, address network, (address,uint256,uint256,bytes32) leaf, bytes32[] proof, bytes32 merkleRoot) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) ClaimCumulativeMerkleRewards(recipient common.Address, network common.Address, leaf ICumulativeMerkleRewardsCumulativeDistributionLeaf, proof [][32]byte, merkleRoot [32]byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.ClaimCumulativeMerkleRewards(&_ICumulativeMerkleRewards.TransactOpts, recipient, network, leaf, proof, merkleRoot)
}

// ClaimCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0xad8320fd.
//
// Solidity: function claimCumulativeMerkleRewards(address recipient, address network, (address,uint256,uint256,bytes32) leaf, bytes32[] proof, bytes32 merkleRoot) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorSession) ClaimCumulativeMerkleRewards(recipient common.Address, network common.Address, leaf ICumulativeMerkleRewardsCumulativeDistributionLeaf, proof [][32]byte, merkleRoot [32]byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.ClaimCumulativeMerkleRewards(&_ICumulativeMerkleRewards.TransactOpts, recipient, network, leaf, proof, merkleRoot)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactor) ClaimRewards(opts *bind.TransactOpts, recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.contract.Transact(opts, "claimRewards", recipient, token, data)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) ClaimRewards(recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.ClaimRewards(&_ICumulativeMerkleRewards.TransactOpts, recipient, token, data)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorSession) ClaimRewards(recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.ClaimRewards(&_ICumulativeMerkleRewards.TransactOpts, recipient, token, data)
}

// DepositCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0x908329f6.
//
// Solidity: function depositCumulativeMerkleRewards(address network, address token, uint256 amount) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactor) DepositCumulativeMerkleRewards(opts *bind.TransactOpts, network common.Address, token common.Address, amount *big.Int) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.contract.Transact(opts, "depositCumulativeMerkleRewards", network, token, amount)
}

// DepositCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0x908329f6.
//
// Solidity: function depositCumulativeMerkleRewards(address network, address token, uint256 amount) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) DepositCumulativeMerkleRewards(network common.Address, token common.Address, amount *big.Int) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.DepositCumulativeMerkleRewards(&_ICumulativeMerkleRewards.TransactOpts, network, token, amount)
}

// DepositCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0x908329f6.
//
// Solidity: function depositCumulativeMerkleRewards(address network, address token, uint256 amount) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorSession) DepositCumulativeMerkleRewards(network common.Address, token common.Address, amount *big.Int) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.DepositCumulativeMerkleRewards(&_ICumulativeMerkleRewards.TransactOpts, network, token, amount)
}

// DistributeCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0xde14c35b.
//
// Solidity: function distributeCumulativeMerkleRewards(address network, (uint48,bytes32) cumulativeDistribution, (uint64,address,uint256)[] totalAmounts, bytes ownerSignature, bytes rewarderSignature) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactor) DistributeCumulativeMerkleRewards(opts *bind.TransactOpts, network common.Address, cumulativeDistribution ICumulativeMerkleRewardsCumulativeDistribution, totalAmounts []ICumulativeMerkleRewardsTokenAmount, ownerSignature []byte, rewarderSignature []byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.contract.Transact(opts, "distributeCumulativeMerkleRewards", network, cumulativeDistribution, totalAmounts, ownerSignature, rewarderSignature)
}

// DistributeCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0xde14c35b.
//
// Solidity: function distributeCumulativeMerkleRewards(address network, (uint48,bytes32) cumulativeDistribution, (uint64,address,uint256)[] totalAmounts, bytes ownerSignature, bytes rewarderSignature) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) DistributeCumulativeMerkleRewards(network common.Address, cumulativeDistribution ICumulativeMerkleRewardsCumulativeDistribution, totalAmounts []ICumulativeMerkleRewardsTokenAmount, ownerSignature []byte, rewarderSignature []byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.DistributeCumulativeMerkleRewards(&_ICumulativeMerkleRewards.TransactOpts, network, cumulativeDistribution, totalAmounts, ownerSignature, rewarderSignature)
}

// DistributeCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0xde14c35b.
//
// Solidity: function distributeCumulativeMerkleRewards(address network, (uint48,bytes32) cumulativeDistribution, (uint64,address,uint256)[] totalAmounts, bytes ownerSignature, bytes rewarderSignature) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorSession) DistributeCumulativeMerkleRewards(network common.Address, cumulativeDistribution ICumulativeMerkleRewardsCumulativeDistribution, totalAmounts []ICumulativeMerkleRewardsTokenAmount, ownerSignature []byte, rewarderSignature []byte) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.DistributeCumulativeMerkleRewards(&_ICumulativeMerkleRewards.TransactOpts, network, cumulativeDistribution, totalAmounts, ownerSignature, rewarderSignature)
}

// SetProtocol is a paid mutator transaction binding the contract method 0x0a9d793d.
//
// Solidity: function setProtocol(address protocol) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactor) SetProtocol(opts *bind.TransactOpts, protocol common.Address) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.contract.Transact(opts, "setProtocol", protocol)
}

// SetProtocol is a paid mutator transaction binding the contract method 0x0a9d793d.
//
// Solidity: function setProtocol(address protocol) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) SetProtocol(protocol common.Address) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.SetProtocol(&_ICumulativeMerkleRewards.TransactOpts, protocol)
}

// SetProtocol is a paid mutator transaction binding the contract method 0x0a9d793d.
//
// Solidity: function setProtocol(address protocol) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorSession) SetProtocol(protocol common.Address) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.SetProtocol(&_ICumulativeMerkleRewards.TransactOpts, protocol)
}

// SetRewarder is a paid mutator transaction binding the contract method 0x3a6462e4.
//
// Solidity: function setRewarder(address rewarder) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactor) SetRewarder(opts *bind.TransactOpts, rewarder common.Address) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.contract.Transact(opts, "setRewarder", rewarder)
}

// SetRewarder is a paid mutator transaction binding the contract method 0x3a6462e4.
//
// Solidity: function setRewarder(address rewarder) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) SetRewarder(rewarder common.Address) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.SetRewarder(&_ICumulativeMerkleRewards.TransactOpts, rewarder)
}

// SetRewarder is a paid mutator transaction binding the contract method 0x3a6462e4.
//
// Solidity: function setRewarder(address rewarder) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorSession) SetRewarder(rewarder common.Address) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.SetRewarder(&_ICumulativeMerkleRewards.TransactOpts, rewarder)
}

// WithdrawCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0x72e830fa.
//
// Solidity: function withdrawCumulativeMerkleRewards(address recipient, address network, address token, uint256 amount) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactor) WithdrawCumulativeMerkleRewards(opts *bind.TransactOpts, recipient common.Address, network common.Address, token common.Address, amount *big.Int) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.contract.Transact(opts, "withdrawCumulativeMerkleRewards", recipient, network, token, amount)
}

// WithdrawCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0x72e830fa.
//
// Solidity: function withdrawCumulativeMerkleRewards(address recipient, address network, address token, uint256 amount) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsSession) WithdrawCumulativeMerkleRewards(recipient common.Address, network common.Address, token common.Address, amount *big.Int) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.WithdrawCumulativeMerkleRewards(&_ICumulativeMerkleRewards.TransactOpts, recipient, network, token, amount)
}

// WithdrawCumulativeMerkleRewards is a paid mutator transaction binding the contract method 0x72e830fa.
//
// Solidity: function withdrawCumulativeMerkleRewards(address recipient, address network, address token, uint256 amount) returns()
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsTransactorSession) WithdrawCumulativeMerkleRewards(recipient common.Address, network common.Address, token common.Address, amount *big.Int) (*types.Transaction, error) {
	return _ICumulativeMerkleRewards.Contract.WithdrawCumulativeMerkleRewards(&_ICumulativeMerkleRewards.TransactOpts, recipient, network, token, amount)
}

// ICumulativeMerkleRewardsClaimCumulativeMerkleRewardsIterator is returned from FilterClaimCumulativeMerkleRewards and is used to iterate over the raw logs and unpacked data for ClaimCumulativeMerkleRewards events raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsClaimCumulativeMerkleRewardsIterator struct {
	Event *ICumulativeMerkleRewardsClaimCumulativeMerkleRewards // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ICumulativeMerkleRewardsClaimCumulativeMerkleRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ICumulativeMerkleRewardsClaimCumulativeMerkleRewards)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ICumulativeMerkleRewardsClaimCumulativeMerkleRewards)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ICumulativeMerkleRewardsClaimCumulativeMerkleRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ICumulativeMerkleRewardsClaimCumulativeMerkleRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ICumulativeMerkleRewardsClaimCumulativeMerkleRewards represents a ClaimCumulativeMerkleRewards event raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsClaimCumulativeMerkleRewards struct {
	Rewardee common.Address
	Network  common.Address
	Leaf     ICumulativeMerkleRewardsCumulativeDistributionLeaf
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterClaimCumulativeMerkleRewards is a free log retrieval operation binding the contract event 0x492672ab99d706b967ef3fcb5e7c718810bcfbc31c344df739da81a4ccba98f2.
//
// Solidity: event ClaimCumulativeMerkleRewards(address indexed rewardee, address indexed network, (address,uint256,uint256,bytes32) leaf)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) FilterClaimCumulativeMerkleRewards(opts *bind.FilterOpts, rewardee []common.Address, network []common.Address) (*ICumulativeMerkleRewardsClaimCumulativeMerkleRewardsIterator, error) {

	var rewardeeRule []interface{}
	for _, rewardeeItem := range rewardee {
		rewardeeRule = append(rewardeeRule, rewardeeItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.FilterLogs(opts, "ClaimCumulativeMerkleRewards", rewardeeRule, networkRule)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsClaimCumulativeMerkleRewardsIterator{contract: _ICumulativeMerkleRewards.contract, event: "ClaimCumulativeMerkleRewards", logs: logs, sub: sub}, nil
}

// WatchClaimCumulativeMerkleRewards is a free log subscription operation binding the contract event 0x492672ab99d706b967ef3fcb5e7c718810bcfbc31c344df739da81a4ccba98f2.
//
// Solidity: event ClaimCumulativeMerkleRewards(address indexed rewardee, address indexed network, (address,uint256,uint256,bytes32) leaf)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) WatchClaimCumulativeMerkleRewards(opts *bind.WatchOpts, sink chan<- *ICumulativeMerkleRewardsClaimCumulativeMerkleRewards, rewardee []common.Address, network []common.Address) (event.Subscription, error) {

	var rewardeeRule []interface{}
	for _, rewardeeItem := range rewardee {
		rewardeeRule = append(rewardeeRule, rewardeeItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.WatchLogs(opts, "ClaimCumulativeMerkleRewards", rewardeeRule, networkRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ICumulativeMerkleRewardsClaimCumulativeMerkleRewards)
				if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "ClaimCumulativeMerkleRewards", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseClaimCumulativeMerkleRewards is a log parse operation binding the contract event 0x492672ab99d706b967ef3fcb5e7c718810bcfbc31c344df739da81a4ccba98f2.
//
// Solidity: event ClaimCumulativeMerkleRewards(address indexed rewardee, address indexed network, (address,uint256,uint256,bytes32) leaf)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) ParseClaimCumulativeMerkleRewards(log types.Log) (*ICumulativeMerkleRewardsClaimCumulativeMerkleRewards, error) {
	event := new(ICumulativeMerkleRewardsClaimCumulativeMerkleRewards)
	if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "ClaimCumulativeMerkleRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ICumulativeMerkleRewardsDepositCumulativeMerkleRewardsIterator is returned from FilterDepositCumulativeMerkleRewards and is used to iterate over the raw logs and unpacked data for DepositCumulativeMerkleRewards events raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsDepositCumulativeMerkleRewardsIterator struct {
	Event *ICumulativeMerkleRewardsDepositCumulativeMerkleRewards // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ICumulativeMerkleRewardsDepositCumulativeMerkleRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ICumulativeMerkleRewardsDepositCumulativeMerkleRewards)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ICumulativeMerkleRewardsDepositCumulativeMerkleRewards)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ICumulativeMerkleRewardsDepositCumulativeMerkleRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ICumulativeMerkleRewardsDepositCumulativeMerkleRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ICumulativeMerkleRewardsDepositCumulativeMerkleRewards represents a DepositCumulativeMerkleRewards event raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsDepositCumulativeMerkleRewards struct {
	Network common.Address
	Token   common.Address
	Amount  *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterDepositCumulativeMerkleRewards is a free log retrieval operation binding the contract event 0xca38721e490d806706270f5c048651ed3d32fcdbcd162327353da43408c0cf6f.
//
// Solidity: event DepositCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) FilterDepositCumulativeMerkleRewards(opts *bind.FilterOpts, network []common.Address, token []common.Address) (*ICumulativeMerkleRewardsDepositCumulativeMerkleRewardsIterator, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.FilterLogs(opts, "DepositCumulativeMerkleRewards", networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsDepositCumulativeMerkleRewardsIterator{contract: _ICumulativeMerkleRewards.contract, event: "DepositCumulativeMerkleRewards", logs: logs, sub: sub}, nil
}

// WatchDepositCumulativeMerkleRewards is a free log subscription operation binding the contract event 0xca38721e490d806706270f5c048651ed3d32fcdbcd162327353da43408c0cf6f.
//
// Solidity: event DepositCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) WatchDepositCumulativeMerkleRewards(opts *bind.WatchOpts, sink chan<- *ICumulativeMerkleRewardsDepositCumulativeMerkleRewards, network []common.Address, token []common.Address) (event.Subscription, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.WatchLogs(opts, "DepositCumulativeMerkleRewards", networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ICumulativeMerkleRewardsDepositCumulativeMerkleRewards)
				if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "DepositCumulativeMerkleRewards", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDepositCumulativeMerkleRewards is a log parse operation binding the contract event 0xca38721e490d806706270f5c048651ed3d32fcdbcd162327353da43408c0cf6f.
//
// Solidity: event DepositCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) ParseDepositCumulativeMerkleRewards(log types.Log) (*ICumulativeMerkleRewardsDepositCumulativeMerkleRewards, error) {
	event := new(ICumulativeMerkleRewardsDepositCumulativeMerkleRewards)
	if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "DepositCumulativeMerkleRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ICumulativeMerkleRewardsDistributeCumulativeMerkleRewardsIterator is returned from FilterDistributeCumulativeMerkleRewards and is used to iterate over the raw logs and unpacked data for DistributeCumulativeMerkleRewards events raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsDistributeCumulativeMerkleRewardsIterator struct {
	Event *ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ICumulativeMerkleRewardsDistributeCumulativeMerkleRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ICumulativeMerkleRewardsDistributeCumulativeMerkleRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ICumulativeMerkleRewardsDistributeCumulativeMerkleRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards represents a DistributeCumulativeMerkleRewards event raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards struct {
	Network                common.Address
	CumulativeDistribution ICumulativeMerkleRewardsCumulativeDistribution
	Raw                    types.Log // Blockchain specific contextual infos
}

// FilterDistributeCumulativeMerkleRewards is a free log retrieval operation binding the contract event 0x74f1855e6faffc99b8241a8a9731c68126e1e7d4994755416affb37e4be4e443.
//
// Solidity: event DistributeCumulativeMerkleRewards(address indexed network, (uint48,bytes32) cumulativeDistribution)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) FilterDistributeCumulativeMerkleRewards(opts *bind.FilterOpts, network []common.Address) (*ICumulativeMerkleRewardsDistributeCumulativeMerkleRewardsIterator, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.FilterLogs(opts, "DistributeCumulativeMerkleRewards", networkRule)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsDistributeCumulativeMerkleRewardsIterator{contract: _ICumulativeMerkleRewards.contract, event: "DistributeCumulativeMerkleRewards", logs: logs, sub: sub}, nil
}

// WatchDistributeCumulativeMerkleRewards is a free log subscription operation binding the contract event 0x74f1855e6faffc99b8241a8a9731c68126e1e7d4994755416affb37e4be4e443.
//
// Solidity: event DistributeCumulativeMerkleRewards(address indexed network, (uint48,bytes32) cumulativeDistribution)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) WatchDistributeCumulativeMerkleRewards(opts *bind.WatchOpts, sink chan<- *ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards, network []common.Address) (event.Subscription, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.WatchLogs(opts, "DistributeCumulativeMerkleRewards", networkRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards)
				if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "DistributeCumulativeMerkleRewards", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDistributeCumulativeMerkleRewards is a log parse operation binding the contract event 0x74f1855e6faffc99b8241a8a9731c68126e1e7d4994755416affb37e4be4e443.
//
// Solidity: event DistributeCumulativeMerkleRewards(address indexed network, (uint48,bytes32) cumulativeDistribution)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) ParseDistributeCumulativeMerkleRewards(log types.Log) (*ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards, error) {
	event := new(ICumulativeMerkleRewardsDistributeCumulativeMerkleRewards)
	if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "DistributeCumulativeMerkleRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ICumulativeMerkleRewardsSetProtocolIterator is returned from FilterSetProtocol and is used to iterate over the raw logs and unpacked data for SetProtocol events raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsSetProtocolIterator struct {
	Event *ICumulativeMerkleRewardsSetProtocol // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ICumulativeMerkleRewardsSetProtocolIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ICumulativeMerkleRewardsSetProtocol)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ICumulativeMerkleRewardsSetProtocol)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ICumulativeMerkleRewardsSetProtocolIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ICumulativeMerkleRewardsSetProtocolIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ICumulativeMerkleRewardsSetProtocol represents a SetProtocol event raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsSetProtocol struct {
	Protocol common.Address
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterSetProtocol is a free log retrieval operation binding the contract event 0x64bb3d1efea184c5281e346cdecb8a60e15240c8b0978166a74f8a9b50918c26.
//
// Solidity: event SetProtocol(address indexed protocol)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) FilterSetProtocol(opts *bind.FilterOpts, protocol []common.Address) (*ICumulativeMerkleRewardsSetProtocolIterator, error) {

	var protocolRule []interface{}
	for _, protocolItem := range protocol {
		protocolRule = append(protocolRule, protocolItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.FilterLogs(opts, "SetProtocol", protocolRule)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsSetProtocolIterator{contract: _ICumulativeMerkleRewards.contract, event: "SetProtocol", logs: logs, sub: sub}, nil
}

// WatchSetProtocol is a free log subscription operation binding the contract event 0x64bb3d1efea184c5281e346cdecb8a60e15240c8b0978166a74f8a9b50918c26.
//
// Solidity: event SetProtocol(address indexed protocol)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) WatchSetProtocol(opts *bind.WatchOpts, sink chan<- *ICumulativeMerkleRewardsSetProtocol, protocol []common.Address) (event.Subscription, error) {

	var protocolRule []interface{}
	for _, protocolItem := range protocol {
		protocolRule = append(protocolRule, protocolItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.WatchLogs(opts, "SetProtocol", protocolRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ICumulativeMerkleRewardsSetProtocol)
				if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "SetProtocol", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseSetProtocol is a log parse operation binding the contract event 0x64bb3d1efea184c5281e346cdecb8a60e15240c8b0978166a74f8a9b50918c26.
//
// Solidity: event SetProtocol(address indexed protocol)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) ParseSetProtocol(log types.Log) (*ICumulativeMerkleRewardsSetProtocol, error) {
	event := new(ICumulativeMerkleRewardsSetProtocol)
	if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "SetProtocol", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ICumulativeMerkleRewardsSetRewarderIterator is returned from FilterSetRewarder and is used to iterate over the raw logs and unpacked data for SetRewarder events raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsSetRewarderIterator struct {
	Event *ICumulativeMerkleRewardsSetRewarder // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ICumulativeMerkleRewardsSetRewarderIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ICumulativeMerkleRewardsSetRewarder)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ICumulativeMerkleRewardsSetRewarder)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ICumulativeMerkleRewardsSetRewarderIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ICumulativeMerkleRewardsSetRewarderIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ICumulativeMerkleRewardsSetRewarder represents a SetRewarder event raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsSetRewarder struct {
	Network  common.Address
	Rewarder common.Address
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterSetRewarder is a free log retrieval operation binding the contract event 0x8fad2813325f249edfff17f0c9d628c4a5cec339f77e49be1adb67862b4a6022.
//
// Solidity: event SetRewarder(address indexed network, address rewarder)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) FilterSetRewarder(opts *bind.FilterOpts, network []common.Address) (*ICumulativeMerkleRewardsSetRewarderIterator, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.FilterLogs(opts, "SetRewarder", networkRule)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsSetRewarderIterator{contract: _ICumulativeMerkleRewards.contract, event: "SetRewarder", logs: logs, sub: sub}, nil
}

// WatchSetRewarder is a free log subscription operation binding the contract event 0x8fad2813325f249edfff17f0c9d628c4a5cec339f77e49be1adb67862b4a6022.
//
// Solidity: event SetRewarder(address indexed network, address rewarder)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) WatchSetRewarder(opts *bind.WatchOpts, sink chan<- *ICumulativeMerkleRewardsSetRewarder, network []common.Address) (event.Subscription, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.WatchLogs(opts, "SetRewarder", networkRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ICumulativeMerkleRewardsSetRewarder)
				if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "SetRewarder", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseSetRewarder is a log parse operation binding the contract event 0x8fad2813325f249edfff17f0c9d628c4a5cec339f77e49be1adb67862b4a6022.
//
// Solidity: event SetRewarder(address indexed network, address rewarder)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) ParseSetRewarder(log types.Log) (*ICumulativeMerkleRewardsSetRewarder, error) {
	event := new(ICumulativeMerkleRewardsSetRewarder)
	if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "SetRewarder", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewardsIterator is returned from FilterWithdrawCumulativeMerkleRewards and is used to iterate over the raw logs and unpacked data for WithdrawCumulativeMerkleRewards events raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewardsIterator struct {
	Event *ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards represents a WithdrawCumulativeMerkleRewards event raised by the ICumulativeMerkleRewards contract.
type ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards struct {
	Network common.Address
	Token   common.Address
	Amount  *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterWithdrawCumulativeMerkleRewards is a free log retrieval operation binding the contract event 0xef62027c225197f50d414cd39a4109ca6a8fe2730f5b3506bdef6eaff14a78f4.
//
// Solidity: event WithdrawCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) FilterWithdrawCumulativeMerkleRewards(opts *bind.FilterOpts, network []common.Address, token []common.Address) (*ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewardsIterator, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.FilterLogs(opts, "WithdrawCumulativeMerkleRewards", networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return &ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewardsIterator{contract: _ICumulativeMerkleRewards.contract, event: "WithdrawCumulativeMerkleRewards", logs: logs, sub: sub}, nil
}

// WatchWithdrawCumulativeMerkleRewards is a free log subscription operation binding the contract event 0xef62027c225197f50d414cd39a4109ca6a8fe2730f5b3506bdef6eaff14a78f4.
//
// Solidity: event WithdrawCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) WatchWithdrawCumulativeMerkleRewards(opts *bind.WatchOpts, sink chan<- *ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards, network []common.Address, token []common.Address) (event.Subscription, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _ICumulativeMerkleRewards.contract.WatchLogs(opts, "WithdrawCumulativeMerkleRewards", networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards)
				if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "WithdrawCumulativeMerkleRewards", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseWithdrawCumulativeMerkleRewards is a log parse operation binding the contract event 0xef62027c225197f50d414cd39a4109ca6a8fe2730f5b3506bdef6eaff14a78f4.
//
// Solidity: event WithdrawCumulativeMerkleRewards(address indexed network, address indexed token, uint256 amount)
func (_ICumulativeMerkleRewards *ICumulativeMerkleRewardsFilterer) ParseWithdrawCumulativeMerkleRewards(log types.Log) (*ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards, error) {
	event := new(ICumulativeMerkleRewardsWithdrawCumulativeMerkleRewards)
	if err := _ICumulativeMerkleRewards.contract.UnpackLog(event, "WithdrawCumulativeMerkleRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
