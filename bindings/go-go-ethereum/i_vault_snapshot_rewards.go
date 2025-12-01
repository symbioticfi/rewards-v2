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

// IVaultSnapshotRewardsRewardDistribution is an auto generated low-level Go binding around an user-defined struct.
type IVaultSnapshotRewardsRewardDistribution struct {
	SubnetworkId  *big.Int
	Delegator     common.Address
	DelegatorType uint64
	Timestamp     *big.Int
	Amount        *big.Int
	OperatorsFees *big.Int
}

// IVaultSnapshotRewardsMetaData contains all meta data concerning the IVaultSnapshotRewards contract.
var IVaultSnapshotRewardsMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"CURATOR_REGISTRY\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"NETWORK_MIDDLEWARE_SERVICE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"NETWORK_REGISTRY\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"VAULT_FACTORY\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"claimCuratorFees\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"claimOperatorFees\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"lastUnclaimedRewards\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"firstRewardToClaim\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"rewardsToClaim\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"extraData\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"claimRewards\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"claimVaultSnapshotRewards\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"lastUnclaimedRewards\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"firstRewardToClaim\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"rewardsToClaim\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"activeSharesOfHints\",\"type\":\"bytes[]\",\"internalType\":\"bytes[]\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"curatorFees\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"distributeVaultSnapshotRewards\",\"inputs\":[{\"name\":\"subnetwork\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"activeSharesHint\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"lastUnclaimedOperatorReward\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"lastUnclaimedReward\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"rewards\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"index\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIVaultSnapshotRewards.RewardDistribution\",\"components\":[{\"name\":\"subnetworkId\",\"type\":\"uint96\",\"internalType\":\"uint96\"},{\"name\":\"delegator\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"delegatorType\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"operatorsFees\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"rewardsLength\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"event\",\"name\":\"ClaimCuratorFees\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ClaimOperatorFees\",\"inputs\":[{\"name\":\"operator\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"firstClaimedReward\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"rewardsClaimed\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ClaimVaultSnapshotRewards\",\"inputs\":[{\"name\":\"staker\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"firstClaimedReward\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"rewardsClaimed\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"DistributeVaultSnapshotRewards\",\"inputs\":[{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"subnetworkId\",\"type\":\"uint96\",\"indexed\":false,\"internalType\":\"uint96\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"indexed\":false,\"internalType\":\"uint48\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"curatorFees\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"operatorsFees\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"InsufficientReward\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidDelegatorType\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidLastUnclaimedReward\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidRecipient\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidRewardTimestamp\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidVault\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoRewardsToClaim\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotCurator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotNetworkOrMiddleware\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotOperator\",\"inputs\":[]}]",
}

// IVaultSnapshotRewardsABI is the input ABI used to generate the binding from.
// Deprecated: Use IVaultSnapshotRewardsMetaData.ABI instead.
var IVaultSnapshotRewardsABI = IVaultSnapshotRewardsMetaData.ABI

// IVaultSnapshotRewards is an auto generated Go binding around an Ethereum contract.
type IVaultSnapshotRewards struct {
	IVaultSnapshotRewardsCaller     // Read-only binding to the contract
	IVaultSnapshotRewardsTransactor // Write-only binding to the contract
	IVaultSnapshotRewardsFilterer   // Log filterer for contract events
}

// IVaultSnapshotRewardsCaller is an auto generated read-only Go binding around an Ethereum contract.
type IVaultSnapshotRewardsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IVaultSnapshotRewardsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IVaultSnapshotRewardsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IVaultSnapshotRewardsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IVaultSnapshotRewardsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IVaultSnapshotRewardsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IVaultSnapshotRewardsSession struct {
	Contract     *IVaultSnapshotRewards // Generic contract binding to set the session for
	CallOpts     bind.CallOpts          // Call options to use throughout this session
	TransactOpts bind.TransactOpts      // Transaction auth options to use throughout this session
}

// IVaultSnapshotRewardsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IVaultSnapshotRewardsCallerSession struct {
	Contract *IVaultSnapshotRewardsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts                // Call options to use throughout this session
}

// IVaultSnapshotRewardsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IVaultSnapshotRewardsTransactorSession struct {
	Contract     *IVaultSnapshotRewardsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts                // Transaction auth options to use throughout this session
}

// IVaultSnapshotRewardsRaw is an auto generated low-level Go binding around an Ethereum contract.
type IVaultSnapshotRewardsRaw struct {
	Contract *IVaultSnapshotRewards // Generic contract binding to access the raw methods on
}

// IVaultSnapshotRewardsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IVaultSnapshotRewardsCallerRaw struct {
	Contract *IVaultSnapshotRewardsCaller // Generic read-only contract binding to access the raw methods on
}

// IVaultSnapshotRewardsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IVaultSnapshotRewardsTransactorRaw struct {
	Contract *IVaultSnapshotRewardsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIVaultSnapshotRewards creates a new instance of IVaultSnapshotRewards, bound to a specific deployed contract.
