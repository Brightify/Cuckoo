//
//  ParameterMatcherFunctions.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Returns an equality matcher.
public func equal<T: Equatable>(to value: T) -> ParameterMatcher<T> {
    return equal(to: value, equalWhen: ==)
}

/// Returns an identity matcher.
@available(*, renamed: "sameInstance(as:)")
public func equal<T: AnyObject>(to value: T) -> ParameterMatcher<T> {
    return equal(to: value, equalWhen: ===)
}

/// Returns an equality matcher for Array<Equatable> (ordered)
public func equal<T: Equatable>(to array: [T]) -> ParameterMatcher<[T]> {
    return equal(to: array, equalWhen: ==)
}

/// Returns an equality matcher for Set<Equatable>
public func equal<T>(to set: Set<T>) -> ParameterMatcher<Set<T>> {
    return equal(to: set, equalWhen: ==)
}

/// Returns a matcher using the supplied function.
public func equal<T>(to value: T, equalWhen equalityFunction: @escaping (T, T) -> Bool) -> ParameterMatcher<T> {
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
public func anyThrowingClosure<IN, OUT>() -> ParameterMatcher<(IN) throws -> OUT> {
    return ParameterMatcher()
}

public func anyClosure<IN, OUT>() -> ParameterMatcher<(IN) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any T value or nil.
public func any<T>(_ type: T.Type = T.self) -> ParameterMatcher<T> {
    return ParameterMatcher()
}

/// Returns an equality matcher.
public func equal<T: Equatable>(to value: T?) -> ParameterMatcher<T?> {
    return equal(to: value, equalWhen: ==)
}

/// Returns an identity matcher.
@available(*, renamed: "sameInstance(as:)")
public func equal<T: AnyObject>(to value: T?) -> ParameterMatcher<T?> {
    return equal(to: value, equalWhen: ===)
}

/// Returns an identity matcher.
public func sameInstance<T: AnyObject>(as object: T?) -> ParameterMatcher<T?> {
    return equal(to: object, equalWhen: ===)
}

/// Returns an identity matcher.
public func sameInstance<T: AnyObject>(as object: T) -> ParameterMatcher<T> {
    return equal(to: object, equalWhen: ===)
}

/// Returns a matcher using the supplied function.
public func equal<T>(to value: T?, equalWhen equalityFunction: @escaping (T?, T?) -> Bool) -> ParameterMatcher<T?> {
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
public func anyClosure<IN, OUT>() -> ParameterMatcher<(((IN)) -> OUT)?> {
    return notNil()
}

public func anyOptionalThrowingClosure<IN, OUT>() -> ParameterMatcher<(((IN)) throws -> OUT)?> {
    return notNil()
}

/// Returns a matcher matching any non nil value.
public func notNil<T>() -> ParameterMatcher<T?> {
    return ParameterMatcher {
        if case .none = $0 {
            return false
        } else {
            return true
        }
    }
}

/// Returns a matcher matching any nil value
public func isNil<T>() -> ParameterMatcher<T?> {
    return ParameterMatcher {
        if case .none = $0 {
            return true
        } else {
            return false
        }
    }
}
