//
//  VerificationMatchers.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

private func compareCalls(count: Int, whenNil: Bool = false, using function: (Int, Int) -> Bool)(stub: Stub?) -> Bool {
    return stub.map { function(count, $0.calledTimes) } ?? whenNil
}

@warn_unused_result
public func times(count: Int) -> AnyMatcher<Stub?> {
    return FunctionMatcher(function: compareCalls(count, using: ==)) {
        "expected to be called exactly <\(count)> times, but was called <\($0)> times"
    }.typeErased()
}

@warn_unused_result
public func never() -> AnyMatcher<Stub?> {
    return FunctionMatcher(function: compareCalls(0, whenNil: true, using: ==)) {
        "expected to not be called, but was called <\($0)> times"
    }.typeErased()
}

@warn_unused_result
public func atLeastOnce() -> AnyMatcher<Stub?> {
    return atLeast(1)
}

@warn_unused_result
public func atLeast(count: Int) -> AnyMatcher<Stub?> {
    return FunctionMatcher(function: compareCalls(count, using: >=)) {
        "expected to be called at least <\(count)> times, but was called only <\($0)> times"
    }.typeErased()
}

@warn_unused_result
public func atMost(count: Int) -> AnyMatcher<Stub?> {
    return FunctionMatcher(function: compareCalls(count, whenNil: true, using: <=)) {
        "expected to be called at most <\(count)> times, but was called <\($0)> times"
    }.typeErased()
}

@warn_unused_result
public func equalTo<T: Equatable>(value: T) -> AnyMatcher<T> {
    return equalTo(value, equalWhen: ==)
}

@warn_unused_result
public func equalTo<T: AnyObject>(value: T) -> AnyMatcher<T> {
    return equalTo(value, equalWhen: ===)
}

@warn_unused_result
public func equalTo<T>(value: T, equalWhen equalityFunction: (T, T) -> Bool) -> AnyMatcher<T> {
    return FunctionMatcher(original: value, function: equalityFunction) {
        "expected value equal to <\($0)> got <\($1)"
    }.typeErased()
}

@warn_unused_result
public func anyInt() -> AnyMatcher<Int> {
    return AnyMatcher()
}

@warn_unused_result
public func anyString() -> AnyMatcher<String> {
    return AnyMatcher()
}

@warn_unused_result
public func any() -> AnyMatcher<Any> {
    return AnyMatcher()
}