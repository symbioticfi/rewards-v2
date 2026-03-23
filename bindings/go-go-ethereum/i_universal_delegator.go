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

// IUniversalDelegatorMetaData contains all meta data concerning the IUniversalDelegator contract.
var IUniversalDelegatorMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"getAllocatedAt\",\"inputs\":[{\"name\":\"subnetwork\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"operator\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"duration\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getFilledAt\",\"inputs\":[{\"name\":\"index\",\"type\":\"uint96\",\"internalType\":\"uint96\"},{\"name\":\"duration\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getSlotOfNetworkAt\",\"inputs\":[{\"name\":\"subnetwork\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint96\",\"internalType\":\"uint96\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"migrateTimestamp\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint48\",\"internalType\":\"uint48\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"oldDelegator\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"}]",
}

// IUniversalDelegatorABI is the input ABI used to generate the binding from.
// Deprecated: Use IUniversalDelegatorMetaData.ABI instead.
var IUniversalDelegatorABI = IUniversalDelegatorMetaData.ABI

// IUniversalDelegator is an auto generated Go binding around an Ethereum contract.
type IUniversalDelegator struct {
	IUniversalDelegatorCaller     // Read-only binding to the contract
	IUniversalDelegatorTransactor // Write-only binding to the contract
	IUniversalDelegatorFilterer   // Log filterer for contract events
}

// IUniversalDelegatorCaller is an auto generated read-only Go binding around an Ethereum contract.
type IUniversalDelegatorCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IUniversalDelegatorTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IUniversalDelegatorTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IUniversalDelegatorFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IUniversalDelegatorFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IUniversalDelegatorSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IUniversalDelegatorSession struct {
	Contract     *IUniversalDelegator // Generic contract binding to set the session for
	CallOpts     bind.CallOpts        // Call options to use throughout this session
	TransactOpts bind.TransactOpts    // Transaction auth options to use throughout this session
}

// IUniversalDelegatorCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IUniversalDelegatorCallerSession struct {
	Contract *IUniversalDelegatorCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts              // Call options to use throughout this session
}

// IUniversalDelegatorTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IUniversalDelegatorTransactorSession struct {
	Contract     *IUniversalDelegatorTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts              // Transaction auth options to use throughout this session
}

// IUniversalDelegatorRaw is an auto generated low-level Go binding around an Ethereum contract.
type IUniversalDelegatorRaw struct {
	Contract *IUniversalDelegator // Generic contract binding to access the raw methods on
}

// IUniversalDelegatorCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IUniversalDelegatorCallerRaw struct {
	Contract *IUniversalDelegatorCaller // Generic read-only contract binding to access the raw methods on
}

// IUniversalDelegatorTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IUniversalDelegatorTransactorRaw struct {
	Contract *IUniversalDelegatorTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIUniversalDelegator creates a new instance of IUniversalDelegator, bound to a specific deployed contract.
