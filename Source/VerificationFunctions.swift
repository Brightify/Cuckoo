//
//  VerificationFunctions.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

@warn_unused_result
public func verify<M: Mock>(mock: M) -> M.Verification {
    return verify(mock, times(1))
}

@warn_unused_result
public func verify<M: Mock>(mock: M, _ matcher: AnyMatcher<Stub?>) -> M.Verification {
    return mock.manager.getVerificationProxy(matcher)
}