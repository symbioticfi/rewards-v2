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

// IVaultV2MetaData contains all meta data concerning the IVaultV2 contract.
var IVaultV2MetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"activeSharesAt\",\"inputs\":[{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hint\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"activeSharesOfAt\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hint\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"activeStakeAt\",\"inputs\":[{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hint\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"activeWithdrawalSharesAt\",\"inputs\":[{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"activeWithdrawalSharesOfAt\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"activeWithdrawalsAt\",\"inputs\":[{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"collateral\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"delegator\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"donate\",\"inputs\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"}]",
}

// IVaultV2ABI is the input ABI used to generate the binding from.
// Deprecated: Use IVaultV2MetaData.ABI instead.
var IVaultV2ABI = IVaultV2MetaData.ABI

// IVaultV2 is an auto generated Go binding around an Ethereum contract.
type IVaultV2 struct {
	IVaultV2Caller     // Read-only binding to the contract
	IVaultV2Transactor // Write-only binding to the contract
	IVaultV2Filterer   // Log filterer for contract events
}

// IVaultV2Caller is an auto generated read-only Go binding around an Ethereum contract.
type IVaultV2Caller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IVaultV2Transactor is an auto generated write-only Go binding around an Ethereum contract.
type IVaultV2Transactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IVaultV2Filterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IVaultV2Filterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IVaultV2Session is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IVaultV2Session struct {
	Contract     *IVaultV2         // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IVaultV2CallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IVaultV2CallerSession struct {
	Contract *IVaultV2Caller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts   // Call options to use throughout this session
}

// IVaultV2TransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IVaultV2TransactorSession struct {
	Contract     *IVaultV2Transactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
}

// IVaultV2Raw is an auto generated low-level Go binding around an Ethereum contract.
type IVaultV2Raw struct {
	Contract *IVaultV2 // Generic contract binding to access the raw methods on
}

// IVaultV2CallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IVaultV2CallerRaw struct {
	Contract *IVaultV2Caller // Generic read-only contract binding to access the raw methods on
}

// IVaultV2TransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IVaultV2TransactorRaw struct {
	Contract *IVaultV2Transactor // Generic write-only contract binding to access the raw methods on
}

// NewIVaultV2 creates a new instance of IVaultV2, bound to a specific deployed contract.
func NewIVaultV2(address common.Address, backend bind.ContractBackend) (*IVaultV2, error) {
	contract, err := bindIVaultV2(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IVaultV2{IVaultV2Caller: IVaultV2Caller{contract: contract}, IVaultV2Transactor: IVaultV2Transactor{contract: contract}, IVaultV2Filterer: IVaultV2Filterer{contract: contract}}, nil
}

// NewIVaultV2Caller creates a new read-only instance of IVaultV2, bound to a specific deployed contract.
func NewIVaultV2Caller(address common.Address, caller bind.ContractCaller) (*IVaultV2Caller, error) {
	contract, err := bindIVaultV2(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IVaultV2Caller{contract: contract}, nil
}

// NewIVaultV2Transactor creates a new write-only instance of IVaultV2, bound to a specific deployed contract.
func NewIVaultV2Transactor(address common.Address, transactor bind.ContractTransactor) (*IVaultV2Transactor, error) {
	contract, err := bindIVaultV2(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IVaultV2Transactor{contract: contract}, nil
}

// NewIVaultV2Filterer creates a new log filterer instance of IVaultV2, bound to a specific deployed contract.
func NewIVaultV2Filterer(address common.Address, filterer bind.ContractFilterer) (*IVaultV2Filterer, error) {
	contract, err := bindIVaultV2(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IVaultV2Filterer{contract: contract}, nil
}

// bindIVaultV2 binds a generic wrapper to an already deployed contract.
func bindIVaultV2(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := IVaultV2MetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IVaultV2 *IVaultV2Raw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IVaultV2.Contract.IVaultV2Caller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IVaultV2 *IVaultV2Raw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IVaultV2.Contract.IVaultV2Transactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IVaultV2 *IVaultV2Raw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IVaultV2.Contract.IVaultV2Transactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IVaultV2 *IVaultV2CallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IVaultV2.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IVaultV2 *IVaultV2TransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IVaultV2.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IVaultV2 *IVaultV2TransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IVaultV2.Contract.contract.Transact(opts, method, params...)
}

// ActiveSharesAt is a free data retrieval call binding the contract method 0x50f22068.
//
// Solidity: function activeSharesAt(uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2Caller) ActiveSharesAt(opts *bind.CallOpts, timestamp *big.Int, hint []byte) (*big.Int, error) {
	var out []interface{}
	err := _IVaultV2.contract.Call(opts, &out, "activeSharesAt", timestamp, hint)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ActiveSharesAt is a free data retrieval call binding the contract method 0x50f22068.
//
// Solidity: function activeSharesAt(uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2Session) ActiveSharesAt(timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveSharesAt(&_IVaultV2.CallOpts, timestamp, hint)
}

// ActiveSharesAt is a free data retrieval call binding the contract method 0x50f22068.
//
// Solidity: function activeSharesAt(uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2CallerSession) ActiveSharesAt(timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveSharesAt(&_IVaultV2.CallOpts, timestamp, hint)
}

// ActiveSharesOfAt is a free data retrieval call binding the contract method 0x2d73c69c.
//
// Solidity: function activeSharesOfAt(address account, uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2Caller) ActiveSharesOfAt(opts *bind.CallOpts, account common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	var out []interface{}
	err := _IVaultV2.contract.Call(opts, &out, "activeSharesOfAt", account, timestamp, hint)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ActiveSharesOfAt is a free data retrieval call binding the contract method 0x2d73c69c.
//
// Solidity: function activeSharesOfAt(address account, uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2Session) ActiveSharesOfAt(account common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveSharesOfAt(&_IVaultV2.CallOpts, account, timestamp, hint)
}

// ActiveSharesOfAt is a free data retrieval call binding the contract method 0x2d73c69c.
//
// Solidity: function activeSharesOfAt(address account, uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2CallerSession) ActiveSharesOfAt(account common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveSharesOfAt(&_IVaultV2.CallOpts, account, timestamp, hint)
}

