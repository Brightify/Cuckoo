//
//  CuckooFunctions.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Start the stubbing for the given mock. Can be used multiple times.
public func stub<M: Mock>(mock: M, @noescape block: M.Stubbing -> Void) {
    block(mock.manager.getStubbingProxy())
}

@warn_unused_result
public func when<F>(function: F) -> F {
    return function
}

@warn_unused_result
public func verify<M: Mock>(mock: M, file: StaticString = #file, line: UInt = #line) -> M.Verification {
    return verify(mock, times(1), file: file, line: line)
}

@warn_unused_result
public func verify<M: Mock>(mock: M, _ matcher: AnyMatcher<[StubCall]>, file: StaticString = #file, line: UInt = #line) -> M.Verification {
    return mock.manager.getVerificationProxy(matcher, sourceLocation: SourceLocation(file: file, line: line))
}

/// Clear all invocations and stubs of mocks.
public func reset<M: Mock>(mocks: M...) {
    mocks.forEach { mock in
        mock.manager.reset()
    }
}

/// Clear all stubs of mocks.
public func clearStubs<M: Mock>(mocks: M...) {
    mocks.forEach { mock in
        mock.manager.clearStubs()
    }
}

/// Clear all invocations of mocks.
public func clearInvocations<M: Mock>(mocks: M...) {
    mocks.forEach { mock in
        mock.manager.clearInvocations()
    }
}

/// Checks if there are no more uverified calls.
public func verifyNoMoreInteractions<M: Mock>(mocks: M..., file: StaticString = #file, line: UInt = #line) {
    mocks.forEach { mock in
        mock.manager.verifyNoMoreInteractions(file, line: line)
    }
}