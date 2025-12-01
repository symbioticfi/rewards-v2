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

// IProtocolFeesMetaData contains all meta data concerning the IProtocolFees contract.
var IProtocolFeesMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"FEE_REGISTRY\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"MAX_FEE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"claimProtocolFees\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"fees\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"distributionToTotalAmount\",\"inputs\":[{\"name\":\"rewardsType\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"distributionAmount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"protocolFee\",\"inputs\":[{\"name\":\"rewardsType\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"protocolFees\",\"inputs\":[{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"totalToDistributionAmount\",\"inputs\":[{\"name\":\"rewardsType\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"totalDistributionAmount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"event\",\"name\":\"AccountProtocolFees\",\"inputs\":[{\"name\":\"rewardsType\",\"type\":\"uint64\",\"indexed\":true,\"internalType\":\"uint64\"},{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"fees\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ClaimProtocolFees\",\"inputs\":[{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"fees\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"InsufficientClaimableFees\",\"inputs\":[]}]",
}

// IProtocolFeesABI is the input ABI used to generate the binding from.
// Deprecated: Use IProtocolFeesMetaData.ABI instead.
var IProtocolFeesABI = IProtocolFeesMetaData.ABI

// IProtocolFees is an auto generated Go binding around an Ethereum contract.
type IProtocolFees struct {
	IProtocolFeesCaller     // Read-only binding to the contract
	IProtocolFeesTransactor // Write-only binding to the contract
	IProtocolFeesFilterer   // Log filterer for contract events
}

// IProtocolFeesCaller is an auto generated read-only Go binding around an Ethereum contract.
type IProtocolFeesCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IProtocolFeesTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IProtocolFeesTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IProtocolFeesFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IProtocolFeesFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IProtocolFeesSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IProtocolFeesSession struct {
	Contract     *IProtocolFees    // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IProtocolFeesCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IProtocolFeesCallerSession struct {
	Contract *IProtocolFeesCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts        // Call options to use throughout this session
}

// IProtocolFeesTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IProtocolFeesTransactorSession struct {
	Contract     *IProtocolFeesTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts        // Transaction auth options to use throughout this session
}

// IProtocolFeesRaw is an auto generated low-level Go binding around an Ethereum contract.
type IProtocolFeesRaw struct {
	Contract *IProtocolFees // Generic contract binding to access the raw methods on
}

// IProtocolFeesCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IProtocolFeesCallerRaw struct {
	Contract *IProtocolFeesCaller // Generic read-only contract binding to access the raw methods on
}

// IProtocolFeesTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IProtocolFeesTransactorRaw struct {
	Contract *IProtocolFeesTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIProtocolFees creates a new instance of IProtocolFees, bound to a specific deployed contract.