func NewIVaultSnapshotRewards(address common.Address, backend bind.ContractBackend) (*IVaultSnapshotRewards, error) {
	contract, err := bindIVaultSnapshotRewards(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IVaultSnapshotRewards{IVaultSnapshotRewardsCaller: IVaultSnapshotRewardsCaller{contract: contract}, IVaultSnapshotRewardsTransactor: IVaultSnapshotRewardsTransactor{contract: contract}, IVaultSnapshotRewardsFilterer: IVaultSnapshotRewardsFilterer{contract: contract}}, nil
}

// NewIVaultSnapshotRewardsCaller creates a new read-only instance of IVaultSnapshotRewards, bound to a specific deployed contract.
func NewIVaultSnapshotRewardsCaller(address common.Address, caller bind.ContractCaller) (*IVaultSnapshotRewardsCaller, error) {
	contract, err := bindIVaultSnapshotRewards(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IVaultSnapshotRewardsCaller{contract: contract}, nil
}

// NewIVaultSnapshotRewardsTransactor creates a new write-only instance of IVaultSnapshotRewards, bound to a specific deployed contract.
func NewIVaultSnapshotRewardsTransactor(address common.Address, transactor bind.ContractTransactor) (*IVaultSnapshotRewardsTransactor, error) {
	contract, err := bindIVaultSnapshotRewards(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IVaultSnapshotRewardsTransactor{contract: contract}, nil
}

// NewIVaultSnapshotRewardsFilterer creates a new log filterer instance of IVaultSnapshotRewards, bound to a specific deployed contract.
func NewIVaultSnapshotRewardsFilterer(address common.Address, filterer bind.ContractFilterer) (*IVaultSnapshotRewardsFilterer, error) {
	contract, err := bindIVaultSnapshotRewards(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IVaultSnapshotRewardsFilterer{contract: contract}, nil
}

// bindIVaultSnapshotRewards binds a generic wrapper to an already deployed contract.
func bindIVaultSnapshotRewards(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := IVaultSnapshotRewardsMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IVaultSnapshotRewards.Contract.IVaultSnapshotRewardsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.IVaultSnapshotRewardsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.IVaultSnapshotRewardsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IVaultSnapshotRewards.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.contract.Transact(opts, method, params...)
}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) CURATORREGISTRY(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "CURATOR_REGISTRY")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) CURATORREGISTRY() (common.Address, error) {
	return _IVaultSnapshotRewards.Contract.CURATORREGISTRY(&_IVaultSnapshotRewards.CallOpts)
}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) CURATORREGISTRY() (common.Address, error) {
	return _IVaultSnapshotRewards.Contract.CURATORREGISTRY(&_IVaultSnapshotRewards.CallOpts)
}

// NETWORKMIDDLEWARESERVICE is a free data retrieval call binding the contract method 0x2c9d45b3.
//
// Solidity: function NETWORK_MIDDLEWARE_SERVICE() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) NETWORKMIDDLEWARESERVICE(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "NETWORK_MIDDLEWARE_SERVICE")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// NETWORKMIDDLEWARESERVICE is a free data retrieval call binding the contract method 0x2c9d45b3.
//
// Solidity: function NETWORK_MIDDLEWARE_SERVICE() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) NETWORKMIDDLEWARESERVICE() (common.Address, error) {
	return _IVaultSnapshotRewards.Contract.NETWORKMIDDLEWARESERVICE(&_IVaultSnapshotRewards.CallOpts)
}

// NETWORKMIDDLEWARESERVICE is a free data retrieval call binding the contract method 0x2c9d45b3.
//
// Solidity: function NETWORK_MIDDLEWARE_SERVICE() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) NETWORKMIDDLEWARESERVICE() (common.Address, error) {
	return _IVaultSnapshotRewards.Contract.NETWORKMIDDLEWARESERVICE(&_IVaultSnapshotRewards.CallOpts)
}

// NETWORKREGISTRY is a free data retrieval call binding the contract method 0xc0cd7c3e.
//
// Solidity: function NETWORK_REGISTRY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) NETWORKREGISTRY(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "NETWORK_REGISTRY")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// NETWORKREGISTRY is a free data retrieval call binding the contract method 0xc0cd7c3e.
//
// Solidity: function NETWORK_REGISTRY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) NETWORKREGISTRY() (common.Address, error) {
	return _IVaultSnapshotRewards.Contract.NETWORKREGISTRY(&_IVaultSnapshotRewards.CallOpts)
}

// NETWORKREGISTRY is a free data retrieval call binding the contract method 0xc0cd7c3e.
//
// Solidity: function NETWORK_REGISTRY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) NETWORKREGISTRY() (common.Address, error) {
	return _IVaultSnapshotRewards.Contract.NETWORKREGISTRY(&_IVaultSnapshotRewards.CallOpts)
}

// VAULTFACTORY is a free data retrieval call binding the contract method 0x103f2907.
//
// Solidity: function VAULT_FACTORY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) VAULTFACTORY(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "VAULT_FACTORY")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// VAULTFACTORY is a free data retrieval call binding the contract method 0x103f2907.
//
// Solidity: function VAULT_FACTORY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) VAULTFACTORY() (common.Address, error) {
	return _IVaultSnapshotRewards.Contract.VAULTFACTORY(&_IVaultSnapshotRewards.CallOpts)
}