// ActiveStakeAt is a free data retrieval call binding the contract method 0x810da75d.
//
// Solidity: function activeStakeAt(uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2Caller) ActiveStakeAt(opts *bind.CallOpts, timestamp *big.Int, hint []byte) (*big.Int, error) {
	var out []interface{}
	err := _IVaultV2.contract.Call(opts, &out, "activeStakeAt", timestamp, hint)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ActiveStakeAt is a free data retrieval call binding the contract method 0x810da75d.
//
// Solidity: function activeStakeAt(uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2Session) ActiveStakeAt(timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveStakeAt(&_IVaultV2.CallOpts, timestamp, hint)
}

// ActiveStakeAt is a free data retrieval call binding the contract method 0x810da75d.
//
// Solidity: function activeStakeAt(uint48 timestamp, bytes hint) view returns(uint256)
func (_IVaultV2 *IVaultV2CallerSession) ActiveStakeAt(timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveStakeAt(&_IVaultV2.CallOpts, timestamp, hint)
}

// ActiveWithdrawalSharesAt is a free data retrieval call binding the contract method 0x13e0f932.
//
// Solidity: function activeWithdrawalSharesAt(uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2Caller) ActiveWithdrawalSharesAt(opts *bind.CallOpts, timestamp *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _IVaultV2.contract.Call(opts, &out, "activeWithdrawalSharesAt", timestamp)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ActiveWithdrawalSharesAt is a free data retrieval call binding the contract method 0x13e0f932.
//
// Solidity: function activeWithdrawalSharesAt(uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2Session) ActiveWithdrawalSharesAt(timestamp *big.Int) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveWithdrawalSharesAt(&_IVaultV2.CallOpts, timestamp)
}

// ActiveWithdrawalSharesAt is a free data retrieval call binding the contract method 0x13e0f932.
//
// Solidity: function activeWithdrawalSharesAt(uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2CallerSession) ActiveWithdrawalSharesAt(timestamp *big.Int) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveWithdrawalSharesAt(&_IVaultV2.CallOpts, timestamp)
}

// ActiveWithdrawalSharesOfAt is a free data retrieval call binding the contract method 0xb039876a.
//
// Solidity: function activeWithdrawalSharesOfAt(address account, uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2Caller) ActiveWithdrawalSharesOfAt(opts *bind.CallOpts, account common.Address, timestamp *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _IVaultV2.contract.Call(opts, &out, "activeWithdrawalSharesOfAt", account, timestamp)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ActiveWithdrawalSharesOfAt is a free data retrieval call binding the contract method 0xb039876a.
//
// Solidity: function activeWithdrawalSharesOfAt(address account, uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2Session) ActiveWithdrawalSharesOfAt(account common.Address, timestamp *big.Int) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveWithdrawalSharesOfAt(&_IVaultV2.CallOpts, account, timestamp)
}

