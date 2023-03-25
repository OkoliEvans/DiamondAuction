// Code generated by mockery v2.22.1. DO NOT EDIT.

package mocks

import (
	context "context"

	types "github.com/smartcontractkit/chainlink/common/txmgr/types"
	mock "github.com/stretchr/testify/mock"
)

// HeadTrackable is an autogenerated mock type for the HeadTrackable type
type HeadTrackable[H types.Head] struct {
	mock.Mock
}

// OnNewLongestChain provides a mock function with given fields: ctx, head
func (_m *HeadTrackable[H]) OnNewLongestChain(ctx context.Context, head H) {
	_m.Called(ctx, head)
}

type mockConstructorTestingTNewHeadTrackable interface {
	mock.TestingT
	Cleanup(func())
}

// NewHeadTrackable creates a new instance of HeadTrackable. It also registers a testing interface on the mock and a cleanup function to assert the mocks expectations.
func NewHeadTrackable[H types.Head](t mockConstructorTestingTNewHeadTrackable) *HeadTrackable[H] {
	mock := &HeadTrackable[H]{}
	mock.Mock.Test(t)

	t.Cleanup(func() { mock.AssertExpectations(t) })

	return mock
}
