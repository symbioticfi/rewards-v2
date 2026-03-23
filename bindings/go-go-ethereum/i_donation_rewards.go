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

// IDonationRewardsMetaData contains all meta data concerning the IDonationRewards contract.
var IDonationRewardsMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"claimRewards\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"distributeDonationRewards\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"DistributeDonationRewards\",\"inputs\":[{\"name\":\"adapter\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"InsufficientClaimableFees\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InsufficientDeposit\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InsufficientReward\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidDelegatorType\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidLastUnclaimedReward\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidMerkleProof\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidMerkleRoot\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidRecipient\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidRewardTimestamp\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidSignature\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidTimestamp\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidToken\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoCumulativeRewardsToClaim\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoDonationSupport\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoRewardsToClaim\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotCurator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotNetworkOrMiddleware\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotOperator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotRewarder\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotVault\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"RootAlreadySet\",\"inputs\":[]}]",
}

// IDonationRewardsABI is the input ABI used to generate the binding from.
// Deprecated: Use IDonationRewardsMetaData.ABI instead.
var IDonationRewardsABI = IDonationRewardsMetaData.ABI

// IDonationRewards is an auto generated Go binding around an Ethereum contract.
type IDonationRewards struct {
	IDonationRewardsCaller     // Read-only binding to the contract
	IDonationRewardsTransactor // Write-only binding to the contract
	IDonationRewardsFilterer   // Log filterer for contract events
}

// IDonationRewardsCaller is an auto generated read-only Go binding around an Ethereum contract.
type IDonationRewardsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IDonationRewardsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IDonationRewardsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IDonationRewardsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IDonationRewardsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IDonationRewardsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IDonationRewardsSession struct {
	Contract     *IDonationRewards // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IDonationRewardsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IDonationRewardsCallerSession struct {
	Contract *IDonationRewardsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts           // Call options to use throughout this session
}

// IDonationRewardsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IDonationRewardsTransactorSession struct {
	Contract     *IDonationRewardsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts           // Transaction auth options to use throughout this session
}

// IDonationRewardsRaw is an auto generated low-level Go binding around an Ethereum contract.
type IDonationRewardsRaw struct {
	Contract *IDonationRewards // Generic contract binding to access the raw methods on
}

// IDonationRewardsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IDonationRewardsCallerRaw struct {
	Contract *IDonationRewardsCaller // Generic read-only contract binding to access the raw methods on
}

// IDonationRewardsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IDonationRewardsTransactorRaw struct {
	Contract *IDonationRewardsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIDonationRewards creates a new instance of IDonationRewards, bound to a specific deployed contract.
