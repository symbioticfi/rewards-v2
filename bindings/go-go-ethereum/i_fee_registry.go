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

// IFeeRegistryMetaData contains all meta data concerning the IFeeRegistry contract.
var IFeeRegistryMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"CURATOR_REGISTRY\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"MAX_FEE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"MAX_PARTICIPANT_FEE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getCuratorDefaultFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getCuratorDefaultFeeAt\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hint\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getCuratorFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"networkOrAdapter\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getCuratorFeeAt\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"networkOrAdapter\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hints\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getCuratorNetworkFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"networkOrAdapter\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"isEnabled\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getCuratorNetworkFeeAt\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"networkOrAdapter\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hint\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"isEnabled\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getInstantWithdrawFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getOperatorsDefaultFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getOperatorsDefaultFeeAt\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hint\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getOperatorsFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getOperatorsFeeAt\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hints\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getOperatorsNetworkFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"isEnabled\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getOperatorsNetworkFeeAt\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"timestamp\",\"type\":\"uint48\",\"internalType\":\"uint48\"},{\"name\":\"hint\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"isEnabled\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getProtocolFee\",\"inputs\":[{\"name\":\"id\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"isEnabled\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"setCuratorFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setCuratorNetworkFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"networkOrAdapter\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"enable\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setInstantWithdrawFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setOperatorsFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setOperatorsNetworkFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"enable\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setProtocolFee\",\"inputs\":[{\"name\":\"id\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"enable\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"SetCuratorFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"fee\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SetCuratorNetworkFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"networkOrAdapter\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"enable\",\"type\":\"bool\",\"indexed\":false,\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SetInstantWithdrawalFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"fee\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SetOperatorsFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"fee\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SetOperatorsNetworkFee\",\"inputs\":[{\"name\":\"vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"network\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"enable\",\"type\":\"bool\",\"indexed\":false,\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SetProtocolFee\",\"inputs\":[{\"name\":\"id\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"enable\",\"type\":\"bool\",\"indexed\":false,\"internalType\":\"bool\"},{\"name\":\"fee\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"FeeTooHigh\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotCurator\",\"inputs\":[]}]",
}

// IFeeRegistryABI is the input ABI used to generate the binding from.
// Deprecated: Use IFeeRegistryMetaData.ABI instead.
var IFeeRegistryABI = IFeeRegistryMetaData.ABI

// IFeeRegistry is an auto generated Go binding around an Ethereum contract.
type IFeeRegistry struct {
	IFeeRegistryCaller     // Read-only binding to the contract
	IFeeRegistryTransactor // Write-only binding to the contract
	IFeeRegistryFilterer   // Log filterer for contract events
}

// IFeeRegistryCaller is an auto generated read-only Go binding around an Ethereum contract.
type IFeeRegistryCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IFeeRegistryTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IFeeRegistryTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IFeeRegistryFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IFeeRegistryFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IFeeRegistrySession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IFeeRegistrySession struct {
	Contract     *IFeeRegistry     // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IFeeRegistryCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IFeeRegistryCallerSession struct {
	Contract *IFeeRegistryCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts       // Call options to use throughout this session
}

// IFeeRegistryTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IFeeRegistryTransactorSession struct {
	Contract     *IFeeRegistryTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts       // Transaction auth options to use throughout this session
}

// IFeeRegistryRaw is an auto generated low-level Go binding around an Ethereum contract.
type IFeeRegistryRaw struct {
	Contract *IFeeRegistry // Generic contract binding to access the raw methods on
}

// IFeeRegistryCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IFeeRegistryCallerRaw struct {
	Contract *IFeeRegistryCaller // Generic read-only contract binding to access the raw methods on
}

// IFeeRegistryTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IFeeRegistryTransactorRaw struct {
	Contract *IFeeRegistryTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIFeeRegistry creates a new instance of IFeeRegistry, bound to a specific deployed contract.
