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

// IRewardsBaseMetaData contains all meta data concerning the IRewardsBase contract.
var IRewardsBaseMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"claimRewards\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"}]",
}

// IRewardsBaseABI is the input ABI used to generate the binding from.
// Deprecated: Use IRewardsBaseMetaData.ABI instead.
var IRewardsBaseABI = IRewardsBaseMetaData.ABI

// IRewardsBase is an auto generated Go binding around an Ethereum contract.
type IRewardsBase struct {
	IRewardsBaseCaller     // Read-only binding to the contract
	IRewardsBaseTransactor // Write-only binding to the contract
	IRewardsBaseFilterer   // Log filterer for contract events
}

// IRewardsBaseCaller is an auto generated read-only Go binding around an Ethereum contract.
type IRewardsBaseCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IRewardsBaseTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IRewardsBaseTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IRewardsBaseFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IRewardsBaseFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IRewardsBaseSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IRewardsBaseSession struct {
	Contract     *IRewardsBase     // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IRewardsBaseCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IRewardsBaseCallerSession struct {
	Contract *IRewardsBaseCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts       // Call options to use throughout this session
}

// IRewardsBaseTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IRewardsBaseTransactorSession struct {
	Contract     *IRewardsBaseTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts       // Transaction auth options to use throughout this session
}

// IRewardsBaseRaw is an auto generated low-level Go binding around an Ethereum contract.
type IRewardsBaseRaw struct {
	Contract *IRewardsBase // Generic contract binding to access the raw methods on
}

// IRewardsBaseCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IRewardsBaseCallerRaw struct {
	Contract *IRewardsBaseCaller // Generic read-only contract binding to access the raw methods on
}

// IRewardsBaseTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IRewardsBaseTransactorRaw struct {
	Contract *IRewardsBaseTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIRewardsBase creates a new instance of IRewardsBase, bound to a specific deployed contract.
func NewIRewardsBase(address common.Address, backend bind.ContractBackend) (*IRewardsBase, error) {
	contract, err := bindIRewardsBase(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IRewardsBase{IRewardsBaseCaller: IRewardsBaseCaller{contract: contract}, IRewardsBaseTransactor: IRewardsBaseTransactor{contract: contract}, IRewardsBaseFilterer: IRewardsBaseFilterer{contract: contract}}, nil
}

// NewIRewardsBaseCaller creates a new read-only instance of IRewardsBase, bound to a specific deployed contract.
func NewIRewardsBaseCaller(address common.Address, caller bind.ContractCaller) (*IRewardsBaseCaller, error) {
	contract, err := bindIRewardsBase(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IRewardsBaseCaller{contract: contract}, nil
}

// NewIRewardsBaseTransactor creates a new write-only instance of IRewardsBase, bound to a specific deployed contract.
func NewIRewardsBaseTransactor(address common.Address, transactor bind.ContractTransactor) (*IRewardsBaseTransactor, error) {
	contract, err := bindIRewardsBase(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IRewardsBaseTransactor{contract: contract}, nil
}

// NewIRewardsBaseFilterer creates a new log filterer instance of IRewardsBase, bound to a specific deployed contract.
func NewIRewardsBaseFilterer(address common.Address, filterer bind.ContractFilterer) (*IRewardsBaseFilterer, error) {
	contract, err := bindIRewardsBase(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IRewardsBaseFilterer{contract: contract}, nil
}

// bindIRewardsBase binds a generic wrapper to an already deployed contract.
func bindIRewardsBase(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := IRewardsBaseMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IRewardsBase *IRewardsBaseRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IRewardsBase.Contract.IRewardsBaseCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IRewardsBase *IRewardsBaseRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IRewardsBase.Contract.IRewardsBaseTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IRewardsBase *IRewardsBaseRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IRewardsBase.Contract.IRewardsBaseTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IRewardsBase *IRewardsBaseCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IRewardsBase.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IRewardsBase *IRewardsBaseTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IRewardsBase.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IRewardsBase *IRewardsBaseTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IRewardsBase.Contract.contract.Transact(opts, method, params...)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IRewardsBase *IRewardsBaseTransactor) ClaimRewards(opts *bind.TransactOpts, recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IRewardsBase.contract.Transact(opts, "claimRewards", recipient, token, data)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IRewardsBase *IRewardsBaseSession) ClaimRewards(recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IRewardsBase.Contract.ClaimRewards(&_IRewardsBase.TransactOpts, recipient, token, data)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IRewardsBase *IRewardsBaseTransactorSession) ClaimRewards(recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IRewardsBase.Contract.ClaimRewards(&_IRewardsBase.TransactOpts, recipient, token, data)
}