func NewIUniversalDelegator(address common.Address, backend bind.ContractBackend) (*IUniversalDelegator, error) {
	contract, err := bindIUniversalDelegator(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IUniversalDelegator{IUniversalDelegatorCaller: IUniversalDelegatorCaller{contract: contract}, IUniversalDelegatorTransactor: IUniversalDelegatorTransactor{contract: contract}, IUniversalDelegatorFilterer: IUniversalDelegatorFilterer{contract: contract}}, nil
}

// NewIUniversalDelegatorCaller creates a new read-only instance of IUniversalDelegator, bound to a specific deployed contract.
func NewIUniversalDelegatorCaller(address common.Address, caller bind.ContractCaller) (*IUniversalDelegatorCaller, error) {
	contract, err := bindIUniversalDelegator(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IUniversalDelegatorCaller{contract: contract}, nil
}

// NewIUniversalDelegatorTransactor creates a new write-only instance of IUniversalDelegator, bound to a specific deployed contract.
func NewIUniversalDelegatorTransactor(address common.Address, transactor bind.ContractTransactor) (*IUniversalDelegatorTransactor, error) {
	contract, err := bindIUniversalDelegator(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IUniversalDelegatorTransactor{contract: contract}, nil
}

// NewIUniversalDelegatorFilterer creates a new log filterer instance of IUniversalDelegator, bound to a specific deployed contract.
func NewIUniversalDelegatorFilterer(address common.Address, filterer bind.ContractFilterer) (*IUniversalDelegatorFilterer, error) {
	contract, err := bindIUniversalDelegator(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IUniversalDelegatorFilterer{contract: contract}, nil
}

// bindIUniversalDelegator binds a generic wrapper to an already deployed contract.
func bindIUniversalDelegator(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := IUniversalDelegatorMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IUniversalDelegator *IUniversalDelegatorRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IUniversalDelegator.Contract.IUniversalDelegatorCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IUniversalDelegator *IUniversalDelegatorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IUniversalDelegator.Contract.IUniversalDelegatorTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IUniversalDelegator *IUniversalDelegatorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IUniversalDelegator.Contract.IUniversalDelegatorTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IUniversalDelegator *IUniversalDelegatorCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IUniversalDelegator.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IUniversalDelegator *IUniversalDelegatorTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IUniversalDelegator.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IUniversalDelegator *IUniversalDelegatorTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IUniversalDelegator.Contract.contract.Transact(opts, method, params...)
}

// GetAllocatedAt is a free data retrieval call binding the contract method 0xacc878ca.
//
// Solidity: function getAllocatedAt(bytes32 subnetwork, address operator, uint48 duration, uint48 timestamp) view returns(uint256)
func (_IUniversalDelegator *IUniversalDelegatorCaller) GetAllocatedAt(opts *bind.CallOpts, subnetwork [32]byte, operator common.Address, duration *big.Int, timestamp *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _IUniversalDelegator.contract.Call(opts, &out, "getAllocatedAt", subnetwork, operator, duration, timestamp)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetAllocatedAt is a free data retrieval call binding the contract method 0xacc878ca.
//
// Solidity: function getAllocatedAt(bytes32 subnetwork, address operator, uint48 duration, uint48 timestamp) view returns(uint256)
func (_IUniversalDelegator *IUniversalDelegatorSession) GetAllocatedAt(subnetwork [32]byte, operator common.Address, duration *big.Int, timestamp *big.Int) (*big.Int, error) {
	return _IUniversalDelegator.Contract.GetAllocatedAt(&_IUniversalDelegator.CallOpts, subnetwork, operator, duration, timestamp)
}

// GetAllocatedAt is a free data retrieval call binding the contract method 0xacc878ca.
//
// Solidity: function getAllocatedAt(bytes32 subnetwork, address operator, uint48 duration, uint48 timestamp) view returns(uint256)
func (_IUniversalDelegator *IUniversalDelegatorCallerSession) GetAllocatedAt(subnetwork [32]byte, operator common.Address, duration *big.Int, timestamp *big.Int) (*big.Int, error) {
	return _IUniversalDelegator.Contract.GetAllocatedAt(&_IUniversalDelegator.CallOpts, subnetwork, operator, duration, timestamp)
}

// GetFilledAt is a free data retrieval call binding the contract method 0x09daba23.
//
// Solidity: function getFilledAt(uint96 index, uint48 duration, uint48 timestamp) view returns(uint256)
func (_IUniversalDelegator *IUniversalDelegatorCaller) GetFilledAt(opts *bind.CallOpts, index *big.Int, duration *big.Int, timestamp *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _IUniversalDelegator.contract.Call(opts, &out, "getFilledAt", index, duration, timestamp)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetFilledAt is a free data retrieval call binding the contract method 0x09daba23.
//
// Solidity: function getFilledAt(uint96 index, uint48 duration, uint48 timestamp) view returns(uint256)
func (_IUniversalDelegator *IUniversalDelegatorSession) GetFilledAt(index *big.Int, duration *big.Int, timestamp *big.Int) (*big.Int, error) {
	return _IUniversalDelegator.Contract.GetFilledAt(&_IUniversalDelegator.CallOpts, index, duration, timestamp)
}

// GetFilledAt is a free data retrieval call binding the contract method 0x09daba23.
//
// Solidity: function getFilledAt(uint96 index, uint48 duration, uint48 timestamp) view returns(uint256)
func (_IUniversalDelegator *IUniversalDelegatorCallerSession) GetFilledAt(index *big.Int, duration *big.Int, timestamp *big.Int) (*big.Int, error) {
	return _IUniversalDelegator.Contract.GetFilledAt(&_IUniversalDelegator.CallOpts, index, duration, timestamp)
}

// GetSlotOfNetworkAt is a free data retrieval call binding the contract method 0x22c1709e.
//
// Solidity: function getSlotOfNetworkAt(bytes32 subnetwork, uint48 timestamp) view returns(uint96)
func (_IUniversalDelegator *IUniversalDelegatorCaller) GetSlotOfNetworkAt(opts *bind.CallOpts, subnetwork [32]byte, timestamp *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _IUniversalDelegator.contract.Call(opts, &out, "getSlotOfNetworkAt", subnetwork, timestamp)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetSlotOfNetworkAt is a free data retrieval call binding the contract method 0x22c1709e.
//
// Solidity: function getSlotOfNetworkAt(bytes32 subnetwork, uint48 timestamp) view returns(uint96)
func (_IUniversalDelegator *IUniversalDelegatorSession) GetSlotOfNetworkAt(subnetwork [32]byte, timestamp *big.Int) (*big.Int, error) {
	return _IUniversalDelegator.Contract.GetSlotOfNetworkAt(&_IUniversalDelegator.CallOpts, subnetwork, timestamp)
}

// GetSlotOfNetworkAt is a free data retrieval call binding the contract method 0x22c1709e.
//
// Solidity: function getSlotOfNetworkAt(bytes32 subnetwork, uint48 timestamp) view returns(uint96)
func (_IUniversalDelegator *IUniversalDelegatorCallerSession) GetSlotOfNetworkAt(subnetwork [32]byte, timestamp *big.Int) (*big.Int, error) {
	return _IUniversalDelegator.Contract.GetSlotOfNetworkAt(&_IUniversalDelegator.CallOpts, subnetwork, timestamp)
}

// MigrateTimestamp is a free data retrieval call binding the contract method 0x8a605ccd.
//
// Solidity: function migrateTimestamp() view returns(uint48)
func (_IUniversalDelegator *IUniversalDelegatorCaller) MigrateTimestamp(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IUniversalDelegator.contract.Call(opts, &out, "migrateTimestamp")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MigrateTimestamp is a free data retrieval call binding the contract method 0x8a605ccd.
//
// Solidity: function migrateTimestamp() view returns(uint48)
func (_IUniversalDelegator *IUniversalDelegatorSession) MigrateTimestamp() (*big.Int, error) {
	return _IUniversalDelegator.Contract.MigrateTimestamp(&_IUniversalDelegator.CallOpts)
}

// MigrateTimestamp is a free data retrieval call binding the contract method 0x8a605ccd.
//
// Solidity: function migrateTimestamp() view returns(uint48)
func (_IUniversalDelegator *IUniversalDelegatorCallerSession) MigrateTimestamp() (*big.Int, error) {
	return _IUniversalDelegator.Contract.MigrateTimestamp(&_IUniversalDelegator.CallOpts)
}

// OldDelegator is a free data retrieval call binding the contract method 0xa364bacd.
//
// Solidity: function oldDelegator() view returns(address)
func (_IUniversalDelegator *IUniversalDelegatorCaller) OldDelegator(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IUniversalDelegator.contract.Call(opts, &out, "oldDelegator")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// OldDelegator is a free data retrieval call binding the contract method 0xa364bacd.
//
// Solidity: function oldDelegator() view returns(address)
func (_IUniversalDelegator *IUniversalDelegatorSession) OldDelegator() (common.Address, error) {
	return _IUniversalDelegator.Contract.OldDelegator(&_IUniversalDelegator.CallOpts)
}

// OldDelegator is a free data retrieval call binding the contract method 0xa364bacd.
//
// Solidity: function oldDelegator() view returns(address)
func (_IUniversalDelegator *IUniversalDelegatorCallerSession) OldDelegator() (common.Address, error) {
	return _IUniversalDelegator.Contract.OldDelegator(&_IUniversalDelegator.CallOpts)
}
