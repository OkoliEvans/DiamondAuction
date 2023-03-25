// Code generated by mockery v2.22.1. DO NOT EDIT.

package mocks

import (
	big "math/big"

	common "github.com/ethereum/go-ethereum/common"
	ethkey "github.com/smartcontractkit/chainlink/core/services/keystore/keys/ethkey"

	mock "github.com/stretchr/testify/mock"
)

// KeyStoreInterface is an autogenerated mock type for the KeyStoreInterface type
type KeyStoreInterface struct {
	mock.Mock
}

// EnabledKeysForChain provides a mock function with given fields: chainID
func (_m *KeyStoreInterface) EnabledKeysForChain(chainID *big.Int) ([]ethkey.KeyV2, error) {
	ret := _m.Called(chainID)

	var r0 []ethkey.KeyV2
	var r1 error
	if rf, ok := ret.Get(0).(func(*big.Int) ([]ethkey.KeyV2, error)); ok {
		return rf(chainID)
	}
	if rf, ok := ret.Get(0).(func(*big.Int) []ethkey.KeyV2); ok {
		r0 = rf(chainID)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).([]ethkey.KeyV2)
		}
	}

	if rf, ok := ret.Get(1).(func(*big.Int) error); ok {
		r1 = rf(chainID)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// GetRoundRobinAddress provides a mock function with given fields: chainID, addrs
func (_m *KeyStoreInterface) GetRoundRobinAddress(chainID *big.Int, addrs ...common.Address) (common.Address, error) {
	_va := make([]interface{}, len(addrs))
	for _i := range addrs {
		_va[_i] = addrs[_i]
	}
	var _ca []interface{}
	_ca = append(_ca, chainID)
	_ca = append(_ca, _va...)
	ret := _m.Called(_ca...)

	var r0 common.Address
	var r1 error
	if rf, ok := ret.Get(0).(func(*big.Int, ...common.Address) (common.Address, error)); ok {
		return rf(chainID, addrs...)
	}
	if rf, ok := ret.Get(0).(func(*big.Int, ...common.Address) common.Address); ok {
		r0 = rf(chainID, addrs...)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(common.Address)
		}
	}

	if rf, ok := ret.Get(1).(func(*big.Int, ...common.Address) error); ok {
		r1 = rf(chainID, addrs...)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

type mockConstructorTestingTNewKeyStoreInterface interface {
	mock.TestingT
	Cleanup(func())
}

// NewKeyStoreInterface creates a new instance of KeyStoreInterface. It also registers a testing interface on the mock and a cleanup function to assert the mocks expectations.
func NewKeyStoreInterface(t mockConstructorTestingTNewKeyStoreInterface) *KeyStoreInterface {
	mock := &KeyStoreInterface{}
	mock.Mock.Test(t)

	t.Cleanup(func() { mock.AssertExpectations(t) })

	return mock
}