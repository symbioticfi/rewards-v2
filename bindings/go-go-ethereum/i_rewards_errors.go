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

// IRewardsErrorsMetaData contains all meta data concerning the IRewardsErrors contract.
var IRewardsErrorsMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"error\",\"name\":\"InsufficientClaimableFees\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InsufficientDeposit\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InsufficientReward\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidDelegatorType\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidLastUnclaimedReward\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidMerkleProof\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidMerkleRoot\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidRecipient\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidRewardTimestamp\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidSignature\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidTimestamp\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidToken\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoCumulativeRewardsToClaim\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoDonationSupport\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoRewardsToClaim\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotCurator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotNetworkOrMiddleware\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotOperator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotRewarder\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotVault\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"RootAlreadySet\",\"inputs\":[]}]",
}

// IRewardsErrorsABI is the input ABI used to generate the binding from.
// Deprecated: Use IRewardsErrorsMetaData.ABI instead.
var IRewardsErrorsABI = IRewardsErrorsMetaData.ABI

// IRewardsErrors is an auto generated Go binding around an Ethereum contract.
type IRewardsErrors struct {
	IRewardsErrorsCaller     // Read-only binding to the contract
	IRewardsErrorsTransactor // Write-only binding to the contract
	IRewardsErrorsFilterer   // Log filterer for contract events
}

// IRewardsErrorsCaller is an auto generated read-only Go binding around an Ethereum contract.
type IRewardsErrorsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IRewardsErrorsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IRewardsErrorsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IRewardsErrorsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IRewardsErrorsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IRewardsErrorsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IRewardsErrorsSession struct {
	Contract     *IRewardsErrors   // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IRewardsErrorsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IRewardsErrorsCallerSession struct {
	Contract *IRewardsErrorsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts         // Call options to use throughout this session
}

// IRewardsErrorsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IRewardsErrorsTransactorSession struct {
	Contract     *IRewardsErrorsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts         // Transaction auth options to use throughout this session
}

// IRewardsErrorsRaw is an auto generated low-level Go binding around an Ethereum contract.
type IRewardsErrorsRaw struct {
	Contract *IRewardsErrors // Generic contract binding to access the raw methods on
}

// IRewardsErrorsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IRewardsErrorsCallerRaw struct {
	Contract *IRewardsErrorsCaller // Generic read-only contract binding to access the raw methods on
}

// IRewardsErrorsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IRewardsErrorsTransactorRaw struct {
	Contract *IRewardsErrorsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIRewardsErrors creates a new instance of IRewardsErrors, bound to a specific deployed contract.
func NewIRewardsErrors(address common.Address, backend bind.ContractBackend) (*IRewardsErrors, error) {
	contract, err := bindIRewardsErrors(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IRewardsErrors{IRewardsErrorsCaller: IRewardsErrorsCaller{contract: contract}, IRewardsErrorsTransactor: IRewardsErrorsTransactor{contract: contract}, IRewardsErrorsFilterer: IRewardsErrorsFilterer{contract: contract}}, nil
}

// NewIRewardsErrorsCaller creates a new read-only instance of IRewardsErrors, bound to a specific deployed contract.
func NewIRewardsErrorsCaller(address common.Address, caller bind.ContractCaller) (*IRewardsErrorsCaller, error) {
	contract, err := bindIRewardsErrors(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IRewardsErrorsCaller{contract: contract}, nil
}

// NewIRewardsErrorsTransactor creates a new write-only instance of IRewardsErrors, bound to a specific deployed contract.
func NewIRewardsErrorsTransactor(address common.Address, transactor bind.ContractTransactor) (*IRewardsErrorsTransactor, error) {
	contract, err := bindIRewardsErrors(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IRewardsErrorsTransactor{contract: contract}, nil
}

// NewIRewardsErrorsFilterer creates a new log filterer instance of IRewardsErrors, bound to a specific deployed contract.
func NewIRewardsErrorsFilterer(address common.Address, filterer bind.ContractFilterer) (*IRewardsErrorsFilterer, error) {
	contract, err := bindIRewardsErrors(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IRewardsErrorsFilterer{contract: contract}, nil
}

// bindIRewardsErrors binds a generic wrapper to an already deployed contract.
func bindIRewardsErrors(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := IRewardsErrorsMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IRewardsErrors *IRewardsErrorsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IRewardsErrors.Contract.IRewardsErrorsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IRewardsErrors *IRewardsErrorsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IRewardsErrors.Contract.IRewardsErrorsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IRewardsErrors *IRewardsErrorsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IRewardsErrors.Contract.IRewardsErrorsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IRewardsErrors *IRewardsErrorsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IRewardsErrors.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IRewardsErrors *IRewardsErrorsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IRewardsErrors.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IRewardsErrors *IRewardsErrorsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IRewardsErrors.Contract.contract.Transact(opts, method, params...)
}