func NewIFeeRegistry(address common.Address, backend bind.ContractBackend) (*IFeeRegistry, error) {
	contract, err := bindIFeeRegistry(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistry{IFeeRegistryCaller: IFeeRegistryCaller{contract: contract}, IFeeRegistryTransactor: IFeeRegistryTransactor{contract: contract}, IFeeRegistryFilterer: IFeeRegistryFilterer{contract: contract}}, nil
}

// NewIFeeRegistryCaller creates a new read-only instance of IFeeRegistry, bound to a specific deployed contract.
func NewIFeeRegistryCaller(address common.Address, caller bind.ContractCaller) (*IFeeRegistryCaller, error) {
	contract, err := bindIFeeRegistry(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistryCaller{contract: contract}, nil
}

// NewIFeeRegistryTransactor creates a new write-only instance of IFeeRegistry, bound to a specific deployed contract.
func NewIFeeRegistryTransactor(address common.Address, transactor bind.ContractTransactor) (*IFeeRegistryTransactor, error) {
	contract, err := bindIFeeRegistry(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistryTransactor{contract: contract}, nil
}

// NewIFeeRegistryFilterer creates a new log filterer instance of IFeeRegistry, bound to a specific deployed contract.
func NewIFeeRegistryFilterer(address common.Address, filterer bind.ContractFilterer) (*IFeeRegistryFilterer, error) {
	contract, err := bindIFeeRegistry(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistryFilterer{contract: contract}, nil
}

// bindIFeeRegistry binds a generic wrapper to an already deployed contract.
func bindIFeeRegistry(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := IFeeRegistryMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IFeeRegistry *IFeeRegistryRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IFeeRegistry.Contract.IFeeRegistryCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IFeeRegistry *IFeeRegistryRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.IFeeRegistryTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IFeeRegistry *IFeeRegistryRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.IFeeRegistryTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IFeeRegistry *IFeeRegistryCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IFeeRegistry.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IFeeRegistry *IFeeRegistryTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IFeeRegistry *IFeeRegistryTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.contract.Transact(opts, method, params...)
}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_IFeeRegistry *IFeeRegistryCaller) CURATORREGISTRY(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "CURATOR_REGISTRY")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_IFeeRegistry *IFeeRegistrySession) CURATORREGISTRY() (common.Address, error) {
	return _IFeeRegistry.Contract.CURATORREGISTRY(&_IFeeRegistry.CallOpts)
}

// CURATORREGISTRY is a free data retrieval call binding the contract method 0x9ce1659b.
//
// Solidity: function CURATOR_REGISTRY() view returns(address)
func (_IFeeRegistry *IFeeRegistryCallerSession) CURATORREGISTRY() (common.Address, error) {
	return _IFeeRegistry.Contract.CURATORREGISTRY(&_IFeeRegistry.CallOpts)
}

// MAXFEE is a free data retrieval call binding the contract method 0xbc063e1a.
//
// Solidity: function MAX_FEE() view returns(uint256)
func (_IFeeRegistry *IFeeRegistryCaller) MAXFEE(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "MAX_FEE")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MAXFEE is a free data retrieval call binding the contract method 0xbc063e1a.
//
// Solidity: function MAX_FEE() view returns(uint256)
func (_IFeeRegistry *IFeeRegistrySession) MAXFEE() (*big.Int, error) {
	return _IFeeRegistry.Contract.MAXFEE(&_IFeeRegistry.CallOpts)
}

// MAXFEE is a free data retrieval call binding the contract method 0xbc063e1a.
//
// Solidity: function MAX_FEE() view returns(uint256)
func (_IFeeRegistry *IFeeRegistryCallerSession) MAXFEE() (*big.Int, error) {
	return _IFeeRegistry.Contract.MAXFEE(&_IFeeRegistry.CallOpts)
}

// MAXPARTICIPANTFEE is a free data retrieval call binding the contract method 0xe4cad8f6.
//
// Solidity: function MAX_PARTICIPANT_FEE() view returns(uint256)
func (_IFeeRegistry *IFeeRegistryCaller) MAXPARTICIPANTFEE(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "MAX_PARTICIPANT_FEE")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MAXPARTICIPANTFEE is a free data retrieval call binding the contract method 0xe4cad8f6.
//
// Solidity: function MAX_PARTICIPANT_FEE() view returns(uint256)
func (_IFeeRegistry *IFeeRegistrySession) MAXPARTICIPANTFEE() (*big.Int, error) {
	return _IFeeRegistry.Contract.MAXPARTICIPANTFEE(&_IFeeRegistry.CallOpts)
}

// MAXPARTICIPANTFEE is a free data retrieval call binding the contract method 0xe4cad8f6.
//
// Solidity: function MAX_PARTICIPANT_FEE() view returns(uint256)
func (_IFeeRegistry *IFeeRegistryCallerSession) MAXPARTICIPANTFEE() (*big.Int, error) {
	return _IFeeRegistry.Contract.MAXPARTICIPANTFEE(&_IFeeRegistry.CallOpts)
}

// GetCuratorDefaultFee is a free data retrieval call binding the contract method 0x4c19fa8c.
//
// Solidity: function getCuratorDefaultFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetCuratorDefaultFee(opts *bind.CallOpts, vault common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getCuratorDefaultFee", vault)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetCuratorDefaultFee is a free data retrieval call binding the contract method 0x4c19fa8c.
//
// Solidity: function getCuratorDefaultFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetCuratorDefaultFee(vault common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetCuratorDefaultFee(&_IFeeRegistry.CallOpts, vault)
}

// GetCuratorDefaultFee is a free data retrieval call binding the contract method 0x4c19fa8c.
//
// Solidity: function getCuratorDefaultFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetCuratorDefaultFee(vault common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetCuratorDefaultFee(&_IFeeRegistry.CallOpts, vault)
}

// GetCuratorDefaultFeeAt is a free data retrieval call binding the contract method 0x362f58eb.
//
// Solidity: function getCuratorDefaultFeeAt(address vault, uint48 timestamp, bytes hint) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetCuratorDefaultFeeAt(opts *bind.CallOpts, vault common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getCuratorDefaultFeeAt", vault, timestamp, hint)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetCuratorDefaultFeeAt is a free data retrieval call binding the contract method 0x362f58eb.
//
// Solidity: function getCuratorDefaultFeeAt(address vault, uint48 timestamp, bytes hint) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetCuratorDefaultFeeAt(vault common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetCuratorDefaultFeeAt(&_IFeeRegistry.CallOpts, vault, timestamp, hint)
}

// GetCuratorDefaultFeeAt is a free data retrieval call binding the contract method 0x362f58eb.
//
// Solidity: function getCuratorDefaultFeeAt(address vault, uint48 timestamp, bytes hint) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetCuratorDefaultFeeAt(vault common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetCuratorDefaultFeeAt(&_IFeeRegistry.CallOpts, vault, timestamp, hint)
}

// GetCuratorFee is a free data retrieval call binding the contract method 0xf1e23a5a.
//
// Solidity: function getCuratorFee(address vault, address networkOrAdapter) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetCuratorFee(opts *bind.CallOpts, vault common.Address, networkOrAdapter common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getCuratorFee", vault, networkOrAdapter)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetCuratorFee is a free data retrieval call binding the contract method 0xf1e23a5a.
//
// Solidity: function getCuratorFee(address vault, address networkOrAdapter) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetCuratorFee(vault common.Address, networkOrAdapter common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetCuratorFee(&_IFeeRegistry.CallOpts, vault, networkOrAdapter)
}

// GetCuratorFee is a free data retrieval call binding the contract method 0xf1e23a5a.
//
// Solidity: function getCuratorFee(address vault, address networkOrAdapter) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetCuratorFee(vault common.Address, networkOrAdapter common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetCuratorFee(&_IFeeRegistry.CallOpts, vault, networkOrAdapter)
}

// GetCuratorFeeAt is a free data retrieval call binding the contract method 0x55de9fec.
//
// Solidity: function getCuratorFeeAt(address vault, address networkOrAdapter, uint48 timestamp, bytes hints) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetCuratorFeeAt(opts *bind.CallOpts, vault common.Address, networkOrAdapter common.Address, timestamp *big.Int, hints []byte) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getCuratorFeeAt", vault, networkOrAdapter, timestamp, hints)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetCuratorFeeAt is a free data retrieval call binding the contract method 0x55de9fec.
//
// Solidity: function getCuratorFeeAt(address vault, address networkOrAdapter, uint48 timestamp, bytes hints) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetCuratorFeeAt(vault common.Address, networkOrAdapter common.Address, timestamp *big.Int, hints []byte) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetCuratorFeeAt(&_IFeeRegistry.CallOpts, vault, networkOrAdapter, timestamp, hints)
}

