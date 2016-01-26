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

private func describeCallMismatch(calls: [StubCall], description: Description) {
    description.appendText("was called ").appendValue(calls.count).appendText(" times")
}

/// Returns a matcher ensuring a call was made **`count`** times.
@warn_unused_result
public func times(count: Int) -> AnyMatcher<[StubCall]> {
    return FunctionMatcher(function: compareCalls(count, using: ==), describeMismatch: describeCallMismatch) {
        $0.appendText("to be called ").appendValue(count).appendText(" times")
    }.typeErased()
}

/// Returns a matcher ensuring no call was made.
@warn_unused_result
public func never() -> AnyMatcher<[StubCall]> {
    return times(0)
}

/// Returns a matcher ensuring at least one call was made.
@warn_unused_result
public func atLeastOnce() -> AnyMatcher<[StubCall]> {
    return atLeast(1)
}

/// Returns a matcher ensuring call was made at least `count` times.
@warn_unused_result
public func atLeast(count: Int) -> AnyMatcher<[StubCall]> {
    return FunctionMatcher(function: compareCalls(count, using: >=), describeMismatch: describeCallMismatch) {
        $0.appendText("called at least").appendValue(count)
    }.typeErased()
}

/// Returns a matcher ensuring call was made at most `count` times.
@warn_unused_result
public func atMost(count: Int) -> AnyMatcher<[StubCall]> {
    return FunctionMatcher(function: compareCalls(count, whenNil: true, using: <=), describeMismatch: describeCallMismatch) {
        $0.appendText("called at most").appendValue(count)
    }.typeErased()
}

/// Returns an equality matcher. A shorthand for `equalTo`.
@warn_unused_result
public func eq<T: Equatable>(value: T) -> AnyMatcher<T> {
    return equalTo(value)
}

/// Returns an identity matcher. A shorthand for `equalTo`
@warn_unused_result
public func eq<T: AnyObject>(value: T) -> AnyMatcher<T> {
    return equalTo(value)
}

/// Returns a matcher using the supplied function. A shorthand for `equalTo`
@warn_unused_result
public func eq<T>(value: T, equalWhen equalityFunction: (T, T) -> Bool) -> AnyMatcher<T> {
    return equalTo(value, equalWhen: equalityFunction)
}

/// Returns an equality matcher.
@warn_unused_result
public func equalTo<T: Equatable>(value: T) -> AnyMatcher<T> {
    return equalTo(value, equalWhen: ==)
}

/// Returns an identity matcher.
@warn_unused_result
public func equalTo<T: AnyObject>(value: T) -> AnyMatcher<T> {
    return equalTo(value, equalWhen: ===)
}

/// Returns a matcher using the supplied function.
@warn_unused_result
public func equalTo<T>(value: T, equalWhen equalityFunction: (T, T) -> Bool) -> AnyMatcher<T> {
    return FunctionMatcher(original: value, function: equalityFunction) {
        $0.appendValue($0)
    }.typeErased()
}

/// Returns a matcher matching any Int value.
@warn_unused_result
public func anyInt() -> AnyMatcher<Int> {
    return AnyMatcher()
}

/// Returns a matcher matching any String value.
@warn_unused_result
public func anyString() -> AnyMatcher<String> {
    return AnyMatcher()
}

/// Returns a matcher matching any T value.
@warn_unused_result
public func any<T>(type: T.Type = T.self) -> AnyMatcher<T> {
    return AnyMatcher()
}

/// Returns a matcher matching any closure.
@warn_unused_result
public func anyClosure<IN, OUT>() -> AnyMatcher<IN -> OUT> {
    return AnyMatcher()
}