// ActiveWithdrawalSharesOfAt is a free data retrieval call binding the contract method 0xb039876a.
//
// Solidity: function activeWithdrawalSharesOfAt(address account, uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2CallerSession) ActiveWithdrawalSharesOfAt(account common.Address, timestamp *big.Int) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveWithdrawalSharesOfAt(&_IVaultV2.CallOpts, account, timestamp)
}

// ActiveWithdrawalsAt is a free data retrieval call binding the contract method 0xaee9d015.
//
// Solidity: function activeWithdrawalsAt(uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2Caller) ActiveWithdrawalsAt(opts *bind.CallOpts, timestamp *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _IVaultV2.contract.Call(opts, &out, "activeWithdrawalsAt", timestamp)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ActiveWithdrawalsAt is a free data retrieval call binding the contract method 0xaee9d015.
//
// Solidity: function activeWithdrawalsAt(uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2Session) ActiveWithdrawalsAt(timestamp *big.Int) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveWithdrawalsAt(&_IVaultV2.CallOpts, timestamp)
}

// ActiveWithdrawalsAt is a free data retrieval call binding the contract method 0xaee9d015.
//
// Solidity: function activeWithdrawalsAt(uint48 timestamp) view returns(uint256)
func (_IVaultV2 *IVaultV2CallerSession) ActiveWithdrawalsAt(timestamp *big.Int) (*big.Int, error) {
	return _IVaultV2.Contract.ActiveWithdrawalsAt(&_IVaultV2.CallOpts, timestamp)
}

// Collateral is a free data retrieval call binding the contract method 0xd8dfeb45.
//
// Solidity: function collateral() view returns(address)
func (_IVaultV2 *IVaultV2Caller) Collateral(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IVaultV2.contract.Call(opts, &out, "collateral")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Collateral is a free data retrieval call binding the contract method 0xd8dfeb45.
//
// Solidity: function collateral() view returns(address)
func (_IVaultV2 *IVaultV2Session) Collateral() (common.Address, error) {
	return _IVaultV2.Contract.Collateral(&_IVaultV2.CallOpts)
}

// Collateral is a free data retrieval call binding the contract method 0xd8dfeb45.
//
// Solidity: function collateral() view returns(address)
func (_IVaultV2 *IVaultV2CallerSession) Collateral() (common.Address, error) {
	return _IVaultV2.Contract.Collateral(&_IVaultV2.CallOpts)
}

// Delegator is a free data retrieval call binding the contract method 0xce9b7930.
//
// Solidity: function delegator() view returns(address)
func (_IVaultV2 *IVaultV2Caller) Delegator(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IVaultV2.contract.Call(opts, &out, "delegator")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Delegator is a free data retrieval call binding the contract method 0xce9b7930.
//
// Solidity: function delegator() view returns(address)
func (_IVaultV2 *IVaultV2Session) Delegator() (common.Address, error) {
	return _IVaultV2.Contract.Delegator(&_IVaultV2.CallOpts)
}

// Delegator is a free data retrieval call binding the contract method 0xce9b7930.
//
// Solidity: function delegator() view returns(address)
func (_IVaultV2 *IVaultV2CallerSession) Delegator() (common.Address, error) {
	return _IVaultV2.Contract.Delegator(&_IVaultV2.CallOpts)
}

// Donate is a paid mutator transaction binding the contract method 0xf14faf6f.
//
// Solidity: function donate(uint256 amount) returns()
func (_IVaultV2 *IVaultV2Transactor) Donate(opts *bind.TransactOpts, amount *big.Int) (*types.Transaction, error) {
	return _IVaultV2.contract.Transact(opts, "donate", amount)
}

// Donate is a paid mutator transaction binding the contract method 0xf14faf6f.
//
// Solidity: function donate(uint256 amount) returns()
func (_IVaultV2 *IVaultV2Session) Donate(amount *big.Int) (*types.Transaction, error) {
	return _IVaultV2.Contract.Donate(&_IVaultV2.TransactOpts, amount)
}

// Donate is a paid mutator transaction binding the contract method 0xf14faf6f.
//
// Solidity: function donate(uint256 amount) returns()
func (_IVaultV2 *IVaultV2TransactorSession) Donate(amount *big.Int) (*types.Transaction, error) {
	return _IVaultV2.Contract.Donate(&_IVaultV2.TransactOpts, amount)
}