// GetCuratorFeeAt is a free data retrieval call binding the contract method 0x55de9fec.
//
// Solidity: function getCuratorFeeAt(address vault, address networkOrAdapter, uint48 timestamp, bytes hints) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetCuratorFeeAt(vault common.Address, networkOrAdapter common.Address, timestamp *big.Int, hints []byte) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetCuratorFeeAt(&_IFeeRegistry.CallOpts, vault, networkOrAdapter, timestamp, hints)
}

// GetCuratorNetworkFee is a free data retrieval call binding the contract method 0x2a361db7.
//
// Solidity: function getCuratorNetworkFee(address vault, address networkOrAdapter) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetCuratorNetworkFee(opts *bind.CallOpts, vault common.Address, networkOrAdapter common.Address) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getCuratorNetworkFee", vault, networkOrAdapter)

	outstruct := new(struct {
		IsEnabled bool
		Fee       *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.IsEnabled = *abi.ConvertType(out[0], new(bool)).(*bool)
	outstruct.Fee = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// GetCuratorNetworkFee is a free data retrieval call binding the contract method 0x2a361db7.
//
// Solidity: function getCuratorNetworkFee(address vault, address networkOrAdapter) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetCuratorNetworkFee(vault common.Address, networkOrAdapter common.Address) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetCuratorNetworkFee(&_IFeeRegistry.CallOpts, vault, networkOrAdapter)
}

// GetCuratorNetworkFee is a free data retrieval call binding the contract method 0x2a361db7.
//
// Solidity: function getCuratorNetworkFee(address vault, address networkOrAdapter) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetCuratorNetworkFee(vault common.Address, networkOrAdapter common.Address) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetCuratorNetworkFee(&_IFeeRegistry.CallOpts, vault, networkOrAdapter)
}

// GetCuratorNetworkFeeAt is a free data retrieval call binding the contract method 0x2fd8e5ab.
//
// Solidity: function getCuratorNetworkFeeAt(address vault, address networkOrAdapter, uint48 timestamp, bytes hint) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetCuratorNetworkFeeAt(opts *bind.CallOpts, vault common.Address, networkOrAdapter common.Address, timestamp *big.Int, hint []byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getCuratorNetworkFeeAt", vault, networkOrAdapter, timestamp, hint)

	outstruct := new(struct {
		IsEnabled bool
		Fee       *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.IsEnabled = *abi.ConvertType(out[0], new(bool)).(*bool)
	outstruct.Fee = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// GetCuratorNetworkFeeAt is a free data retrieval call binding the contract method 0x2fd8e5ab.
//
// Solidity: function getCuratorNetworkFeeAt(address vault, address networkOrAdapter, uint48 timestamp, bytes hint) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetCuratorNetworkFeeAt(vault common.Address, networkOrAdapter common.Address, timestamp *big.Int, hint []byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetCuratorNetworkFeeAt(&_IFeeRegistry.CallOpts, vault, networkOrAdapter, timestamp, hint)
}

// GetCuratorNetworkFeeAt is a free data retrieval call binding the contract method 0x2fd8e5ab.
//
// Solidity: function getCuratorNetworkFeeAt(address vault, address networkOrAdapter, uint48 timestamp, bytes hint) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetCuratorNetworkFeeAt(vault common.Address, networkOrAdapter common.Address, timestamp *big.Int, hint []byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetCuratorNetworkFeeAt(&_IFeeRegistry.CallOpts, vault, networkOrAdapter, timestamp, hint)
}

// GetInstantWithdrawFee is a free data retrieval call binding the contract method 0x055ff31a.
//
// Solidity: function getInstantWithdrawFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetInstantWithdrawFee(opts *bind.CallOpts, vault common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getInstantWithdrawFee", vault)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetInstantWithdrawFee is a free data retrieval call binding the contract method 0x055ff31a.
//
// Solidity: function getInstantWithdrawFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetInstantWithdrawFee(vault common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetInstantWithdrawFee(&_IFeeRegistry.CallOpts, vault)
}

// GetInstantWithdrawFee is a free data retrieval call binding the contract method 0x055ff31a.
//
// Solidity: function getInstantWithdrawFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetInstantWithdrawFee(vault common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetInstantWithdrawFee(&_IFeeRegistry.CallOpts, vault)
}

// GetOperatorsDefaultFee is a free data retrieval call binding the contract method 0x36b4436a.
//
// Solidity: function getOperatorsDefaultFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetOperatorsDefaultFee(opts *bind.CallOpts, vault common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getOperatorsDefaultFee", vault)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetOperatorsDefaultFee is a free data retrieval call binding the contract method 0x36b4436a.
//
// Solidity: function getOperatorsDefaultFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetOperatorsDefaultFee(vault common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetOperatorsDefaultFee(&_IFeeRegistry.CallOpts, vault)
}

// GetOperatorsDefaultFee is a free data retrieval call binding the contract method 0x36b4436a.
//
// Solidity: function getOperatorsDefaultFee(address vault) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetOperatorsDefaultFee(vault common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetOperatorsDefaultFee(&_IFeeRegistry.CallOpts, vault)
}

// GetOperatorsDefaultFeeAt is a free data retrieval call binding the contract method 0x94bf61df.
//
// Solidity: function getOperatorsDefaultFeeAt(address vault, uint48 timestamp, bytes hint) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetOperatorsDefaultFeeAt(opts *bind.CallOpts, vault common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getOperatorsDefaultFeeAt", vault, timestamp, hint)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetOperatorsDefaultFeeAt is a free data retrieval call binding the contract method 0x94bf61df.
//
// Solidity: function getOperatorsDefaultFeeAt(address vault, uint48 timestamp, bytes hint) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetOperatorsDefaultFeeAt(vault common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetOperatorsDefaultFeeAt(&_IFeeRegistry.CallOpts, vault, timestamp, hint)
}

