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

/// Returns an equality matcher for Dictionary<Hashable, Equatable>
public func equal<K: Hashable, V: Equatable>(to dictionary: [K: V]) -> ParameterMatcher<[K: V]> {
    return equal(to: dictionary, equalWhen: ==)
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

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<() throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<(IN1) throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<OUT>() -> ParameterMatcher<() -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(IN1) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<OUT>() -> ParameterMatcher<() async throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<(IN1) async throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) async throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) async throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) async throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) async throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) async throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) async throws -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<OUT>() -> ParameterMatcher<() async -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(IN1) async -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) async -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) async -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) async -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) async -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) async -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) async -> OUT> {
    return ParameterMatcher()
}

/// Returns a matcher matching any T value or nil.
public func any<T>(_ type: T.Type = T.self) -> ParameterMatcher<T> {
    return ParameterMatcher()
}

/// Returns a matcher matching any T value or nil.
public func any<T>(_ type: T.Type = T.self) -> ParameterMatcher<T?> {
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

/// Returns a matcher matching any closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN, OUT>() -> ParameterMatcher<(((IN)) async -> OUT)?> {
    return notNil()
}

public func anyOptionalThrowingClosure<IN, OUT>() -> ParameterMatcher<(((IN)) throws -> OUT)?> {
    return notNil()
}

/// Returns a matcher matching any non-nil value.
public func notNil<T>() -> ParameterMatcher<T?> {
    return ParameterMatcher {
        if case .none = $0 {
            return false
        } else {
            return true
        }
    }
}

/// Returns a matcher matching any nil value.
public func isNil<T>() -> ParameterMatcher<T?> {
    return ParameterMatcher {
        if case .none = $0 {
            return true
        } else {
            return false
        }
    }
}

/// Returns a matcher negating any matcher it's applied to.
public func not<T>(_ matcher: ParameterMatcher<T>) -> ParameterMatcher<T> {
    return ParameterMatcher { value in
        !matcher.matches(value)
    }
}