func NewIProtocolFees(address common.Address, backend bind.ContractBackend) (*IProtocolFees, error) {
	contract, err := bindIProtocolFees(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IProtocolFees{IProtocolFeesCaller: IProtocolFeesCaller{contract: contract}, IProtocolFeesTransactor: IProtocolFeesTransactor{contract: contract}, IProtocolFeesFilterer: IProtocolFeesFilterer{contract: contract}}, nil
}

// NewIProtocolFeesCaller creates a new read-only instance of IProtocolFees, bound to a specific deployed contract.
func NewIProtocolFeesCaller(address common.Address, caller bind.ContractCaller) (*IProtocolFeesCaller, error) {
	contract, err := bindIProtocolFees(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IProtocolFeesCaller{contract: contract}, nil
}

// NewIProtocolFeesTransactor creates a new write-only instance of IProtocolFees, bound to a specific deployed contract.
func NewIProtocolFeesTransactor(address common.Address, transactor bind.ContractTransactor) (*IProtocolFeesTransactor, error) {
	contract, err := bindIProtocolFees(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IProtocolFeesTransactor{contract: contract}, nil
}

// NewIProtocolFeesFilterer creates a new log filterer instance of IProtocolFees, bound to a specific deployed contract.
func NewIProtocolFeesFilterer(address common.Address, filterer bind.ContractFilterer) (*IProtocolFeesFilterer, error) {
	contract, err := bindIProtocolFees(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IProtocolFeesFilterer{contract: contract}, nil
}

// bindIProtocolFees binds a generic wrapper to an already deployed contract.
func bindIProtocolFees(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := IProtocolFeesMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IProtocolFees *IProtocolFeesRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IProtocolFees.Contract.IProtocolFeesCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IProtocolFees *IProtocolFeesRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IProtocolFees.Contract.IProtocolFeesTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IProtocolFees *IProtocolFeesRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IProtocolFees.Contract.IProtocolFeesTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IProtocolFees *IProtocolFeesCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IProtocolFees.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IProtocolFees *IProtocolFeesTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IProtocolFees.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IProtocolFees *IProtocolFeesTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IProtocolFees.Contract.contract.Transact(opts, method, params...)
}

// FEEREGISTRY is a free data retrieval call binding the contract method 0xc94af078.
//
// Solidity: function FEE_REGISTRY() view returns(address)
func (_IProtocolFees *IProtocolFeesCaller) FEEREGISTRY(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IProtocolFees.contract.Call(opts, &out, "FEE_REGISTRY")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// FEEREGISTRY is a free data retrieval call binding the contract method 0xc94af078.
//
// Solidity: function FEE_REGISTRY() view returns(address)
func (_IProtocolFees *IProtocolFeesSession) FEEREGISTRY() (common.Address, error) {
	return _IProtocolFees.Contract.FEEREGISTRY(&_IProtocolFees.CallOpts)
}

// FEEREGISTRY is a free data retrieval call binding the contract method 0xc94af078.
//
// Solidity: function FEE_REGISTRY() view returns(address)
func (_IProtocolFees *IProtocolFeesCallerSession) FEEREGISTRY() (common.Address, error) {
	return _IProtocolFees.Contract.FEEREGISTRY(&_IProtocolFees.CallOpts)
}

// MAXFEE is a free data retrieval call binding the contract method 0xbc063e1a.
//
// Solidity: function MAX_FEE() view returns(uint256)
func (_IProtocolFees *IProtocolFeesCaller) MAXFEE(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IProtocolFees.contract.Call(opts, &out, "MAX_FEE")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MAXFEE is a free data retrieval call binding the contract method 0xbc063e1a.
//
// Solidity: function MAX_FEE() view returns(uint256)
func (_IProtocolFees *IProtocolFeesSession) MAXFEE() (*big.Int, error) {
	return _IProtocolFees.Contract.MAXFEE(&_IProtocolFees.CallOpts)
}

// MAXFEE is a free data retrieval call binding the contract method 0xbc063e1a.
//
// Solidity: function MAX_FEE() view returns(uint256)
func (_IProtocolFees *IProtocolFeesCallerSession) MAXFEE() (*big.Int, error) {
	return _IProtocolFees.Contract.MAXFEE(&_IProtocolFees.CallOpts)
}

// DistributionToTotalAmount is a free data retrieval call binding the contract method 0x8f1ee634.
//
// Solidity: function distributionToTotalAmount(uint64 rewardsType, address network, uint256 distributionAmount) view returns(uint256)
func (_IProtocolFees *IProtocolFeesCaller) DistributionToTotalAmount(opts *bind.CallOpts, rewardsType uint64, network common.Address, distributionAmount *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _IProtocolFees.contract.Call(opts, &out, "distributionToTotalAmount", rewardsType, network, distributionAmount)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// DistributionToTotalAmount is a free data retrieval call binding the contract method 0x8f1ee634.
//
// Solidity: function distributionToTotalAmount(uint64 rewardsType, address network, uint256 distributionAmount) view returns(uint256)
func (_IProtocolFees *IProtocolFeesSession) DistributionToTotalAmount(rewardsType uint64, network common.Address, distributionAmount *big.Int) (*big.Int, error) {
	return _IProtocolFees.Contract.DistributionToTotalAmount(&_IProtocolFees.CallOpts, rewardsType, network, distributionAmount)
}

// DistributionToTotalAmount is a free data retrieval call binding the contract method 0x8f1ee634.
//
// Solidity: function distributionToTotalAmount(uint64 rewardsType, address network, uint256 distributionAmount) view returns(uint256)
func (_IProtocolFees *IProtocolFeesCallerSession) DistributionToTotalAmount(rewardsType uint64, network common.Address, distributionAmount *big.Int) (*big.Int, error) {
	return _IProtocolFees.Contract.DistributionToTotalAmount(&_IProtocolFees.CallOpts, rewardsType, network, distributionAmount)
}

// ProtocolFee is a free data retrieval call binding the contract method 0x960c4ba6.
//
// Solidity: function protocolFee(uint64 rewardsType, address network) view returns(uint256)
func (_IProtocolFees *IProtocolFeesCaller) ProtocolFee(opts *bind.CallOpts, rewardsType uint64, network common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IProtocolFees.contract.Call(opts, &out, "protocolFee", rewardsType, network)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ProtocolFee is a free data retrieval call binding the contract method 0x960c4ba6.
//
// Solidity: function protocolFee(uint64 rewardsType, address network) view returns(uint256)
func (_IProtocolFees *IProtocolFeesSession) ProtocolFee(rewardsType uint64, network common.Address) (*big.Int, error) {
	return _IProtocolFees.Contract.ProtocolFee(&_IProtocolFees.CallOpts, rewardsType, network)
}

// ProtocolFee is a free data retrieval call binding the contract method 0x960c4ba6.
//
// Solidity: function protocolFee(uint64 rewardsType, address network) view returns(uint256)
func (_IProtocolFees *IProtocolFeesCallerSession) ProtocolFee(rewardsType uint64, network common.Address) (*big.Int, error) {
	return _IProtocolFees.Contract.ProtocolFee(&_IProtocolFees.CallOpts, rewardsType, network)
}

// ProtocolFees is a free data retrieval call binding the contract method 0xdcf844a7.
//
// Solidity: function protocolFees(address token) view returns(uint256)
func (_IProtocolFees *IProtocolFeesCaller) ProtocolFees(opts *bind.CallOpts, token common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IProtocolFees.contract.Call(opts, &out, "protocolFees", token)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ProtocolFees is a free data retrieval call binding the contract method 0xdcf844a7.
//
// Solidity: function protocolFees(address token) view returns(uint256)
func (_IProtocolFees *IProtocolFeesSession) ProtocolFees(token common.Address) (*big.Int, error) {
	return _IProtocolFees.Contract.ProtocolFees(&_IProtocolFees.CallOpts, token)
}

// ProtocolFees is a free data retrieval call binding the contract method 0xdcf844a7.
//
// Solidity: function protocolFees(address token) view returns(uint256)
func (_IProtocolFees *IProtocolFeesCallerSession) ProtocolFees(token common.Address) (*big.Int, error) {
	return _IProtocolFees.Contract.ProtocolFees(&_IProtocolFees.CallOpts, token)
}

// TotalToDistributionAmount is a free data retrieval call binding the contract method 0xbd52491f.
//
// Solidity: function totalToDistributionAmount(uint64 rewardsType, address network, uint256 totalDistributionAmount) view returns(uint256)
func (_IProtocolFees *IProtocolFeesCaller) TotalToDistributionAmount(opts *bind.CallOpts, rewardsType uint64, network common.Address, totalDistributionAmount *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _IProtocolFees.contract.Call(opts, &out, "totalToDistributionAmount", rewardsType, network, totalDistributionAmount)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TotalToDistributionAmount is a free data retrieval call binding the contract method 0xbd52491f.
//
// Solidity: function totalToDistributionAmount(uint64 rewardsType, address network, uint256 totalDistributionAmount) view returns(uint256)
func (_IProtocolFees *IProtocolFeesSession) TotalToDistributionAmount(rewardsType uint64, network common.Address, totalDistributionAmount *big.Int) (*big.Int, error) {
	return _IProtocolFees.Contract.TotalToDistributionAmount(&_IProtocolFees.CallOpts, rewardsType, network, totalDistributionAmount)
}

// TotalToDistributionAmount is a free data retrieval call binding the contract method 0xbd52491f.
//
// Solidity: function totalToDistributionAmount(uint64 rewardsType, address network, uint256 totalDistributionAmount) view returns(uint256)
func (_IProtocolFees *IProtocolFeesCallerSession) TotalToDistributionAmount(rewardsType uint64, network common.Address, totalDistributionAmount *big.Int) (*big.Int, error) {
	return _IProtocolFees.Contract.TotalToDistributionAmount(&_IProtocolFees.CallOpts, rewardsType, network, totalDistributionAmount)
}

// ClaimProtocolFees is a paid mutator transaction binding the contract method 0x77c654a3.
//
// Solidity: function claimProtocolFees(address recipient, address token) returns(uint256 fees)
func (_IProtocolFees *IProtocolFeesTransactor) ClaimProtocolFees(opts *bind.TransactOpts, recipient common.Address, token common.Address) (*types.Transaction, error) {
	return _IProtocolFees.contract.Transact(opts, "claimProtocolFees", recipient, token)
}

// ClaimProtocolFees is a paid mutator transaction binding the contract method 0x77c654a3.
//
// Solidity: function claimProtocolFees(address recipient, address token) returns(uint256 fees)
func (_IProtocolFees *IProtocolFeesSession) ClaimProtocolFees(recipient common.Address, token common.Address) (*types.Transaction, error) {
	return _IProtocolFees.Contract.ClaimProtocolFees(&_IProtocolFees.TransactOpts, recipient, token)
}

// ClaimProtocolFees is a paid mutator transaction binding the contract method 0x77c654a3.
//
// Solidity: function claimProtocolFees(address recipient, address token) returns(uint256 fees)
func (_IProtocolFees *IProtocolFeesTransactorSession) ClaimProtocolFees(recipient common.Address, token common.Address) (*types.Transaction, error) {
	return _IProtocolFees.Contract.ClaimProtocolFees(&_IProtocolFees.TransactOpts, recipient, token)
}

// IProtocolFeesAccountProtocolFeesIterator is returned from FilterAccountProtocolFees and is used to iterate over the raw logs and unpacked data for AccountProtocolFees events raised by the IProtocolFees contract.
type IProtocolFeesAccountProtocolFeesIterator struct {
	Event *IProtocolFeesAccountProtocolFees // Event containing the contract specifics and raw log

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
func (it *IProtocolFeesAccountProtocolFeesIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IProtocolFeesAccountProtocolFees)
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
		it.Event = new(IProtocolFeesAccountProtocolFees)
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
func (it *IProtocolFeesAccountProtocolFeesIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IProtocolFeesAccountProtocolFeesIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IProtocolFeesAccountProtocolFees represents a AccountProtocolFees event raised by the IProtocolFees contract.
type IProtocolFeesAccountProtocolFees struct {
	RewardsType uint64
	Network     common.Address
	Token       common.Address
	Fees        *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterAccountProtocolFees is a free log retrieval operation binding the contract event 0x0d6d7b8dfb5a2d4658c5aec0a2360b696002baf9e3701b7f002383b6aafc17fe.
//
// Solidity: event AccountProtocolFees(uint64 indexed rewardsType, address indexed network, address indexed token, uint256 fees)
func (_IProtocolFees *IProtocolFeesFilterer) FilterAccountProtocolFees(opts *bind.FilterOpts, rewardsType []uint64, network []common.Address, token []common.Address) (*IProtocolFeesAccountProtocolFeesIterator, error) {

	var rewardsTypeRule []interface{}
	for _, rewardsTypeItem := range rewardsType {
		rewardsTypeRule = append(rewardsTypeRule, rewardsTypeItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IProtocolFees.contract.FilterLogs(opts, "AccountProtocolFees", rewardsTypeRule, networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return &IProtocolFeesAccountProtocolFeesIterator{contract: _IProtocolFees.contract, event: "AccountProtocolFees", logs: logs, sub: sub}, nil
}

// WatchAccountProtocolFees is a free log subscription operation binding the contract event 0x0d6d7b8dfb5a2d4658c5aec0a2360b696002baf9e3701b7f002383b6aafc17fe.
//
// Solidity: event AccountProtocolFees(uint64 indexed rewardsType, address indexed network, address indexed token, uint256 fees)
func (_IProtocolFees *IProtocolFeesFilterer) WatchAccountProtocolFees(opts *bind.WatchOpts, sink chan<- *IProtocolFeesAccountProtocolFees, rewardsType []uint64, network []common.Address, token []common.Address) (event.Subscription, error) {

	var rewardsTypeRule []interface{}
	for _, rewardsTypeItem := range rewardsType {
		rewardsTypeRule = append(rewardsTypeRule, rewardsTypeItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IProtocolFees.contract.WatchLogs(opts, "AccountProtocolFees", rewardsTypeRule, networkRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IProtocolFeesAccountProtocolFees)
				if err := _IProtocolFees.contract.UnpackLog(event, "AccountProtocolFees", log); err != nil {
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

// ParseAccountProtocolFees is a log parse operation binding the contract event 0x0d6d7b8dfb5a2d4658c5aec0a2360b696002baf9e3701b7f002383b6aafc17fe.
//
// Solidity: event AccountProtocolFees(uint64 indexed rewardsType, address indexed network, address indexed token, uint256 fees)
func (_IProtocolFees *IProtocolFeesFilterer) ParseAccountProtocolFees(log types.Log) (*IProtocolFeesAccountProtocolFees, error) {
	event := new(IProtocolFeesAccountProtocolFees)
	if err := _IProtocolFees.contract.UnpackLog(event, "AccountProtocolFees", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IProtocolFeesClaimProtocolFeesIterator is returned from FilterClaimProtocolFees and is used to iterate over the raw logs and unpacked data for ClaimProtocolFees events raised by the IProtocolFees contract.
type IProtocolFeesClaimProtocolFeesIterator struct {
	Event *IProtocolFeesClaimProtocolFees // Event containing the contract specifics and raw log

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
func (it *IProtocolFeesClaimProtocolFeesIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IProtocolFeesClaimProtocolFees)
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
		it.Event = new(IProtocolFeesClaimProtocolFees)
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
func (it *IProtocolFeesClaimProtocolFeesIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IProtocolFeesClaimProtocolFeesIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IProtocolFeesClaimProtocolFees represents a ClaimProtocolFees event raised by the IProtocolFees contract.
type IProtocolFeesClaimProtocolFees struct {
	Token common.Address
	Fees  *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterClaimProtocolFees is a free log retrieval operation binding the contract event 0x175b790d44599ca70432cc8d1406504cb3a28fc13ff995c06dde6663412b211a.
//
// Solidity: event ClaimProtocolFees(address indexed token, uint256 fees)
func (_IProtocolFees *IProtocolFeesFilterer) FilterClaimProtocolFees(opts *bind.FilterOpts, token []common.Address) (*IProtocolFeesClaimProtocolFeesIterator, error) {

	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IProtocolFees.contract.FilterLogs(opts, "ClaimProtocolFees", tokenRule)
	if err != nil {
		return nil, err
	}
	return &IProtocolFeesClaimProtocolFeesIterator{contract: _IProtocolFees.contract, event: "ClaimProtocolFees", logs: logs, sub: sub}, nil
}

// WatchClaimProtocolFees is a free log subscription operation binding the contract event 0x175b790d44599ca70432cc8d1406504cb3a28fc13ff995c06dde6663412b211a.
//
// Solidity: event ClaimProtocolFees(address indexed token, uint256 fees)
func (_IProtocolFees *IProtocolFeesFilterer) WatchClaimProtocolFees(opts *bind.WatchOpts, sink chan<- *IProtocolFeesClaimProtocolFees, token []common.Address) (event.Subscription, error) {

	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _IProtocolFees.contract.WatchLogs(opts, "ClaimProtocolFees", tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IProtocolFeesClaimProtocolFees)
				if err := _IProtocolFees.contract.UnpackLog(event, "ClaimProtocolFees", log); err != nil {
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

// ParseClaimProtocolFees is a log parse operation binding the contract event 0x175b790d44599ca70432cc8d1406504cb3a28fc13ff995c06dde6663412b211a.
//
// Solidity: event ClaimProtocolFees(address indexed token, uint256 fees)
func (_IProtocolFees *IProtocolFeesFilterer) ParseClaimProtocolFees(log types.Log) (*IProtocolFeesClaimProtocolFees, error) {
	event := new(IProtocolFeesClaimProtocolFees)
	if err := _IProtocolFees.contract.UnpackLog(event, "ClaimProtocolFees", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