// GetOperatorsDefaultFeeAt is a free data retrieval call binding the contract method 0x94bf61df.
//
// Solidity: function getOperatorsDefaultFeeAt(address vault, uint48 timestamp, bytes hint) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetOperatorsDefaultFeeAt(vault common.Address, timestamp *big.Int, hint []byte) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetOperatorsDefaultFeeAt(&_IFeeRegistry.CallOpts, vault, timestamp, hint)
}

// GetOperatorsFee is a free data retrieval call binding the contract method 0xd3bcb7c2.
//
// Solidity: function getOperatorsFee(address vault, address network) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetOperatorsFee(opts *bind.CallOpts, vault common.Address, network common.Address) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getOperatorsFee", vault, network)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetOperatorsFee is a free data retrieval call binding the contract method 0xd3bcb7c2.
//
// Solidity: function getOperatorsFee(address vault, address network) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetOperatorsFee(vault common.Address, network common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetOperatorsFee(&_IFeeRegistry.CallOpts, vault, network)
}

// GetOperatorsFee is a free data retrieval call binding the contract method 0xd3bcb7c2.
//
// Solidity: function getOperatorsFee(address vault, address network) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetOperatorsFee(vault common.Address, network common.Address) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetOperatorsFee(&_IFeeRegistry.CallOpts, vault, network)
}

// GetOperatorsFeeAt is a free data retrieval call binding the contract method 0xbc30c7b7.
//
// Solidity: function getOperatorsFeeAt(address vault, address network, uint48 timestamp, bytes hints) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetOperatorsFeeAt(opts *bind.CallOpts, vault common.Address, network common.Address, timestamp *big.Int, hints []byte) (*big.Int, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getOperatorsFeeAt", vault, network, timestamp, hints)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetOperatorsFeeAt is a free data retrieval call binding the contract method 0xbc30c7b7.
//
// Solidity: function getOperatorsFeeAt(address vault, address network, uint48 timestamp, bytes hints) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetOperatorsFeeAt(vault common.Address, network common.Address, timestamp *big.Int, hints []byte) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetOperatorsFeeAt(&_IFeeRegistry.CallOpts, vault, network, timestamp, hints)
}

// GetOperatorsFeeAt is a free data retrieval call binding the contract method 0xbc30c7b7.
//
// Solidity: function getOperatorsFeeAt(address vault, address network, uint48 timestamp, bytes hints) view returns(uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetOperatorsFeeAt(vault common.Address, network common.Address, timestamp *big.Int, hints []byte) (*big.Int, error) {
	return _IFeeRegistry.Contract.GetOperatorsFeeAt(&_IFeeRegistry.CallOpts, vault, network, timestamp, hints)
}

// GetOperatorsNetworkFee is a free data retrieval call binding the contract method 0xecd6804d.
//
// Solidity: function getOperatorsNetworkFee(address vault, address network) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetOperatorsNetworkFee(opts *bind.CallOpts, vault common.Address, network common.Address) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getOperatorsNetworkFee", vault, network)

	outstruct := new(struct {
		IsEnabled bool
		Fee       *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.IsEnabled = *abi.ConvertType(out[0], new(bool)).(*bool)
	outstruct.Fee = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// GetOperatorsNetworkFee is a free data retrieval call binding the contract method 0xecd6804d.
//
// Solidity: function getOperatorsNetworkFee(address vault, address network) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetOperatorsNetworkFee(vault common.Address, network common.Address) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetOperatorsNetworkFee(&_IFeeRegistry.CallOpts, vault, network)
}

// GetOperatorsNetworkFee is a free data retrieval call binding the contract method 0xecd6804d.
//
// Solidity: function getOperatorsNetworkFee(address vault, address network) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetOperatorsNetworkFee(vault common.Address, network common.Address) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetOperatorsNetworkFee(&_IFeeRegistry.CallOpts, vault, network)
}

// GetOperatorsNetworkFeeAt is a free data retrieval call binding the contract method 0xb023ab70.
//
// Solidity: function getOperatorsNetworkFeeAt(address vault, address network, uint48 timestamp, bytes hint) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetOperatorsNetworkFeeAt(opts *bind.CallOpts, vault common.Address, network common.Address, timestamp *big.Int, hint []byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getOperatorsNetworkFeeAt", vault, network, timestamp, hint)

	outstruct := new(struct {
		IsEnabled bool
		Fee       *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.IsEnabled = *abi.ConvertType(out[0], new(bool)).(*bool)
	outstruct.Fee = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// GetOperatorsNetworkFeeAt is a free data retrieval call binding the contract method 0xb023ab70.
//
// Solidity: function getOperatorsNetworkFeeAt(address vault, address network, uint48 timestamp, bytes hint) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetOperatorsNetworkFeeAt(vault common.Address, network common.Address, timestamp *big.Int, hint []byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetOperatorsNetworkFeeAt(&_IFeeRegistry.CallOpts, vault, network, timestamp, hint)
}

// GetOperatorsNetworkFeeAt is a free data retrieval call binding the contract method 0xb023ab70.
//
// Solidity: function getOperatorsNetworkFeeAt(address vault, address network, uint48 timestamp, bytes hint) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetOperatorsNetworkFeeAt(vault common.Address, network common.Address, timestamp *big.Int, hint []byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetOperatorsNetworkFeeAt(&_IFeeRegistry.CallOpts, vault, network, timestamp, hint)
}

// GetProtocolFee is a free data retrieval call binding the contract method 0x056b7443.
//
// Solidity: function getProtocolFee(bytes32 id) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCaller) GetProtocolFee(opts *bind.CallOpts, id [32]byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	var out []interface{}
	err := _IFeeRegistry.contract.Call(opts, &out, "getProtocolFee", id)

	outstruct := new(struct {
		IsEnabled bool
		Fee       *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.IsEnabled = *abi.ConvertType(out[0], new(bool)).(*bool)
	outstruct.Fee = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// GetProtocolFee is a free data retrieval call binding the contract method 0x056b7443.
//
// Solidity: function getProtocolFee(bytes32 id) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistrySession) GetProtocolFee(id [32]byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetProtocolFee(&_IFeeRegistry.CallOpts, id)
}

// GetProtocolFee is a free data retrieval call binding the contract method 0x056b7443.
//
// Solidity: function getProtocolFee(bytes32 id) view returns(bool isEnabled, uint256 fee)
func (_IFeeRegistry *IFeeRegistryCallerSession) GetProtocolFee(id [32]byte) (struct {
	IsEnabled bool
	Fee       *big.Int
}, error) {
	return _IFeeRegistry.Contract.GetProtocolFee(&_IFeeRegistry.CallOpts, id)
}

// SetCuratorFee is a paid mutator transaction binding the contract method 0x42370fd9.
//
// Solidity: function setCuratorFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactor) SetCuratorFee(opts *bind.TransactOpts, vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.contract.Transact(opts, "setCuratorFee", vault, fee)
}

