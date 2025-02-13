/// Returns an equality matcher.
public func equal<T: Equatable>(to value: T) -> ParameterMatcher<T> {
    equal(to: value, equalWhen: ==)
}

/// Returns an identity matcher.
@available(*, renamed: "sameInstance(as:)")
public func equal<T: AnyObject>(to value: T) -> ParameterMatcher<T> {
    equal(to: value, equalWhen: ===)
}

/// Returns an equality matcher for Array<Equatable> (ordered)
public func equal<T: Equatable>(to array: [T]) -> ParameterMatcher<[T]> {
    equal(to: array, equalWhen: ==)
}

/// Returns an equality matcher for Set<Equatable>
public func equal<T>(to set: Set<T>) -> ParameterMatcher<Set<T>> {
    equal(to: set, equalWhen: ==)
}

/// Returns an equality matcher for Dictionary<Hashable, Equatable>
public func equal<K: Hashable, V: Equatable>(to dictionary: [K: V]) -> ParameterMatcher<[K: V]> {
    equal(to: dictionary, equalWhen: ==)
}

/// Returns a matcher using the supplied function.
public func equal<T>(
    to value: T,
    equalWhen equalityFunction: @escaping (T, T) -> Bool
) -> ParameterMatcher<T> {
    ParameterMatcher {
        equalityFunction(value, $0)
    }
}

/// Returns a matcher matching any Int value.
public func anyInt() -> ParameterMatcher<Int> {
    ParameterMatcher()
}

/// Returns a matcher matching any String value.
public func anyString() -> ParameterMatcher<String> {
    ParameterMatcher()
}

/// Returns a matcher matching any T value or nil.
public func any<T>(_ type: T.Type = T.self) -> ParameterMatcher<T> {
    ParameterMatcher()
}

/// Returns a matcher matching any T value or nil.
public func any<T>(_ type: T.Type = T.self) -> ParameterMatcher<T?> {
    ParameterMatcher()
}

/// Returns an equality matcher.
public func equal<T: Equatable>(to value: T?) -> ParameterMatcher<T?> {
    equal(to: value, equalWhen: ==)
}

/// Returns an identity matcher.
@available(*, renamed: "sameInstance(as:)")
public func equal<T: AnyObject>(to value: T?) -> ParameterMatcher<T?> {
    equal(to: value, equalWhen: ===)
}

/// Returns an identity matcher.
public func sameInstance<T: AnyObject>(as object: T?) -> ParameterMatcher<T?> {
    equal(to: object, equalWhen: ===)
}

/// Returns an identity matcher.
public func sameInstance<T: AnyObject>(as object: T) -> ParameterMatcher<T> {
    equal(to: object, equalWhen: ===)
}

/// Returns a matcher using the supplied function.
public func equal<T>(to value: T?, equalWhen equalityFunction: @escaping (T?, T?) -> Bool) -> ParameterMatcher<T?> {
    ParameterMatcher {
        equalityFunction(value, $0)
    }
}

/// Returns a matcher matching any Int value.
public func anyInt() -> ParameterMatcher<Int?> {
    notNil()
}

/// Returns a matcher matching any String value.
public func anyString() -> ParameterMatcher<String?> {
    notNil()
}

public func anyOptionalThrowingClosure<IN, OUT>() -> ParameterMatcher<(((IN)) throws -> OUT)?> {
    notNil()
}

/// Returns a matcher matching any non-nil value.
public func notNil<T>() -> ParameterMatcher<T?> {
    ParameterMatcher {
        $0 != nil
    }
}

/// Returns a matcher matching any nil value.
public func isNil<T>() -> ParameterMatcher<T?> {
    ParameterMatcher {
        $0 == nil
    }
}

/// Returns a matcher negating any matcher it's applied to.
public func not<T>(_ matcher: ParameterMatcher<T>) -> ParameterMatcher<T> {
    ParameterMatcher { value in
        !matcher.matches(value)
    }
}
