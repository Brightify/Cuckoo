//
//  CuckooFunctions.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Starts the stubbing for the given mock. Can be used multiple times.
public func stub<M: Mock>(mock: M, @noescape block: M.Stubbing -> Void) {
    block(mock.getStubbingProxy())
}

/// Used in stubbing. Currently only returns passed function but this may change in the future so it is not recommended to omit it.
@warn_unused_result
public func when<F>(function: F) -> F {
    return function
}

/// Creates object used for verification of calls.
@warn_unused_result
public func verify<M: Mock>(mock: M, _ callMatcher: CallMatcher = times(1), file: StaticString = #file, line: UInt = #line) -> M.Verification {
    return mock.getVerificationProxy(callMatcher, sourceLocation: (file, line))
}

/// Clears all invocations and stubs of mocks.
public func reset<M: Mock>(mocks: M...) {
    mocks.forEach { mock in
        mock.manager.reset()
    }
}

/// Clears all stubs of mocks.
public func clearStubs<M: Mock>(mocks: M...) {
    mocks.forEach { mock in
        mock.manager.clearStubs()
    }
}

/// Clears all invocations of mocks.
public func clearInvocations<M: Mock>(mocks: M...) {
    mocks.forEach { mock in
        mock.manager.clearInvocations()
    }
}

/// Checks if there are no more uverified calls.
public func verifyNoMoreInteractions<M: Mock>(mocks: M..., file: StaticString = #file, line: UInt = #line) {
    mocks.forEach { mock in
        mock.manager.verifyNoMoreInteractions((file, line))
    }
}