// VAULTFACTORY is a free data retrieval call binding the contract method 0x103f2907.
//
// Solidity: function VAULT_FACTORY() view returns(address)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) VAULTFACTORY() (common.Address, error) {
	return _IVaultSnapshotRewards.Contract.VAULTFACTORY(&_IVaultSnapshotRewards.CallOpts)
}

// CuratorFees is a free data retrieval call binding the contract method 0x2f8006e0.
//
// Solidity: function curatorFees(address vault, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) CuratorFees(opts *bind.CallOpts, vault common.Address, token common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "curatorFees", vault, token)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// CuratorFees is a free data retrieval call binding the contract method 0x2f8006e0.
//
// Solidity: function curatorFees(address vault, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) CuratorFees(vault common.Address, token common.Address) (*big.Int, error) {
	return _IVaultSnapshotRewards.Contract.CuratorFees(&_IVaultSnapshotRewards.CallOpts, vault, token)
}

// CuratorFees is a free data retrieval call binding the contract method 0x2f8006e0.
//
// Solidity: function curatorFees(address vault, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) CuratorFees(vault common.Address, token common.Address) (*big.Int, error) {
	return _IVaultSnapshotRewards.Contract.CuratorFees(&_IVaultSnapshotRewards.CallOpts, vault, token)
}

// LastUnclaimedOperatorReward is a free data retrieval call binding the contract method 0x2c1767d0.
//
// Solidity: function lastUnclaimedOperatorReward(address account, address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) LastUnclaimedOperatorReward(opts *bind.CallOpts, account common.Address, vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "lastUnclaimedOperatorReward", account, vault, network, token)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// LastUnclaimedOperatorReward is a free data retrieval call binding the contract method 0x2c1767d0.
//
// Solidity: function lastUnclaimedOperatorReward(address account, address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) LastUnclaimedOperatorReward(account common.Address, vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	return _IVaultSnapshotRewards.Contract.LastUnclaimedOperatorReward(&_IVaultSnapshotRewards.CallOpts, account, vault, network, token)
}

// LastUnclaimedOperatorReward is a free data retrieval call binding the contract method 0x2c1767d0.
//
// Solidity: function lastUnclaimedOperatorReward(address account, address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) LastUnclaimedOperatorReward(account common.Address, vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	return _IVaultSnapshotRewards.Contract.LastUnclaimedOperatorReward(&_IVaultSnapshotRewards.CallOpts, account, vault, network, token)
}

// LastUnclaimedReward is a free data retrieval call binding the contract method 0xbe511db8.
//
// Solidity: function lastUnclaimedReward(address account, address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) LastUnclaimedReward(opts *bind.CallOpts, account common.Address, vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "lastUnclaimedReward", account, vault, network, token)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// LastUnclaimedReward is a free data retrieval call binding the contract method 0xbe511db8.
//
// Solidity: function lastUnclaimedReward(address account, address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) LastUnclaimedReward(account common.Address, vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	return _IVaultSnapshotRewards.Contract.LastUnclaimedReward(&_IVaultSnapshotRewards.CallOpts, account, vault, network, token)
}

// LastUnclaimedReward is a free data retrieval call binding the contract method 0xbe511db8.
//
// Solidity: function lastUnclaimedReward(address account, address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) LastUnclaimedReward(account common.Address, vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	return _IVaultSnapshotRewards.Contract.LastUnclaimedReward(&_IVaultSnapshotRewards.CallOpts, account, vault, network, token)
}

// Rewards is a free data retrieval call binding the contract method 0x288a4d07.
//
// Solidity: function rewards(address vault, address network, address token, uint256 index) view returns((uint96,address,uint64,uint48,uint256,uint256))
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) Rewards(opts *bind.CallOpts, vault common.Address, network common.Address, token common.Address, index *big.Int) (IVaultSnapshotRewardsRewardDistribution, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "rewards", vault, network, token, index)

	if err != nil {
		return *new(IVaultSnapshotRewardsRewardDistribution), err
	}

	out0 := *abi.ConvertType(out[0], new(IVaultSnapshotRewardsRewardDistribution)).(*IVaultSnapshotRewardsRewardDistribution)

	return out0, err

}

// Rewards is a free data retrieval call binding the contract method 0x288a4d07.
//
// Solidity: function rewards(address vault, address network, address token, uint256 index) view returns((uint96,address,uint64,uint48,uint256,uint256))
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) Rewards(vault common.Address, network common.Address, token common.Address, index *big.Int) (IVaultSnapshotRewardsRewardDistribution, error) {
	return _IVaultSnapshotRewards.Contract.Rewards(&_IVaultSnapshotRewards.CallOpts, vault, network, token, index)
}

// Rewards is a free data retrieval call binding the contract method 0x288a4d07.
//
// Solidity: function rewards(address vault, address network, address token, uint256 index) view returns((uint96,address,uint64,uint48,uint256,uint256))
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) Rewards(vault common.Address, network common.Address, token common.Address, index *big.Int) (IVaultSnapshotRewardsRewardDistribution, error) {
	return _IVaultSnapshotRewards.Contract.Rewards(&_IVaultSnapshotRewards.CallOpts, vault, network, token, index)
}