// SetCuratorFee is a paid mutator transaction binding the contract method 0x42370fd9.
//
// Solidity: function setCuratorFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistrySession) SetCuratorFee(vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetCuratorFee(&_IFeeRegistry.TransactOpts, vault, fee)
}

// SetCuratorFee is a paid mutator transaction binding the contract method 0x42370fd9.
//
// Solidity: function setCuratorFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactorSession) SetCuratorFee(vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetCuratorFee(&_IFeeRegistry.TransactOpts, vault, fee)
}

// SetCuratorNetworkFee is a paid mutator transaction binding the contract method 0x40d39ba6.
//
// Solidity: function setCuratorNetworkFee(address vault, address networkOrAdapter, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactor) SetCuratorNetworkFee(opts *bind.TransactOpts, vault common.Address, networkOrAdapter common.Address, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.contract.Transact(opts, "setCuratorNetworkFee", vault, networkOrAdapter, enable, fee)
}

// SetCuratorNetworkFee is a paid mutator transaction binding the contract method 0x40d39ba6.
//
// Solidity: function setCuratorNetworkFee(address vault, address networkOrAdapter, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistrySession) SetCuratorNetworkFee(vault common.Address, networkOrAdapter common.Address, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetCuratorNetworkFee(&_IFeeRegistry.TransactOpts, vault, networkOrAdapter, enable, fee)
}

// SetCuratorNetworkFee is a paid mutator transaction binding the contract method 0x40d39ba6.
//
// Solidity: function setCuratorNetworkFee(address vault, address networkOrAdapter, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactorSession) SetCuratorNetworkFee(vault common.Address, networkOrAdapter common.Address, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetCuratorNetworkFee(&_IFeeRegistry.TransactOpts, vault, networkOrAdapter, enable, fee)
}

// SetInstantWithdrawFee is a paid mutator transaction binding the contract method 0x5be3326f.
//
// Solidity: function setInstantWithdrawFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactor) SetInstantWithdrawFee(opts *bind.TransactOpts, vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.contract.Transact(opts, "setInstantWithdrawFee", vault, fee)
}

// SetInstantWithdrawFee is a paid mutator transaction binding the contract method 0x5be3326f.
//
// Solidity: function setInstantWithdrawFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistrySession) SetInstantWithdrawFee(vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetInstantWithdrawFee(&_IFeeRegistry.TransactOpts, vault, fee)
}

// SetInstantWithdrawFee is a paid mutator transaction binding the contract method 0x5be3326f.
//
// Solidity: function setInstantWithdrawFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactorSession) SetInstantWithdrawFee(vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetInstantWithdrawFee(&_IFeeRegistry.TransactOpts, vault, fee)
}

// SetOperatorsFee is a paid mutator transaction binding the contract method 0xaed0ae2d.
//
// Solidity: function setOperatorsFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactor) SetOperatorsFee(opts *bind.TransactOpts, vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.contract.Transact(opts, "setOperatorsFee", vault, fee)
}

// SetOperatorsFee is a paid mutator transaction binding the contract method 0xaed0ae2d.
//
// Solidity: function setOperatorsFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistrySession) SetOperatorsFee(vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetOperatorsFee(&_IFeeRegistry.TransactOpts, vault, fee)
}

// SetOperatorsFee is a paid mutator transaction binding the contract method 0xaed0ae2d.
//
// Solidity: function setOperatorsFee(address vault, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactorSession) SetOperatorsFee(vault common.Address, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetOperatorsFee(&_IFeeRegistry.TransactOpts, vault, fee)
}

// SetOperatorsNetworkFee is a paid mutator transaction binding the contract method 0x9940df1c.
//
// Solidity: function setOperatorsNetworkFee(address vault, address network, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactor) SetOperatorsNetworkFee(opts *bind.TransactOpts, vault common.Address, network common.Address, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.contract.Transact(opts, "setOperatorsNetworkFee", vault, network, enable, fee)
}

// SetOperatorsNetworkFee is a paid mutator transaction binding the contract method 0x9940df1c.
//
// Solidity: function setOperatorsNetworkFee(address vault, address network, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistrySession) SetOperatorsNetworkFee(vault common.Address, network common.Address, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetOperatorsNetworkFee(&_IFeeRegistry.TransactOpts, vault, network, enable, fee)
}

// SetOperatorsNetworkFee is a paid mutator transaction binding the contract method 0x9940df1c.
//
// Solidity: function setOperatorsNetworkFee(address vault, address network, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactorSession) SetOperatorsNetworkFee(vault common.Address, network common.Address, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetOperatorsNetworkFee(&_IFeeRegistry.TransactOpts, vault, network, enable, fee)
}

// SetProtocolFee is a paid mutator transaction binding the contract method 0xf757168a.
//
// Solidity: function setProtocolFee(bytes32 id, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactor) SetProtocolFee(opts *bind.TransactOpts, id [32]byte, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.contract.Transact(opts, "setProtocolFee", id, enable, fee)
}

// SetProtocolFee is a paid mutator transaction binding the contract method 0xf757168a.
//
// Solidity: function setProtocolFee(bytes32 id, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistrySession) SetProtocolFee(id [32]byte, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetProtocolFee(&_IFeeRegistry.TransactOpts, id, enable, fee)
}

// SetProtocolFee is a paid mutator transaction binding the contract method 0xf757168a.
//
// Solidity: function setProtocolFee(bytes32 id, bool enable, uint256 fee) returns()
func (_IFeeRegistry *IFeeRegistryTransactorSession) SetProtocolFee(id [32]byte, enable bool, fee *big.Int) (*types.Transaction, error) {
	return _IFeeRegistry.Contract.SetProtocolFee(&_IFeeRegistry.TransactOpts, id, enable, fee)
}

