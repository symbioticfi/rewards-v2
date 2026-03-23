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

// ICuratorFeesMetaData contains all meta data concerning the ICuratorFees contract.
var ICuratorFeesMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"CURATOR_REGISTRY\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"claimCuratorFees\",\"inputs\":[{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"curatorFees\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"event\",\"name\":\"AccountCuratorFees\",\"inputs\":[{\"name\":\"rewardsType\",\"type\":\"uint64\",\"indexed\":true,\"internalType\":\"uint64\"},{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"networkOrAdapter\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"fees\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ClaimCuratorFees\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"InsufficientClaimableFees\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InsufficientDeposit\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InsufficientReward\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidDelegatorType\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidLastUnclaimedReward\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidMerkleProof\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidMerkleRoot\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidRecipient\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidRewardTimestamp\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidSignature\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidTimestamp\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidToken\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoCumulativeRewardsToClaim\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoDonationSupport\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NoRewardsToClaim\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotCurator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotNetworkOrMiddleware\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotOperator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotRewarder\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotVault\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"RootAlreadySet\",\"inputs\":[]}]",
}

// ICuratorFeesABI is the input ABI used to generate the binding from.
// Deprecated: Use ICuratorFeesMetaData.ABI instead.
var ICuratorFeesABI = ICuratorFeesMetaData.ABI

// ICuratorFees is an auto generated Go binding around an Ethereum contract.
type ICuratorFees struct {
	ICuratorFeesCaller     // Read-only binding to the contract
	ICuratorFeesTransactor // Write-only binding to the contract
	ICuratorFeesFilterer   // Log filterer for contract events
}

// ICuratorFeesCaller is an auto generated read-only Go binding around an Ethereum contract.
type ICuratorFeesCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ICuratorFeesTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ICuratorFeesTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ICuratorFeesFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ICuratorFeesFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ICuratorFeesSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ICuratorFeesSession struct {
	Contract     *ICuratorFees     // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ICuratorFeesCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ICuratorFeesCallerSession struct {
	Contract *ICuratorFeesCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts       // Call options to use throughout this session
}

// ICuratorFeesTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ICuratorFeesTransactorSession struct {
	Contract     *ICuratorFeesTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts       // Transaction auth options to use throughout this session
}

// ICuratorFeesRaw is an auto generated low-level Go binding around an Ethereum contract.
type ICuratorFeesRaw struct {
	Contract *ICuratorFees // Generic contract binding to access the raw methods on
}

// ICuratorFeesCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ICuratorFeesCallerRaw struct {
	Contract *ICuratorFeesCaller // Generic read-only contract binding to access the raw methods on
}

// ICuratorFeesTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ICuratorFeesTransactorRaw struct {
	Contract *ICuratorFeesTransactor // Generic write-only contract binding to access the raw methods on
}

