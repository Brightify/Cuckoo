//
//  CuckooFunctions.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Starts the stubbing for the given mock. Can be used multiple times.
public func stub<M: Mock>(_ mock: M, block: (M.Stubbing) -> Void) {
    block(mock.getStubbingProxy())
}

/// Used in stubbing. Currently only returns passed function but this may change in the future so it is not recommended to omit it.
// TODO: Uncomment the `: BaseStubFunctionTrait` before the next major release to improve API.
public func when<F/*: BaseStubFunctionTrait*/>(_ function: F) -> F {
    return function
}

/// Creates object used for verification of calls.
public func verify<M: Mock>(_ mock: M, _ callMatcher: CallMatcher = times(1), file: StaticString = #file, line: UInt = #line) -> M.Verification {
    return mock.getVerificationProxy(callMatcher, sourceLocation: (file, line))
}

/// Clears all invocations and stubs of mocks.
public func reset(_ mocks: HasMockManager...) {
    mocks.forEach { mock in
        mock.cuckoo_manager.reset()
    }
}

/// Clears all stubs of mocks.
public func clearStubs<M: Mock>(_ mocks: M...) {
    mocks.forEach { mock in
        mock.cuckoo_manager.clearStubs()
    }
}

/// Clears all invocations of mocks.
public func clearInvocations<M: Mock>(_ mocks: M...) {
    mocks.forEach { mock in
        mock.cuckoo_manager.clearInvocations()
    }
}

/// Checks if there are no more uverified calls.
public func verifyNoMoreInteractions<M: Mock>(_ mocks: M..., file: StaticString = #file, line: UInt = #line) {
    mocks.forEach { mock in
        mock.cuckoo_manager.verifyNoMoreInteractions((file, line))
    }
}
