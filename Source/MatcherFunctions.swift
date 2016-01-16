//
//  VerificationMatchers.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

private func compareCalls(count: Int, whenNil: Bool = false, using function: (Int, Int) -> Bool)(calls: [StubCall]) -> Bool {
    return function(count, calls.count)
}

@warn_unused_result
public func times(count: Int) -> AnyMatcher<[StubCall]> {
    return FunctionMatcher(function: compareCalls(count, using: ==)) {
        $0.appendValue(count)
    }.typeErased()
}

@warn_unused_result
public func never() -> AnyMatcher<[StubCall]> {
    return times(0)
}

@warn_unused_result
public func atLeastOnce() -> AnyMatcher<[StubCall]> {
    return atLeast(1)
}

@warn_unused_result
public func atLeast(count: Int) -> AnyMatcher<[StubCall]> {
    return FunctionMatcher(function: compareCalls(count, using: >=)) {
        $0.appendText("called at least").appendValue(count)
    }.typeErased()
}

@warn_unused_result
public func atMost(count: Int) -> AnyMatcher<[StubCall]> {
    return FunctionMatcher(function: compareCalls(count, whenNil: true, using: <=)) {
        $0.appendText("called at most").appendValue(count)
    }.typeErased()
}

@warn_unused_result
public func eq<T: Equatable>(value: T) -> AnyMatcher<T> {
    return equalTo(value)
}

@warn_unused_result
public func eq<T: AnyObject>(value: T) -> AnyMatcher<T> {
    return equalTo(value)
}

@warn_unused_result
public func eq<T>(value: T, equalWhen equalityFunction: (T, T) -> Bool) -> AnyMatcher<T> {
    return equalTo(value, equalWhen: equalityFunction)
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
        $0.appendValue($0)
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
public func any<T>(type: T.Type = T.self) -> AnyMatcher<T> {
    return AnyMatcher()
}

@warn_unused_result
public func anyClosure<IN, OUT>() -> AnyMatcher<IN -> OUT> {
    return AnyMatcher()
}