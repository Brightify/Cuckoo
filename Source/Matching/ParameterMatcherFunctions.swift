//
//  ParameterMatcherFunctions.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Returns an equality matcher. A shorthand for `equalTo`.
@warn_unused_result
public func eq<T: Equatable>(value: T) -> ParameterMatcher<T> {
    return equalTo(value)
}

/// Returns an identity matcher. A shorthand for `equalTo`
@warn_unused_result
public func eq<T: AnyObject>(value: T) -> ParameterMatcher<T> {
    return equalTo(value)
}

/// Returns a matcher using the supplied function. A shorthand for `equalTo`
@warn_unused_result
public func eq<T>(value: T, equalWhen equalityFunction: (T, T) -> Bool) -> ParameterMatcher<T> {
    return equalTo(value, equalWhen: equalityFunction)
}

/// Returns an equality matcher.
@warn_unused_result
public func equalTo<T: Equatable>(value: T) -> ParameterMatcher<T> {
    return equalTo(value, equalWhen: ==)
}

/// Returns an identity matcher.
@warn_unused_result
public func equalTo<T: AnyObject>(value: T) -> ParameterMatcher<T> {
    return equalTo(value, equalWhen: ===)
}

/// Returns a matcher using the supplied function.
@warn_unused_result
public func equalTo<T>(value: T, equalWhen equalityFunction: (T, T) -> Bool) -> ParameterMatcher<T> {
    return ParameterMatcher {
        return equalityFunction(value, $0)
    }
}

/// Returns a matcher matching any Int value.
@warn_unused_result
public func anyInt() -> ParameterMatcher<Int> {
    return ParameterMatcher()
}

/// Returns a matcher matching any String value.
@warn_unused_result
public func anyString() -> ParameterMatcher<String> {
    return ParameterMatcher()
}

/// Returns a matcher matching any closure.
@warn_unused_result
public func anyClosure<IN, OUT>() -> ParameterMatcher<IN -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any T value or nil.
@warn_unused_result
public func any<T>(type: T.Type = T.self) -> ParameterMatcher<T> {
    return ParameterMatcher()
}

/// Returns an equality matcher. A shorthand for `equalTo`.
@warn_unused_result
public func eq<T: Equatable>(value: T?) -> ParameterMatcher<T?> {
    return equalTo(value)
}

/// Returns an identity matcher. A shorthand for `equalTo`
@warn_unused_result
public func eq<T: AnyObject>(value: T?) -> ParameterMatcher<T?> {
    return equalTo(value)
}

/// Returns a matcher using the supplied function. A shorthand for `equalTo`
@warn_unused_result
public func eq<T>(value: T?, equalWhen equalityFunction: (T?, T?) -> Bool) -> ParameterMatcher<T?> {
    return equalTo(value, equalWhen: equalityFunction)
}

/// Returns an equality matcher.
@warn_unused_result
public func equalTo<T: Equatable>(value: T?) -> ParameterMatcher<T?> {
    return equalTo(value, equalWhen: ==)
}

/// Returns an identity matcher.
@warn_unused_result
public func equalTo<T: AnyObject>(value: T?) -> ParameterMatcher<T?> {
    return equalTo(value, equalWhen: ===)
}

/// Returns a matcher using the supplied function.
@warn_unused_result
public func equalTo<T>(value: T?, equalWhen equalityFunction: (T?, T?) -> Bool) -> ParameterMatcher<T?> {
    return ParameterMatcher {
        return equalityFunction(value, $0)
    }
}

/// Returns a matcher matching any Int value.
@warn_unused_result
public func anyInt() -> ParameterMatcher<Int?> {
    return notNil()
}

/// Returns a matcher matching any String value.
@warn_unused_result
public func anyString() -> ParameterMatcher<String?> {
    return notNil()
}

/// Returns a matcher matching any closure.
@warn_unused_result
public func anyClosure<IN, OUT>() -> ParameterMatcher<(IN -> OUT)?> {
    return notNil()
}

/// Returns a matcher matching any non nil value.
@warn_unused_result
public func notNil<T>() -> ParameterMatcher<T?> {
    return ParameterMatcher {
        if case .None = $0 { return false } else { return true }
    }
}