// IFeeRegistrySetCuratorFeeIterator is returned from FilterSetCuratorFee and is used to iterate over the raw logs and unpacked data for SetCuratorFee events raised by the IFeeRegistry contract.
type IFeeRegistrySetCuratorFeeIterator struct {
	Event *IFeeRegistrySetCuratorFee // Event containing the contract specifics and raw log

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
func (it *IFeeRegistrySetCuratorFeeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IFeeRegistrySetCuratorFee)
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
		it.Event = new(IFeeRegistrySetCuratorFee)
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
func (it *IFeeRegistrySetCuratorFeeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IFeeRegistrySetCuratorFeeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IFeeRegistrySetCuratorFee represents a SetCuratorFee event raised by the IFeeRegistry contract.
type IFeeRegistrySetCuratorFee struct {
	Vault common.Address
	Fee   *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterSetCuratorFee is a free log retrieval operation binding the contract event 0x92a205fa1b59a9987cd881451df88dedf0819407a8040621cdae1db5cc6063c4.
//
// Solidity: event SetCuratorFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) FilterSetCuratorFee(opts *bind.FilterOpts, vault []common.Address) (*IFeeRegistrySetCuratorFeeIterator, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IFeeRegistry.contract.FilterLogs(opts, "SetCuratorFee", vaultRule)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistrySetCuratorFeeIterator{contract: _IFeeRegistry.contract, event: "SetCuratorFee", logs: logs, sub: sub}, nil
}

// WatchSetCuratorFee is a free log subscription operation binding the contract event 0x92a205fa1b59a9987cd881451df88dedf0819407a8040621cdae1db5cc6063c4.
//
// Solidity: event SetCuratorFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) WatchSetCuratorFee(opts *bind.WatchOpts, sink chan<- *IFeeRegistrySetCuratorFee, vault []common.Address) (event.Subscription, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IFeeRegistry.contract.WatchLogs(opts, "SetCuratorFee", vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IFeeRegistrySetCuratorFee)
				if err := _IFeeRegistry.contract.UnpackLog(event, "SetCuratorFee", log); err != nil {
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

// ParseSetCuratorFee is a log parse operation binding the contract event 0x92a205fa1b59a9987cd881451df88dedf0819407a8040621cdae1db5cc6063c4.
//
// Solidity: event SetCuratorFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) ParseSetCuratorFee(log types.Log) (*IFeeRegistrySetCuratorFee, error) {
	event := new(IFeeRegistrySetCuratorFee)
	if err := _IFeeRegistry.contract.UnpackLog(event, "SetCuratorFee", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IFeeRegistrySetCuratorNetworkFeeIterator is returned from FilterSetCuratorNetworkFee and is used to iterate over the raw logs and unpacked data for SetCuratorNetworkFee events raised by the IFeeRegistry contract.
type IFeeRegistrySetCuratorNetworkFeeIterator struct {
	Event *IFeeRegistrySetCuratorNetworkFee // Event containing the contract specifics and raw log

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
func (it *IFeeRegistrySetCuratorNetworkFeeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IFeeRegistrySetCuratorNetworkFee)
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
		it.Event = new(IFeeRegistrySetCuratorNetworkFee)
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
func (it *IFeeRegistrySetCuratorNetworkFeeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IFeeRegistrySetCuratorNetworkFeeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IFeeRegistrySetCuratorNetworkFee represents a SetCuratorNetworkFee event raised by the IFeeRegistry contract.
type IFeeRegistrySetCuratorNetworkFee struct {
	Vault            common.Address
	NetworkOrAdapter common.Address
	Enable           bool
	Fee              *big.Int
	Raw              types.Log // Blockchain specific contextual infos
}

// FilterSetCuratorNetworkFee is a free log retrieval operation binding the contract event 0xb74c23e5716eba250fb7f8b57abd32100233ca093ababcc55215c6c2eac55589.
//
// Solidity: event SetCuratorNetworkFee(address indexed vault, address indexed networkOrAdapter, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) FilterSetCuratorNetworkFee(opts *bind.FilterOpts, vault []common.Address, networkOrAdapter []common.Address) (*IFeeRegistrySetCuratorNetworkFeeIterator, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}
	var networkOrAdapterRule []interface{}
	for _, networkOrAdapterItem := range networkOrAdapter {
		networkOrAdapterRule = append(networkOrAdapterRule, networkOrAdapterItem)
	}

	logs, sub, err := _IFeeRegistry.contract.FilterLogs(opts, "SetCuratorNetworkFee", vaultRule, networkOrAdapterRule)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistrySetCuratorNetworkFeeIterator{contract: _IFeeRegistry.contract, event: "SetCuratorNetworkFee", logs: logs, sub: sub}, nil
}

// WatchSetCuratorNetworkFee is a free log subscription operation binding the contract event 0xb74c23e5716eba250fb7f8b57abd32100233ca093ababcc55215c6c2eac55589.
//
// Solidity: event SetCuratorNetworkFee(address indexed vault, address indexed networkOrAdapter, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) WatchSetCuratorNetworkFee(opts *bind.WatchOpts, sink chan<- *IFeeRegistrySetCuratorNetworkFee, vault []common.Address, networkOrAdapter []common.Address) (event.Subscription, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}
	var networkOrAdapterRule []interface{}
	for _, networkOrAdapterItem := range networkOrAdapter {
		networkOrAdapterRule = append(networkOrAdapterRule, networkOrAdapterItem)
	}

	logs, sub, err := _IFeeRegistry.contract.WatchLogs(opts, "SetCuratorNetworkFee", vaultRule, networkOrAdapterRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IFeeRegistrySetCuratorNetworkFee)
				if err := _IFeeRegistry.contract.UnpackLog(event, "SetCuratorNetworkFee", log); err != nil {
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

// ParseSetCuratorNetworkFee is a log parse operation binding the contract event 0xb74c23e5716eba250fb7f8b57abd32100233ca093ababcc55215c6c2eac55589.
//
// Solidity: event SetCuratorNetworkFee(address indexed vault, address indexed networkOrAdapter, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) ParseSetCuratorNetworkFee(log types.Log) (*IFeeRegistrySetCuratorNetworkFee, error) {
	event := new(IFeeRegistrySetCuratorNetworkFee)
	if err := _IFeeRegistry.contract.UnpackLog(event, "SetCuratorNetworkFee", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IFeeRegistrySetInstantWithdrawalFeeIterator is returned from FilterSetInstantWithdrawalFee and is used to iterate over the raw logs and unpacked data for SetInstantWithdrawalFee events raised by the IFeeRegistry contract.
type IFeeRegistrySetInstantWithdrawalFeeIterator struct {
	Event *IFeeRegistrySetInstantWithdrawalFee // Event containing the contract specifics and raw log

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
func (it *IFeeRegistrySetInstantWithdrawalFeeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IFeeRegistrySetInstantWithdrawalFee)
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
		it.Event = new(IFeeRegistrySetInstantWithdrawalFee)
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
func (it *IFeeRegistrySetInstantWithdrawalFeeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IFeeRegistrySetInstantWithdrawalFeeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IFeeRegistrySetInstantWithdrawalFee represents a SetInstantWithdrawalFee event raised by the IFeeRegistry contract.
type IFeeRegistrySetInstantWithdrawalFee struct {
	Vault common.Address
	Fee   *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterSetInstantWithdrawalFee is a free log retrieval operation binding the contract event 0xb7b27782e8b990da0bbf69770228575064c4c884ec6e8fbafff814cbb3396b30.
//
// Solidity: event SetInstantWithdrawalFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) FilterSetInstantWithdrawalFee(opts *bind.FilterOpts, vault []common.Address) (*IFeeRegistrySetInstantWithdrawalFeeIterator, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IFeeRegistry.contract.FilterLogs(opts, "SetInstantWithdrawalFee", vaultRule)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistrySetInstantWithdrawalFeeIterator{contract: _IFeeRegistry.contract, event: "SetInstantWithdrawalFee", logs: logs, sub: sub}, nil
}

// WatchSetInstantWithdrawalFee is a free log subscription operation binding the contract event 0xb7b27782e8b990da0bbf69770228575064c4c884ec6e8fbafff814cbb3396b30.
//
// Solidity: event SetInstantWithdrawalFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) WatchSetInstantWithdrawalFee(opts *bind.WatchOpts, sink chan<- *IFeeRegistrySetInstantWithdrawalFee, vault []common.Address) (event.Subscription, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IFeeRegistry.contract.WatchLogs(opts, "SetInstantWithdrawalFee", vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IFeeRegistrySetInstantWithdrawalFee)
				if err := _IFeeRegistry.contract.UnpackLog(event, "SetInstantWithdrawalFee", log); err != nil {
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

// ParseSetInstantWithdrawalFee is a log parse operation binding the contract event 0xb7b27782e8b990da0bbf69770228575064c4c884ec6e8fbafff814cbb3396b30.
//
// Solidity: event SetInstantWithdrawalFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) ParseSetInstantWithdrawalFee(log types.Log) (*IFeeRegistrySetInstantWithdrawalFee, error) {
	event := new(IFeeRegistrySetInstantWithdrawalFee)
	if err := _IFeeRegistry.contract.UnpackLog(event, "SetInstantWithdrawalFee", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IFeeRegistrySetOperatorsFeeIterator is returned from FilterSetOperatorsFee and is used to iterate over the raw logs and unpacked data for SetOperatorsFee events raised by the IFeeRegistry contract.
type IFeeRegistrySetOperatorsFeeIterator struct {
	Event *IFeeRegistrySetOperatorsFee // Event containing the contract specifics and raw log

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
func (it *IFeeRegistrySetOperatorsFeeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IFeeRegistrySetOperatorsFee)
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
		it.Event = new(IFeeRegistrySetOperatorsFee)
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
func (it *IFeeRegistrySetOperatorsFeeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IFeeRegistrySetOperatorsFeeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IFeeRegistrySetOperatorsFee represents a SetOperatorsFee event raised by the IFeeRegistry contract.
type IFeeRegistrySetOperatorsFee struct {
	Vault common.Address
	Fee   *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterSetOperatorsFee is a free log retrieval operation binding the contract event 0x43cd94e947f8a945930498fa02aacf732b74492535643f774929d1e87f45b016.
//
// Solidity: event SetOperatorsFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) FilterSetOperatorsFee(opts *bind.FilterOpts, vault []common.Address) (*IFeeRegistrySetOperatorsFeeIterator, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IFeeRegistry.contract.FilterLogs(opts, "SetOperatorsFee", vaultRule)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistrySetOperatorsFeeIterator{contract: _IFeeRegistry.contract, event: "SetOperatorsFee", logs: logs, sub: sub}, nil
}

// WatchSetOperatorsFee is a free log subscription operation binding the contract event 0x43cd94e947f8a945930498fa02aacf732b74492535643f774929d1e87f45b016.
//
// Solidity: event SetOperatorsFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) WatchSetOperatorsFee(opts *bind.WatchOpts, sink chan<- *IFeeRegistrySetOperatorsFee, vault []common.Address) (event.Subscription, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}

	logs, sub, err := _IFeeRegistry.contract.WatchLogs(opts, "SetOperatorsFee", vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IFeeRegistrySetOperatorsFee)
				if err := _IFeeRegistry.contract.UnpackLog(event, "SetOperatorsFee", log); err != nil {
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

// ParseSetOperatorsFee is a log parse operation binding the contract event 0x43cd94e947f8a945930498fa02aacf732b74492535643f774929d1e87f45b016.
//
// Solidity: event SetOperatorsFee(address indexed vault, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) ParseSetOperatorsFee(log types.Log) (*IFeeRegistrySetOperatorsFee, error) {
	event := new(IFeeRegistrySetOperatorsFee)
	if err := _IFeeRegistry.contract.UnpackLog(event, "SetOperatorsFee", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IFeeRegistrySetOperatorsNetworkFeeIterator is returned from FilterSetOperatorsNetworkFee and is used to iterate over the raw logs and unpacked data for SetOperatorsNetworkFee events raised by the IFeeRegistry contract.
type IFeeRegistrySetOperatorsNetworkFeeIterator struct {
	Event *IFeeRegistrySetOperatorsNetworkFee // Event containing the contract specifics and raw log

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
func (it *IFeeRegistrySetOperatorsNetworkFeeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IFeeRegistrySetOperatorsNetworkFee)
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
		it.Event = new(IFeeRegistrySetOperatorsNetworkFee)
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
func (it *IFeeRegistrySetOperatorsNetworkFeeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IFeeRegistrySetOperatorsNetworkFeeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IFeeRegistrySetOperatorsNetworkFee represents a SetOperatorsNetworkFee event raised by the IFeeRegistry contract.
type IFeeRegistrySetOperatorsNetworkFee struct {
	Vault   common.Address
	Network common.Address
	Enable  bool
	Fee     *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterSetOperatorsNetworkFee is a free log retrieval operation binding the contract event 0x459760cf8c96d7a9589e4448db7aa2da97344165b1e73bd559846312bf371ecd.
//
// Solidity: event SetOperatorsNetworkFee(address indexed vault, address indexed network, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) FilterSetOperatorsNetworkFee(opts *bind.FilterOpts, vault []common.Address, network []common.Address) (*IFeeRegistrySetOperatorsNetworkFeeIterator, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}

	logs, sub, err := _IFeeRegistry.contract.FilterLogs(opts, "SetOperatorsNetworkFee", vaultRule, networkRule)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistrySetOperatorsNetworkFeeIterator{contract: _IFeeRegistry.contract, event: "SetOperatorsNetworkFee", logs: logs, sub: sub}, nil
}

// WatchSetOperatorsNetworkFee is a free log subscription operation binding the contract event 0x459760cf8c96d7a9589e4448db7aa2da97344165b1e73bd559846312bf371ecd.
//
// Solidity: event SetOperatorsNetworkFee(address indexed vault, address indexed network, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) WatchSetOperatorsNetworkFee(opts *bind.WatchOpts, sink chan<- *IFeeRegistrySetOperatorsNetworkFee, vault []common.Address, network []common.Address) (event.Subscription, error) {

	var vaultRule []interface{}
	for _, vaultItem := range vault {
		vaultRule = append(vaultRule, vaultItem)
	}
	var networkRule []interface{}
	for _, networkItem := range network {
		networkRule = append(networkRule, networkItem)
	}

	logs, sub, err := _IFeeRegistry.contract.WatchLogs(opts, "SetOperatorsNetworkFee", vaultRule, networkRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IFeeRegistrySetOperatorsNetworkFee)
				if err := _IFeeRegistry.contract.UnpackLog(event, "SetOperatorsNetworkFee", log); err != nil {
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

// ParseSetOperatorsNetworkFee is a log parse operation binding the contract event 0x459760cf8c96d7a9589e4448db7aa2da97344165b1e73bd559846312bf371ecd.
//
// Solidity: event SetOperatorsNetworkFee(address indexed vault, address indexed network, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) ParseSetOperatorsNetworkFee(log types.Log) (*IFeeRegistrySetOperatorsNetworkFee, error) {
	event := new(IFeeRegistrySetOperatorsNetworkFee)
	if err := _IFeeRegistry.contract.UnpackLog(event, "SetOperatorsNetworkFee", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IFeeRegistrySetProtocolFeeIterator is returned from FilterSetProtocolFee and is used to iterate over the raw logs and unpacked data for SetProtocolFee events raised by the IFeeRegistry contract.
type IFeeRegistrySetProtocolFeeIterator struct {
	Event *IFeeRegistrySetProtocolFee // Event containing the contract specifics and raw log

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
func (it *IFeeRegistrySetProtocolFeeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IFeeRegistrySetProtocolFee)
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
		it.Event = new(IFeeRegistrySetProtocolFee)
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
func (it *IFeeRegistrySetProtocolFeeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IFeeRegistrySetProtocolFeeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IFeeRegistrySetProtocolFee represents a SetProtocolFee event raised by the IFeeRegistry contract.
type IFeeRegistrySetProtocolFee struct {
	Id     [32]byte
	Enable bool
	Fee    *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterSetProtocolFee is a free log retrieval operation binding the contract event 0x6536bc3f374ddefb1852eb0cbe8578d1553c1e130e63e6ea86cc1a5aea614873.
//
// Solidity: event SetProtocolFee(bytes32 indexed id, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) FilterSetProtocolFee(opts *bind.FilterOpts, id [][32]byte) (*IFeeRegistrySetProtocolFeeIterator, error) {

	var idRule []interface{}
	for _, idItem := range id {
		idRule = append(idRule, idItem)
	}

	logs, sub, err := _IFeeRegistry.contract.FilterLogs(opts, "SetProtocolFee", idRule)
	if err != nil {
		return nil, err
	}
	return &IFeeRegistrySetProtocolFeeIterator{contract: _IFeeRegistry.contract, event: "SetProtocolFee", logs: logs, sub: sub}, nil
}

// WatchSetProtocolFee is a free log subscription operation binding the contract event 0x6536bc3f374ddefb1852eb0cbe8578d1553c1e130e63e6ea86cc1a5aea614873.
//
// Solidity: event SetProtocolFee(bytes32 indexed id, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) WatchSetProtocolFee(opts *bind.WatchOpts, sink chan<- *IFeeRegistrySetProtocolFee, id [][32]byte) (event.Subscription, error) {

	var idRule []interface{}
	for _, idItem := range id {
		idRule = append(idRule, idItem)
	}

	logs, sub, err := _IFeeRegistry.contract.WatchLogs(opts, "SetProtocolFee", idRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IFeeRegistrySetProtocolFee)
				if err := _IFeeRegistry.contract.UnpackLog(event, "SetProtocolFee", log); err != nil {
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

// ParseSetProtocolFee is a log parse operation binding the contract event 0x6536bc3f374ddefb1852eb0cbe8578d1553c1e130e63e6ea86cc1a5aea614873.
//
// Solidity: event SetProtocolFee(bytes32 indexed id, bool enable, uint256 fee)
func (_IFeeRegistry *IFeeRegistryFilterer) ParseSetProtocolFee(log types.Log) (*IFeeRegistrySetProtocolFee, error) {
	event := new(IFeeRegistrySetProtocolFee)
	if err := _IFeeRegistry.contract.UnpackLog(event, "SetProtocolFee", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
