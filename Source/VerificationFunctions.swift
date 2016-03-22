//
//  VerificationFunctions.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

@warn_unused_result
public func verify<M: Mock>(mock: M, file: StaticString = #file, line: UInt = #line) -> M.Verification {
    return verify(mock, times(1), file: file, line: line)
}

@warn_unused_result
public func verify<M: Mock>(mock: M, _ matcher: AnyMatcher<[StubCall]>, file: StaticString = #file, line: UInt = #line) -> M.Verification {
    return mock.manager.getVerificationProxy(matcher, sourceLocation: SourceLocation(file: file, line: line))
}