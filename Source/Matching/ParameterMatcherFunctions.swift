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

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<() throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<(IN1) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<@Sendable () throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<@Sendable (IN1) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6, IN7) throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<OUT>() -> ParameterMatcher<() -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(IN1) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<OUT>() -> ParameterMatcher<@Sendable () -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<@Sendable (IN1) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<OUT>() -> ParameterMatcher<() async throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<(IN1) async throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) async throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) async throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) async throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) async throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) async throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) async throws -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<@Sendable () async throws -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<@Sendable (IN1) async throws -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2) async throws -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3) async throws -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4) async throws -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5) async throws -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6) async throws -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6, IN7) async throws -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<OUT>() -> ParameterMatcher<() async -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(IN1) async -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) async -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) async -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) async -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) async -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) async -> OUT> {
    ParameterMatcher()
}

/// Returns a matcher matching any async non-throwing closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) async -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<OUT>() -> ParameterMatcher<@Sendable () async -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<@Sendable (IN1) async -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2) async -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3) async -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4) async -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5) async -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6) async -> OUT> {
    ParameterMatcher()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6, IN7) async -> OUT> {
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

/// Returns a matcher matching any closure.
public func anyClosure<IN, OUT>() -> ParameterMatcher<(((IN)) -> OUT)?> {
    notNil()
}

/// Returns a matcher matching any closure.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func anyClosure<IN, OUT>() -> ParameterMatcher<(((IN)) async -> OUT)?> {
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