// RewardsLength is a free data retrieval call binding the contract method 0x6405b650.
//
// Solidity: function rewardsLength(address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCaller) RewardsLength(opts *bind.CallOpts, vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IVaultSnapshotRewards.contract.Call(opts, &out, "rewardsLength", vault, network, token)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// RewardsLength is a free data retrieval call binding the contract method 0x6405b650.
//
// Solidity: function rewardsLength(address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) RewardsLength(vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	return _IVaultSnapshotRewards.Contract.RewardsLength(&_IVaultSnapshotRewards.CallOpts, vault, network, token)
}

// RewardsLength is a free data retrieval call binding the contract method 0x6405b650.
//
// Solidity: function rewardsLength(address vault, address network, address token) view returns(uint256)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsCallerSession) RewardsLength(vault common.Address, network common.Address, token common.Address) (*big.Int, error) {
	return _IVaultSnapshotRewards.Contract.RewardsLength(&_IVaultSnapshotRewards.CallOpts, vault, network, token)
}

// ClaimCuratorFees is a paid mutator transaction binding the contract method 0xd1216d0a.
//
// Solidity: function claimCuratorFees(address recipient, address vault, address token) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactor) ClaimCuratorFees(opts *bind.TransactOpts, recipient common.Address, vault common.Address, token common.Address) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.contract.Transact(opts, "claimCuratorFees", recipient, vault, token)
}

// ClaimCuratorFees is a paid mutator transaction binding the contract method 0xd1216d0a.
//
// Solidity: function claimCuratorFees(address recipient, address vault, address token) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) ClaimCuratorFees(recipient common.Address, vault common.Address, token common.Address) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.ClaimCuratorFees(&_IVaultSnapshotRewards.TransactOpts, recipient, vault, token)
}

// ClaimCuratorFees is a paid mutator transaction binding the contract method 0xd1216d0a.
//
// Solidity: function claimCuratorFees(address recipient, address vault, address token) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactorSession) ClaimCuratorFees(recipient common.Address, vault common.Address, token common.Address) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.ClaimCuratorFees(&_IVaultSnapshotRewards.TransactOpts, recipient, vault, token)
}

// ClaimOperatorFees is a paid mutator transaction binding the contract method 0x6635f736.
//
// Solidity: function claimOperatorFees(address recipient, address network, address token, address vault, uint256 lastUnclaimedRewards, uint256 firstRewardToClaim, uint256 rewardsToClaim, bytes extraData) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactor) ClaimOperatorFees(opts *bind.TransactOpts, recipient common.Address, network common.Address, token common.Address, vault common.Address, lastUnclaimedRewards *big.Int, firstRewardToClaim *big.Int, rewardsToClaim *big.Int, extraData []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.contract.Transact(opts, "claimOperatorFees", recipient, network, token, vault, lastUnclaimedRewards, firstRewardToClaim, rewardsToClaim, extraData)
}

// ClaimOperatorFees is a paid mutator transaction binding the contract method 0x6635f736.
//
// Solidity: function claimOperatorFees(address recipient, address network, address token, address vault, uint256 lastUnclaimedRewards, uint256 firstRewardToClaim, uint256 rewardsToClaim, bytes extraData) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) ClaimOperatorFees(recipient common.Address, network common.Address, token common.Address, vault common.Address, lastUnclaimedRewards *big.Int, firstRewardToClaim *big.Int, rewardsToClaim *big.Int, extraData []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.ClaimOperatorFees(&_IVaultSnapshotRewards.TransactOpts, recipient, network, token, vault, lastUnclaimedRewards, firstRewardToClaim, rewardsToClaim, extraData)
}

// ClaimOperatorFees is a paid mutator transaction binding the contract method 0x6635f736.
//
// Solidity: function claimOperatorFees(address recipient, address network, address token, address vault, uint256 lastUnclaimedRewards, uint256 firstRewardToClaim, uint256 rewardsToClaim, bytes extraData) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactorSession) ClaimOperatorFees(recipient common.Address, network common.Address, token common.Address, vault common.Address, lastUnclaimedRewards *big.Int, firstRewardToClaim *big.Int, rewardsToClaim *big.Int, extraData []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.ClaimOperatorFees(&_IVaultSnapshotRewards.TransactOpts, recipient, network, token, vault, lastUnclaimedRewards, firstRewardToClaim, rewardsToClaim, extraData)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactor) ClaimRewards(opts *bind.TransactOpts, recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.contract.Transact(opts, "claimRewards", recipient, token, data)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) ClaimRewards(recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.ClaimRewards(&_IVaultSnapshotRewards.TransactOpts, recipient, token, data)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactorSession) ClaimRewards(recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.ClaimRewards(&_IVaultSnapshotRewards.TransactOpts, recipient, token, data)
}

