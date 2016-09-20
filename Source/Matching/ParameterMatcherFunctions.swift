//
//  ParameterMatcherFunctions.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Returns an equality matcher. A shorthand for `equalTo`.
public func eq<T: Equatable>(_ value: T) -> ParameterMatcher<T> {
    return equalTo(value)
}

/// Returns an identity matcher. A shorthand for `equalTo`
public func eq<T: AnyObject>(_ value: T) -> ParameterMatcher<T> {
    return equalTo(value)
}

/// Returns a matcher using the supplied function. A shorthand for `equalTo`
public func eq<T>(_ value: T, equalWhen equalityFunction: @escaping (T, T) -> Bool) -> ParameterMatcher<T> {
    return equalTo(value, equalWhen: equalityFunction)
}

/// Returns an equality matcher.
public func equalTo<T: Equatable>(_ value: T) -> ParameterMatcher<T> {
    return equalTo(value, equalWhen: ==)
}

/// Returns an identity matcher.
public func equalTo<T: AnyObject>(_ value: T) -> ParameterMatcher<T> {
    return equalTo(value, equalWhen: ===)
}

/// Returns a matcher using the supplied function.
public func equalTo<T>(_ value: T, equalWhen equalityFunction: @escaping (T, T) -> Bool) -> ParameterMatcher<T> {
    return ParameterMatcher {
        return equalityFunction(value, $0)
    }
}

/// Returns a matcher matching any Int value.
public func anyInt() -> ParameterMatcher<Int> {
    return ParameterMatcher()
}

/// Returns a matcher matching any String value.
public func anyString() -> ParameterMatcher<String> {
    return ParameterMatcher()
}

/// Returns a matcher matching any closure.
public func anyClosure<IN, OUT>() -> ParameterMatcher<(IN) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any T value or nil.
public func any<T>(_ type: T.Type = T.self) -> ParameterMatcher<T> {
    return ParameterMatcher()
}

/// Returns an equality matcher. A shorthand for `equalTo`.
public func eq<T: Equatable>(_ value: T?) -> ParameterMatcher<T?> {
    return equalTo(value)
}

/// Returns an identity matcher. A shorthand for `equalTo`
public func eq<T: AnyObject>(_ value: T?) -> ParameterMatcher<T?> {
    return equalTo(value)
}

/// Returns a matcher using the supplied function. A shorthand for `equalTo`
public func eq<T>(_ value: T?, equalWhen equalityFunction: @escaping (T?, T?) -> Bool) -> ParameterMatcher<T?> {
    return equalTo(value, equalWhen: equalityFunction)
}

/// Returns an equality matcher.
public func equalTo<T: Equatable>(_ value: T?) -> ParameterMatcher<T?> {
    return equalTo(value, equalWhen: ==)
}

/// Returns an identity matcher.
public func equalTo<T: AnyObject>(_ value: T?) -> ParameterMatcher<T?> {
    return equalTo(value, equalWhen: ===)
}

/// Returns a matcher using the supplied function.
public func equalTo<T>(_ value: T?, equalWhen equalityFunction: @escaping (T?, T?) -> Bool) -> ParameterMatcher<T?> {
    return ParameterMatcher {
        return equalityFunction(value, $0)
    }
}

/// Returns a matcher matching any Int value.
public func anyInt() -> ParameterMatcher<Int?> {
    return notNil()
}

/// Returns a matcher matching any String value.
public func anyString() -> ParameterMatcher<String?> {
    return notNil()
}

/// Returns a matcher matching any closure.
public func anyClosure<IN, OUT>() -> ParameterMatcher<((IN) -> OUT)?> {
    return notNil()
}

/// Returns a matcher matching any non nil value.
public func notNil<T>() -> ParameterMatcher<T?> {
    return ParameterMatcher {
        if case .none = $0 { return false } else { return true }
    }
}