func NewIDonationRewards(address common.Address, backend bind.ContractBackend) (*IDonationRewards, error) {
	contract, err := bindIDonationRewards(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IDonationRewards{IDonationRewardsCaller: IDonationRewardsCaller{contract: contract}, IDonationRewardsTransactor: IDonationRewardsTransactor{contract: contract}, IDonationRewardsFilterer: IDonationRewardsFilterer{contract: contract}}, nil
}

// NewIDonationRewardsCaller creates a new read-only instance of IDonationRewards, bound to a specific deployed contract.
func NewIDonationRewardsCaller(address common.Address, caller bind.ContractCaller) (*IDonationRewardsCaller, error) {
	contract, err := bindIDonationRewards(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IDonationRewardsCaller{contract: contract}, nil
}

// NewIDonationRewardsTransactor creates a new write-only instance of IDonationRewards, bound to a specific deployed contract.
func NewIDonationRewardsTransactor(address common.Address, transactor bind.ContractTransactor) (*IDonationRewardsTransactor, error) {
	contract, err := bindIDonationRewards(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IDonationRewardsTransactor{contract: contract}, nil
}

// NewIDonationRewardsFilterer creates a new log filterer instance of IDonationRewards, bound to a specific deployed contract.
func NewIDonationRewardsFilterer(address common.Address, filterer bind.ContractFilterer) (*IDonationRewardsFilterer, error) {
	contract, err := bindIDonationRewards(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IDonationRewardsFilterer{contract: contract}, nil
}

// bindIDonationRewards binds a generic wrapper to an already deployed contract.
func bindIDonationRewards(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := IDonationRewardsMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IDonationRewards *IDonationRewardsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IDonationRewards.Contract.IDonationRewardsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IDonationRewards *IDonationRewardsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IDonationRewards.Contract.IDonationRewardsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IDonationRewards *IDonationRewardsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IDonationRewards.Contract.IDonationRewardsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IDonationRewards *IDonationRewardsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IDonationRewards.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IDonationRewards *IDonationRewardsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IDonationRewards.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IDonationRewards *IDonationRewardsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IDonationRewards.Contract.contract.Transact(opts, method, params...)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IDonationRewards *IDonationRewardsTransactor) ClaimRewards(opts *bind.TransactOpts, recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IDonationRewards.contract.Transact(opts, "claimRewards", recipient, token, data)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IDonationRewards *IDonationRewardsSession) ClaimRewards(recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IDonationRewards.Contract.ClaimRewards(&_IDonationRewards.TransactOpts, recipient, token, data)
}

// ClaimRewards is a paid mutator transaction binding the contract method 0x5d0b5205.
//
// Solidity: function claimRewards(address recipient, address token, bytes data) returns()
func (_IDonationRewards *IDonationRewardsTransactorSession) ClaimRewards(recipient common.Address, token common.Address, data []byte) (*types.Transaction, error) {
	return _IDonationRewards.Contract.ClaimRewards(&_IDonationRewards.TransactOpts, recipient, token, data)
}

// DistributeDonationRewards is a paid mutator transaction binding the contract method 0xb000591e.
//
// Solidity: function distributeDonationRewards(address vault, uint256 amount) returns()
func (_IDonationRewards *IDonationRewardsTransactor) DistributeDonationRewards(opts *bind.TransactOpts, vault common.Address, amount *big.Int) (*types.Transaction, error) {
	return _IDonationRewards.contract.Transact(opts, "distributeDonationRewards", vault, amount)
}

// DistributeDonationRewards is a paid mutator transaction binding the contract method 0xb000591e.
//
// Solidity: function distributeDonationRewards(address vault, uint256 amount) returns()
func (_IDonationRewards *IDonationRewardsSession) DistributeDonationRewards(vault common.Address, amount *big.Int) (*types.Transaction, error) {
	return _IDonationRewards.Contract.DistributeDonationRewards(&_IDonationRewards.TransactOpts, vault, amount)
}

// DistributeDonationRewards is a paid mutator transaction binding the contract method 0xb000591e.
//
// Solidity: function distributeDonationRewards(address vault, uint256 amount) returns()
func (_IDonationRewards *IDonationRewardsTransactorSession) DistributeDonationRewards(vault common.Address, amount *big.Int) (*types.Transaction, error) {
	return _IDonationRewards.Contract.DistributeDonationRewards(&_IDonationRewards.TransactOpts, vault, amount)
}

// IDonationRewardsDistributeDonationRewardsIterator is returned from FilterDistributeDonationRewards and is used to iterate over the raw logs and unpacked data for DistributeDonationRewards events raised by the IDonationRewards contract.
type IDonationRewardsDistributeDonationRewardsIterator struct {
	Event *IDonationRewardsDistributeDonationRewards // Event containing the contract specifics and raw log

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
func (it *IDonationRewardsDistributeDonationRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IDonationRewardsDistributeDonationRewards)
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
		it.Event = new(IDonationRewardsDistributeDonationRewards)
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
func (it *IDonationRewardsDistributeDonationRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IDonationRewardsDistributeDonationRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IDonationRewardsDistributeDonationRewards represents a DistributeDonationRewards event raised by the IDonationRewards contract.
type IDonationRewardsDistributeDonationRewards struct {
	Adapter common.Address
	Vault   common.Address
	Amount  *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterDistributeDonationRewards is a free log retrieval operation binding the contract event 0x546c21363f831f8decc73ffdd36db53182e1c27887c7ac9e6fd79eefd14167f6.
//
// Solidity: event DistributeDonationRewards(address indexed adapter, address indexed vault, uint256 amount)
func (_IDonationRewards *IDonationRewardsFilterer) FilterDistributeDonationRewards(opts *bind.FilterOpts, adapter []common.Address, vault []common.Address) (*IDonationRewardsDistributeDonationRewardsIterator, error) {

	var adapterRule []interface{}
	for _, adapterItem := range adapter {
		adapterRule = append(adapterRule, adapterItem)
	}
	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IDonationRewards.contract.FilterLogs(opts, "DistributeDonationRewards", adapterRule, vaultRule)
	if err != nil {
		return nil, err
	}
	return &IDonationRewardsDistributeDonationRewardsIterator{contract: _IDonationRewards.contract, event: "DistributeDonationRewards", logs: logs, sub: sub}, nil
}

// WatchDistributeDonationRewards is a free log subscription operation binding the contract event 0x546c21363f831f8decc73ffdd36db53182e1c27887c7ac9e6fd79eefd14167f6.
//
// Solidity: event DistributeDonationRewards(address indexed adapter, address indexed vault, uint256 amount)
func (_IDonationRewards *IDonationRewardsFilterer) WatchDistributeDonationRewards(opts *bind.WatchOpts, sink chan<- *IDonationRewardsDistributeDonationRewards, adapter []common.Address, vault []common.Address) (event.Subscription, error) {

	var adapterRule []interface{}
	for _, adapterItem := range adapter {
		adapterRule = append(adapterRule, adapterItem)
	}
	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IDonationRewards.contract.WatchLogs(opts, "DistributeDonationRewards", adapterRule, vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IDonationRewardsDistributeDonationRewards)
				if err := _IDonationRewards.contract.UnpackLog(event, "DistributeDonationRewards", log); err != nil {
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

// ParseDistributeDonationRewards is a log parse operation binding the contract event 0x546c21363f831f8decc73ffdd36db53182e1c27887c7ac9e6fd79eefd14167f6.
//
// Solidity: event DistributeDonationRewards(address indexed adapter, address indexed vault, uint256 amount)
func (_IDonationRewards *IDonationRewardsFilterer) ParseDistributeDonationRewards(log types.Log) (*IDonationRewardsDistributeDonationRewards, error) {
	event := new(IDonationRewardsDistributeDonationRewards)
	if err := _IDonationRewards.contract.UnpackLog(event, "DistributeDonationRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