// ClaimVaultSnapshotRewards is a paid mutator transaction binding the contract method 0x363e5969.
//
// Solidity: function claimVaultSnapshotRewards(address recipient, address network, address token, address vault, uint256 lastUnclaimedRewards, uint256 firstRewardToClaim, uint256 rewardsToClaim, bytes[] activeSharesOfHints) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactor) ClaimVaultSnapshotRewards(opts *bind.TransactOpts, recipient common.Address, network common.Address, token common.Address, vault common.Address, lastUnclaimedRewards *big.Int, firstRewardToClaim *big.Int, rewardsToClaim *big.Int, activeSharesOfHints [][]byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.contract.Transact(opts, "claimVaultSnapshotRewards", recipient, network, token, vault, lastUnclaimedRewards, firstRewardToClaim, rewardsToClaim, activeSharesOfHints)
}

// ClaimVaultSnapshotRewards is a paid mutator transaction binding the contract method 0x363e5969.
//
// Solidity: function claimVaultSnapshotRewards(address recipient, address network, address token, address vault, uint256 lastUnclaimedRewards, uint256 firstRewardToClaim, uint256 rewardsToClaim, bytes[] activeSharesOfHints) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) ClaimVaultSnapshotRewards(recipient common.Address, network common.Address, token common.Address, vault common.Address, lastUnclaimedRewards *big.Int, firstRewardToClaim *big.Int, rewardsToClaim *big.Int, activeSharesOfHints [][]byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.ClaimVaultSnapshotRewards(&_IVaultSnapshotRewards.TransactOpts, recipient, network, token, vault, lastUnclaimedRewards, firstRewardToClaim, rewardsToClaim, activeSharesOfHints)
}

// ClaimVaultSnapshotRewards is a paid mutator transaction binding the contract method 0x363e5969.
//
// Solidity: function claimVaultSnapshotRewards(address recipient, address network, address token, address vault, uint256 lastUnclaimedRewards, uint256 firstRewardToClaim, uint256 rewardsToClaim, bytes[] activeSharesOfHints) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactorSession) ClaimVaultSnapshotRewards(recipient common.Address, network common.Address, token common.Address, vault common.Address, lastUnclaimedRewards *big.Int, firstRewardToClaim *big.Int, rewardsToClaim *big.Int, activeSharesOfHints [][]byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.ClaimVaultSnapshotRewards(&_IVaultSnapshotRewards.TransactOpts, recipient, network, token, vault, lastUnclaimedRewards, firstRewardToClaim, rewardsToClaim, activeSharesOfHints)
}

// DistributeVaultSnapshotRewards is a paid mutator transaction binding the contract method 0xc5a8f83c.
//
// Solidity: function distributeVaultSnapshotRewards(bytes32 subnetwork, address token, address vault, uint256 amount, uint48 timestamp, bytes activeSharesHint) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactor) DistributeVaultSnapshotRewards(opts *bind.TransactOpts, subnetwork [32]byte, token common.Address, vault common.Address, amount *big.Int, timestamp *big.Int, activeSharesHint []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.contract.Transact(opts, "distributeVaultSnapshotRewards", subnetwork, token, vault, amount, timestamp, activeSharesHint)
}

// DistributeVaultSnapshotRewards is a paid mutator transaction binding the contract method 0xc5a8f83c.
//
// Solidity: function distributeVaultSnapshotRewards(bytes32 subnetwork, address token, address vault, uint256 amount, uint48 timestamp, bytes activeSharesHint) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsSession) DistributeVaultSnapshotRewards(subnetwork [32]byte, token common.Address, vault common.Address, amount *big.Int, timestamp *big.Int, activeSharesHint []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.DistributeVaultSnapshotRewards(&_IVaultSnapshotRewards.TransactOpts, subnetwork, token, vault, amount, timestamp, activeSharesHint)
}

// DistributeVaultSnapshotRewards is a paid mutator transaction binding the contract method 0xc5a8f83c.
//
// Solidity: function distributeVaultSnapshotRewards(bytes32 subnetwork, address token, address vault, uint256 amount, uint48 timestamp, bytes activeSharesHint) returns()
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsTransactorSession) DistributeVaultSnapshotRewards(subnetwork [32]byte, token common.Address, vault common.Address, amount *big.Int, timestamp *big.Int, activeSharesHint []byte) (*types.Transaction, error) {
	return _IVaultSnapshotRewards.Contract.DistributeVaultSnapshotRewards(&_IVaultSnapshotRewards.TransactOpts, subnetwork, token, vault, amount, timestamp, activeSharesHint)
}