// NewICuratorFees creates a new instance of ICuratorFees, bound to a specific deployed contract.
func NewICuratorFees(address common.Address, backend bind.ContractBackend) (*ICuratorFees, error) {
	contract, err := bindICuratorFees(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ICuratorFees{ICuratorFeesCaller: ICuratorFeesCaller{contract: contract}, ICuratorFeesTransactor: ICuratorFeesTransactor{contract: contract}, ICuratorFeesFilterer: ICuratorFeesFilterer{contract: contract}}, nil
}

// NewICuratorFeesCaller creates a new read-only instance of ICuratorFees, bound to a specific deployed contract.
func NewICuratorFeesCaller(address common.Address, caller bind.ContractCaller) (*ICuratorFeesCaller, error) {
	contract, err := bindICuratorFees(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ICuratorFeesCaller{contract: contract}, nil
}

// NewICuratorFeesTransactor creates a new write-only instance of ICuratorFees, bound to a specific deployed contract.
func NewICuratorFeesTransactor(address common.Address, transactor bind.ContractTransactor) (*ICuratorFeesTransactor, error) {
	contract, err := bindICuratorFees(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ICuratorFeesTransactor{contract: contract}, nil
}

// NewICuratorFeesFilterer creates a new log filterer instance of ICuratorFees, bound to a specific deployed contract.
func NewICuratorFeesFilterer(address common.Address, filterer bind.ContractFilterer) (*ICuratorFeesFilterer, error) {
	contract, err := bindICuratorFees(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ICuratorFeesFilterer{contract: contract}, nil
}

// bindICuratorFees binds a generic wrapper to an already deployed contract.
func bindICuratorFees(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := ICuratorFeesMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ICuratorFees *ICuratorFeesRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ICuratorFees.Contract.ICuratorFeesCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ICuratorFees *ICuratorFeesRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ICuratorFees.Contract.ICuratorFeesTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ICuratorFees *ICuratorFeesRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ICuratorFees.Contract.ICuratorFeesTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ICuratorFees *ICuratorFeesCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ICuratorFees.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ICuratorFees *ICuratorFeesTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ICuratorFees.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ICuratorFees *ICuratorFeesTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ICuratorFees.Contract.contract.Transact(opts, method, params...)
}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_ICuratorFees *ICuratorFeesCaller) CURATORREGISTRY(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _ICuratorFees.contract.Call(opts, &out, "CURATOR_REGISTRY")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_ICuratorFees *ICuratorFeesSession) CURATORREGISTRY() (common.Address, error) {
	return _ICuratorFees.Contract.CURATORREGISTRY(&_ICuratorFees.CallOpts)
}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_ICuratorFees *ICuratorFeesCallerSession) CURATORREGISTRY() (common.Address, error) {
	return _ICuratorFees.Contract.CURATORREGISTRY(&_ICuratorFees.CallOpts)
}

// CuratorFees is a free data retrieval call binding the contract method 0x2f8006e0.
//
// Solidity: function curatorFees(address vault, address token) view returns(uint256)
func (_ICuratorFees *ICuratorFeesCaller) CuratorFees(opts *bind.CallOpts, vault common.Address, token common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ICuratorFees.contract.Call(opts, &out, "curatorFees", vault, token)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// CuratorFees is a free data retrieval call binding the contract method 0x2f8006e0.
//
// Solidity: function curatorFees(address vault, address token) view returns(uint256)
func (_ICuratorFees *ICuratorFeesSession) CuratorFees(vault common.Address, token common.Address) (*big.Int, error) {
	return _ICuratorFees.Contract.CuratorFees(&_ICuratorFees.CallOpts, vault, token)
}

// CuratorFees is a free data retrieval call binding the contract method 0x2f8006e0.
//
// Solidity: function curatorFees(address vault, address token) view returns(uint256)
func (_ICuratorFees *ICuratorFeesCallerSession) CuratorFees(vault common.Address, token common.Address) (*big.Int, error) {
	return _ICuratorFees.Contract.CuratorFees(&_ICuratorFees.CallOpts, vault, token)
}

// ClaimCuratorFees is a paid mutator transaction binding the contract method 0xd1216d0a.
//
// Solidity: function claimCuratorFees(address recipient, address vault, address token) returns()
func (_ICuratorFees *ICuratorFeesTransactor) ClaimCuratorFees(opts *bind.TransactOpts, recipient common.Address, vault common.Address, token common.Address) (*types.Transaction, error) {
	return _ICuratorFees.contract.Transact(opts, "claimCuratorFees", recipient, vault, token)
}

// ClaimCuratorFees is a paid mutator transaction binding the contract method 0xd1216d0a.
//
// Solidity: function claimCuratorFees(address recipient, address vault, address token) returns()
func (_ICuratorFees *ICuratorFeesSession) ClaimCuratorFees(recipient common.Address, vault common.Address, token common.Address) (*types.Transaction, error) {
	return _ICuratorFees.Contract.ClaimCuratorFees(&_ICuratorFees.TransactOpts, recipient, vault, token)
}

// ClaimCuratorFees is a paid mutator transaction binding the contract method 0xd1216d0a.
//
// Solidity: function claimCuratorFees(address recipient, address vault, address token) returns()
func (_ICuratorFees *ICuratorFeesTransactorSession) ClaimCuratorFees(recipient common.Address, vault common.Address, token common.Address) (*types.Transaction, error) {
	return _ICuratorFees.Contract.ClaimCuratorFees(&_ICuratorFees.TransactOpts, recipient, vault, token)
}

// ICuratorFeesAccountCuratorFeesIterator is returned from FilterAccountCuratorFees and is used to iterate over the raw logs and unpacked data for AccountCuratorFees events raised by the ICuratorFees contract.
type ICuratorFeesAccountCuratorFeesIterator struct {
	Event *ICuratorFeesAccountCuratorFees // Event containing the contract specifics and raw log

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
func (it *ICuratorFeesAccountCuratorFeesIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ICuratorFeesAccountCuratorFees)
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
		it.Event = new(ICuratorFeesAccountCuratorFees)
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
func (it *ICuratorFeesAccountCuratorFeesIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ICuratorFeesAccountCuratorFeesIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ICuratorFeesAccountCuratorFees represents a AccountCuratorFees event raised by the ICuratorFees contract.
type ICuratorFeesAccountCuratorFees struct {
	RewardsType      uint64
	Vault            common.Address
	NetworkOrAdapter common.Address
	Token            common.Address
	Fees             *big.Int
	Raw              types.Log // Blockchain specific contextual infos
}

// FilterAccountCuratorFees is a free log retrieval operation binding the contract event 0x18aab5be55d31259cdde1252d5dbb2e2b60df370304a74c396b211ef3ce45dcb.
//
// Solidity: event AccountCuratorFees(uint64 indexed rewardsType, address indexed vault, address networkOrAdapter, address indexed token, uint256 fees)
func (_ICuratorFees *ICuratorFeesFilterer) FilterAccountCuratorFees(opts *bind.FilterOpts, rewardsType []uint64, vault []common.Address, token []common.Address) (*ICuratorFeesAccountCuratorFeesIterator, error) {

	var rewardsTypeRule []interface{}
	for _, rewardsTypeItem := range rewardsType {
		rewardsTypeRule = append(rewardsTypeRule, rewardsTypeItem)
	}
	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _ICuratorFees.contract.FilterLogs(opts, "AccountCuratorFees", rewardsTypeRule, vaultRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return &ICuratorFeesAccountCuratorFeesIterator{contract: _ICuratorFees.contract, event: "AccountCuratorFees", logs: logs, sub: sub}, nil
}

// WatchAccountCuratorFees is a free log subscription operation binding the contract event 0x18aab5be55d31259cdde1252d5dbb2e2b60df370304a74c396b211ef3ce45dcb.
//
// Solidity: event AccountCuratorFees(uint64 indexed rewardsType, address indexed vault, address networkOrAdapter, address indexed token, uint256 fees)
func (_ICuratorFees *ICuratorFeesFilterer) WatchAccountCuratorFees(opts *bind.WatchOpts, sink chan<- *ICuratorFeesAccountCuratorFees, rewardsType []uint64, vault []common.Address, token []common.Address) (event.Subscription, error) {

	var rewardsTypeRule []interface{}
	for _, rewardsTypeItem := range rewardsType {
		rewardsTypeRule = append(rewardsTypeRule, rewardsTypeItem)
	}
	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _ICuratorFees.contract.WatchLogs(opts, "AccountCuratorFees", rewardsTypeRule, vaultRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ICuratorFeesAccountCuratorFees)
				if err := _ICuratorFees.contract.UnpackLog(event, "AccountCuratorFees", log); err != nil {
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

// ParseAccountCuratorFees is a log parse operation binding the contract event 0x18aab5be55d31259cdde1252d5dbb2e2b60df370304a74c396b211ef3ce45dcb.
//
// Solidity: event AccountCuratorFees(uint64 indexed rewardsType, address indexed vault, address networkOrAdapter, address indexed token, uint256 fees)
func (_ICuratorFees *ICuratorFeesFilterer) ParseAccountCuratorFees(log types.Log) (*ICuratorFeesAccountCuratorFees, error) {
	event := new(ICuratorFeesAccountCuratorFees)
	if err := _ICuratorFees.contract.UnpackLog(event, "AccountCuratorFees", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ICuratorFeesClaimCuratorFeesIterator is returned from FilterClaimCuratorFees and is used to iterate over the raw logs and unpacked data for ClaimCuratorFees events raised by the ICuratorFees contract.
type ICuratorFeesClaimCuratorFeesIterator struct {
	Event *ICuratorFeesClaimCuratorFees // Event containing the contract specifics and raw log

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
func (it *ICuratorFeesClaimCuratorFeesIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ICuratorFeesClaimCuratorFees)
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
		it.Event = new(ICuratorFeesClaimCuratorFees)
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
func (it *ICuratorFeesClaimCuratorFeesIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ICuratorFeesClaimCuratorFeesIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ICuratorFeesClaimCuratorFees represents a ClaimCuratorFees event raised by the ICuratorFees contract.
type ICuratorFeesClaimCuratorFees struct {
	Vault  common.Address
	Token  common.Address
	Amount *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterClaimCuratorFees is a free log retrieval operation binding the contract event 0xb8168ce970fea31a66517b0f2b9064db1aca670e136fe6bbe873ed3725b7578f.
//
// Solidity: event ClaimCuratorFees(address indexed vault, address indexed token, uint256 amount)
func (_ICuratorFees *ICuratorFeesFilterer) FilterClaimCuratorFees(opts *bind.FilterOpts, vault []common.Address, token []common.Address) (*ICuratorFeesClaimCuratorFeesIterator, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _ICuratorFees.contract.FilterLogs(opts, "ClaimCuratorFees", vaultRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return &ICuratorFeesClaimCuratorFeesIterator{contract: _ICuratorFees.contract, event: "ClaimCuratorFees", logs: logs, sub: sub}, nil
}

// WatchClaimCuratorFees is a free log subscription operation binding the contract event 0xb8168ce970fea31a66517b0f2b9064db1aca670e136fe6bbe873ed3725b7578f.
//
// Solidity: event ClaimCuratorFees(address indexed vault, address indexed token, uint256 amount)
func (_ICuratorFees *ICuratorFeesFilterer) WatchClaimCuratorFees(opts *bind.WatchOpts, sink chan<- *ICuratorFeesClaimCuratorFees, vault []common.Address, token []common.Address) (event.Subscription, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}
	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _ICuratorFees.contract.WatchLogs(opts, "ClaimCuratorFees", vaultRule, tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ICuratorFeesClaimCuratorFees)
				if err := _ICuratorFees.contract.UnpackLog(event, "ClaimCuratorFees", log); err != nil {
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
func (_ICuratorFees *ICuratorFeesFilterer) ParseClaimCuratorFees(log types.Log) (*ICuratorFeesClaimCuratorFees, error) {
	event := new(ICuratorFeesClaimCuratorFees)
	if err := _ICuratorFees.contract.UnpackLog(event, "ClaimCuratorFees", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