// IVaultSnapshotRewardsClaimCuratorFeesIterator is returned from FilterClaimCuratorFees and is used to iterate over the raw logs and unpacked data for ClaimCuratorFees events raised by the IVaultSnapshotRewards contract.
type IVaultSnapshotRewardsClaimCuratorFeesIterator struct {
	Event *IVaultSnapshotRewardsClaimCuratorFees // Event containing the contract specifics and raw log

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
func (it *IVaultSnapshotRewardsClaimCuratorFeesIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IVaultSnapshotRewardsClaimCuratorFees)
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
		it.Event = new(IVaultSnapshotRewardsClaimCuratorFees)
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
func (it *IVaultSnapshotRewardsClaimCuratorFeesIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IVaultSnapshotRewardsClaimCuratorFeesIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IVaultSnapshotRewardsClaimCuratorFees represents a ClaimCuratorFees event raised by the IVaultSnapshotRewards contract.
type IVaultSnapshotRewardsClaimCuratorFees struct {
	Vault  common.Address
	Token  common.Address
	Amount *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterClaimCuratorFees is a free log retrieval operation binding the contract event 0xb8168ce970fea31a66517b0f2b9064db1aca670e136fe6bbe873ed3725b7578f.
//
// Solidity: event ClaimCuratorFees(address indexed vault, address indexed token, uint256 amount)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) FilterClaimCuratorFees(opts *bind.FilterOpts, vault []common.Address, token []common.Address) (*IVaultSnapshotRewardsClaimCuratorFeesIterator, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IVaultSnapshotRewards.contract.FilterLogs(opts, "ClaimCuratorFees", vaultRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return &IVaultSnapshotRewardsClaimCuratorFeesIterator{contract: _IVaultSnapshotRewards.contract, event: "ClaimCuratorFees", logs: logs, sub: sub}, nil
}

// WatchClaimCuratorFees is a free log subscription operation binding the contract event 0xb8168ce970fea31a66517b0f2b9064db1aca670e136fe6bbe873ed3725b7578f.
//
// Solidity: event ClaimCuratorFees(address indexed vault, address indexed token, uint256 amount)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) WatchClaimCuratorFees(opts *bind.WatchOpts, sink chan<- *IVaultSnapshotRewardsClaimCuratorFees, vault []common.Address, token []common.Address) (event.Subscription, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IVaultSnapshotRewards.contract.WatchLogs(opts, "ClaimCuratorFees", vaultRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IVaultSnapshotRewardsClaimCuratorFees)
				if err := _IVaultSnapshotRewards.contract.UnpackLog(event, "ClaimCuratorFees", log); err != nil {
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

// ParseClaimCuratorFees is a log parse operation binding the contract event 0xb8168ce970fea31a66517b0f2b9064db1aca670e136fe6bbe873ed3725b7578f.
//
// Solidity: event ClaimCuratorFees(address indexed vault, address indexed token, uint256 amount)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) ParseClaimCuratorFees(log types.Log) (*IVaultSnapshotRewardsClaimCuratorFees, error) {
	event := new(IVaultSnapshotRewardsClaimCuratorFees)
	if err := _IVaultSnapshotRewards.contract.UnpackLog(event, "ClaimCuratorFees", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IVaultSnapshotRewardsClaimOperatorFeesIterator is returned from FilterClaimOperatorFees and is used to iterate over the raw logs and unpacked data for ClaimOperatorFees events raised by the IVaultSnapshotRewards contract.
type IVaultSnapshotRewardsClaimOperatorFeesIterator struct {
	Event *IVaultSnapshotRewardsClaimOperatorFees // Event containing the contract specifics and raw log

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
func (it *IVaultSnapshotRewardsClaimOperatorFeesIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IVaultSnapshotRewardsClaimOperatorFees)
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
		it.Event = new(IVaultSnapshotRewardsClaimOperatorFees)
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
func (it *IVaultSnapshotRewardsClaimOperatorFeesIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IVaultSnapshotRewardsClaimOperatorFeesIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IVaultSnapshotRewardsClaimOperatorFees represents a ClaimOperatorFees event raised by the IVaultSnapshotRewards contract.
type IVaultSnapshotRewardsClaimOperatorFees struct {
	Operator           common.Address
	Network            common.Address
	Token              common.Address
	Vault              common.Address
	Amount             *big.Int
	FirstClaimedReward *big.Int
	RewardsClaimed     *big.Int
	Raw                types.Log // Blockchain specific contextual infos
}

// FilterClaimOperatorFees is a free log retrieval operation binding the contract event 0x2872e04442f4ef6a9f172193eb9124e865aacc91e5075fd9a8bd258d238cd9c7.
//
// Solidity: event ClaimOperatorFees(address indexed operator, address indexed network, address indexed token, address vault, uint256 amount, uint256 firstClaimedReward, uint256 rewardsClaimed)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) FilterClaimOperatorFees(opts *bind.FilterOpts, operator []common.Address, network []common.Address, token []common.Address) (*IVaultSnapshotRewardsClaimOperatorFeesIterator, error) {

	var operatorRule []interface{}
	for _, operatorItem := range operator {
		operatorRule = append(operatorRule, operatorItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IVaultSnapshotRewards.contract.FilterLogs(opts, "ClaimOperatorFees", operatorRule, networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return &IVaultSnapshotRewardsClaimOperatorFeesIterator{contract: _IVaultSnapshotRewards.contract, event: "ClaimOperatorFees", logs: logs, sub: sub}, nil
}

// WatchClaimOperatorFees is a free log subscription operation binding the contract event 0x2872e04442f4ef6a9f172193eb9124e865aacc91e5075fd9a8bd258d238cd9c7.
//
// Solidity: event ClaimOperatorFees(address indexed operator, address indexed network, address indexed token, address vault, uint256 amount, uint256 firstClaimedReward, uint256 rewardsClaimed)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) WatchClaimOperatorFees(opts *bind.WatchOpts, sink chan<- *IVaultSnapshotRewardsClaimOperatorFees, operator []common.Address, network []common.Address, token []common.Address) (event.Subscription, error) {

	var operatorRule []interface{}
	for _, operatorItem := range operator {
		operatorRule = append(operatorRule, operatorItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IVaultSnapshotRewards.contract.WatchLogs(opts, "ClaimOperatorFees", operatorRule, networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IVaultSnapshotRewardsClaimOperatorFees)
				if err := _IVaultSnapshotRewards.contract.UnpackLog(event, "ClaimOperatorFees", log); err != nil {
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

// ParseClaimOperatorFees is a log parse operation binding the contract event 0x2872e04442f4ef6a9f172193eb9124e865aacc91e5075fd9a8bd258d238cd9c7.
//
// Solidity: event ClaimOperatorFees(address indexed operator, address indexed network, address indexed token, address vault, uint256 amount, uint256 firstClaimedReward, uint256 rewardsClaimed)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) ParseClaimOperatorFees(log types.Log) (*IVaultSnapshotRewardsClaimOperatorFees, error) {
	event := new(IVaultSnapshotRewardsClaimOperatorFees)
	if err := _IVaultSnapshotRewards.contract.UnpackLog(event, "ClaimOperatorFees", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IVaultSnapshotRewardsClaimVaultSnapshotRewardsIterator is returned from FilterClaimVaultSnapshotRewards and is used to iterate over the raw logs and unpacked data for ClaimVaultSnapshotRewards events raised by the IVaultSnapshotRewards contract.
type IVaultSnapshotRewardsClaimVaultSnapshotRewardsIterator struct {
	Event *IVaultSnapshotRewardsClaimVaultSnapshotRewards // Event containing the contract specifics and raw log

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
func (it *IVaultSnapshotRewardsClaimVaultSnapshotRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IVaultSnapshotRewardsClaimVaultSnapshotRewards)
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
		it.Event = new(IVaultSnapshotRewardsClaimVaultSnapshotRewards)
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
func (it *IVaultSnapshotRewardsClaimVaultSnapshotRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IVaultSnapshotRewardsClaimVaultSnapshotRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IVaultSnapshotRewardsClaimVaultSnapshotRewards represents a ClaimVaultSnapshotRewards event raised by the IVaultSnapshotRewards contract.
type IVaultSnapshotRewardsClaimVaultSnapshotRewards struct {
	Staker             common.Address
	Network            common.Address
	Token              common.Address
	Vault              common.Address
	Amount             *big.Int
	FirstClaimedReward *big.Int
	RewardsClaimed     *big.Int
	Raw                types.Log // Blockchain specific contextual infos
}

// FilterClaimVaultSnapshotRewards is a free log retrieval operation binding the contract event 0x562a5f332b412e2aa1bf870f00bf6d1abcf4ea35d40a9e77f5f321f47156d2b4.
//
// Solidity: event ClaimVaultSnapshotRewards(address indexed staker, address indexed network, address indexed token, address vault, uint256 amount, uint256 firstClaimedReward, uint256 rewardsClaimed)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) FilterClaimVaultSnapshotRewards(opts *bind.FilterOpts, staker []common.Address, network []common.Address, token []common.Address) (*IVaultSnapshotRewardsClaimVaultSnapshotRewardsIterator, error) {

	var stakerRule []interface{}
	for _, stakerItem := range staker {
		stakerRule = append(stakerRule, stakerItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IVaultSnapshotRewards.contract.FilterLogs(opts, "ClaimVaultSnapshotRewards", stakerRule, networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return &IVaultSnapshotRewardsClaimVaultSnapshotRewardsIterator{contract: _IVaultSnapshotRewards.contract, event: "ClaimVaultSnapshotRewards", logs: logs, sub: sub}, nil
}

// WatchClaimVaultSnapshotRewards is a free log subscription operation binding the contract event 0x562a5f332b412e2aa1bf870f00bf6d1abcf4ea35d40a9e77f5f321f47156d2b4.
//
// Solidity: event ClaimVaultSnapshotRewards(address indexed staker, address indexed network, address indexed token, address vault, uint256 amount, uint256 firstClaimedReward, uint256 rewardsClaimed)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) WatchClaimVaultSnapshotRewards(opts *bind.WatchOpts, sink chan<- *IVaultSnapshotRewardsClaimVaultSnapshotRewards, staker []common.Address, network []common.Address, token []common.Address) (event.Subscription, error) {

	var stakerRule []interface{}
	for _, stakerItem := range staker {
		stakerRule = append(stakerRule, stakerItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IVaultSnapshotRewards.contract.WatchLogs(opts, "ClaimVaultSnapshotRewards", stakerRule, networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IVaultSnapshotRewardsClaimVaultSnapshotRewards)
				if err := _IVaultSnapshotRewards.contract.UnpackLog(event, "ClaimVaultSnapshotRewards", log); err != nil {
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

// ParseClaimVaultSnapshotRewards is a log parse operation binding the contract event 0x562a5f332b412e2aa1bf870f00bf6d1abcf4ea35d40a9e77f5f321f47156d2b4.
//
// Solidity: event ClaimVaultSnapshotRewards(address indexed staker, address indexed network, address indexed token, address vault, uint256 amount, uint256 firstClaimedReward, uint256 rewardsClaimed)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) ParseClaimVaultSnapshotRewards(log types.Log) (*IVaultSnapshotRewardsClaimVaultSnapshotRewards, error) {
	event := new(IVaultSnapshotRewardsClaimVaultSnapshotRewards)
	if err := _IVaultSnapshotRewards.contract.UnpackLog(event, "ClaimVaultSnapshotRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IVaultSnapshotRewardsDistributeVaultSnapshotRewardsIterator is returned from FilterDistributeVaultSnapshotRewards and is used to iterate over the raw logs and unpacked data for DistributeVaultSnapshotRewards events raised by the IVaultSnapshotRewards contract.
type IVaultSnapshotRewardsDistributeVaultSnapshotRewardsIterator struct {
	Event *IVaultSnapshotRewardsDistributeVaultSnapshotRewards // Event containing the contract specifics and raw log

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
func (it *IVaultSnapshotRewardsDistributeVaultSnapshotRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IVaultSnapshotRewardsDistributeVaultSnapshotRewards)
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
		it.Event = new(IVaultSnapshotRewardsDistributeVaultSnapshotRewards)
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
func (it *IVaultSnapshotRewardsDistributeVaultSnapshotRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IVaultSnapshotRewardsDistributeVaultSnapshotRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IVaultSnapshotRewardsDistributeVaultSnapshotRewards represents a DistributeVaultSnapshotRewards event raised by the IVaultSnapshotRewards contract.
type IVaultSnapshotRewardsDistributeVaultSnapshotRewards struct {
	Network       common.Address
	Token         common.Address
	Vault         common.Address
	SubnetworkId  *big.Int
	Timestamp     *big.Int
	Amount        *big.Int
	CuratorFees   *big.Int
	OperatorsFees *big.Int
	Raw           types.Log // Blockchain specific contextual infos
}

// FilterDistributeVaultSnapshotRewards is a free log retrieval operation binding the contract event 0xdc66ca60d459d7b828ed44c7634bd7302ddcc804baf46ce96fa74d29a232d4c3.
//
// Solidity: event DistributeVaultSnapshotRewards(address indexed network, address indexed token, address indexed vault, uint96 subnetworkId, uint48 timestamp, uint256 amount, uint256 curatorFees, uint256 operatorsFees)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) FilterDistributeVaultSnapshotRewards(opts *bind.FilterOpts, network []common.Address, token []common.Address, vault []common.Address) (*IVaultSnapshotRewardsDistributeVaultSnapshotRewardsIterator, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}
	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IVaultSnapshotRewards.contract.FilterLogs(opts, "DistributeVaultSnapshotRewards", networkRule, tokenRule, vaultRule)
	if err != nil {
		return nil, err
	}
	return &IVaultSnapshotRewardsDistributeVaultSnapshotRewardsIterator{contract: _IVaultSnapshotRewards.contract, event: "DistributeVaultSnapshotRewards", logs: logs, sub: sub}, nil
}

// WatchDistributeVaultSnapshotRewards is a free log subscription operation binding the contract event 0xdc66ca60d459d7b828ed44c7634bd7302ddcc804baf46ce96fa74d29a232d4c3.
//
// Solidity: event DistributeVaultSnapshotRewards(address indexed network, address indexed token, address indexed vault, uint96 subnetworkId, uint48 timestamp, uint256 amount, uint256 curatorFees, uint256 operatorsFees)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) WatchDistributeVaultSnapshotRewards(opts *bind.WatchOpts, sink chan<- *IVaultSnapshotRewardsDistributeVaultSnapshotRewards, network []common.Address, token []common.Address, vault []common.Address) (event.Subscription, error) {

	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}
	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IVaultSnapshotRewards.contract.WatchLogs(opts, "DistributeVaultSnapshotRewards", networkRule, tokenRule, vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IVaultSnapshotRewardsDistributeVaultSnapshotRewards)
				if err := _IVaultSnapshotRewards.contract.UnpackLog(event, "DistributeVaultSnapshotRewards", log); err != nil {
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

// ParseDistributeVaultSnapshotRewards is a log parse operation binding the contract event 0xdc66ca60d459d7b828ed44c7634bd7302ddcc804baf46ce96fa74d29a232d4c3.
//
// Solidity: event DistributeVaultSnapshotRewards(address indexed network, address indexed token, address indexed vault, uint96 subnetworkId, uint48 timestamp, uint256 amount, uint256 curatorFees, uint256 operatorsFees)
func (_IVaultSnapshotRewards *IVaultSnapshotRewardsFilterer) ParseDistributeVaultSnapshotRewards(log types.Log) (*IVaultSnapshotRewardsDistributeVaultSnapshotRewards, error) {
	event := new(IVaultSnapshotRewardsDistributeVaultSnapshotRewards)
	if err := _IVaultSnapshotRewards.contract.UnpackLog(event, "DistributeVaultSnapshotRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
