// MARK: - Closures.
/// Returns a matcher matching any non-throwing closure.
public func anyClosure<OUT>() -> ParameterMatcher<() -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(IN1) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT> { ParameterMatcher() }


// MARK: - Throwing closures.
/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<() throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<(IN1) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) throws -> OUT> { ParameterMatcher() }


// MARK: - Async closures.
/// Returns a matcher matching any async non-throwing closure.
public func anyClosure<OUT>() -> ParameterMatcher<() async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async non-throwing closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(IN1) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async non-throwing closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) async -> OUT> { ParameterMatcher() }


// MARK: - Async throwing closures.
/// Returns a matcher matching any async throwing closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<() async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async throwing closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<(IN1) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async throwing closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<(IN1, IN2) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(IN1, IN2, IN3) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(IN1, IN2, IN3, IN4, IN5, IN6, IN7) async throws -> OUT> { ParameterMatcher() }


// MARK: - Sendable closures.
/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<OUT>() -> ParameterMatcher<@Sendable () -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<@Sendable (IN1) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6) -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT> { ParameterMatcher() }


// MARK: - Sendable throwing closures.
/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<@Sendable () throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<@Sendable (IN1) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6) throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6, IN7) throws -> OUT> { ParameterMatcher() }


// MARK: - Sendable async closures.
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<OUT>() -> ParameterMatcher<@Sendable () async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<@Sendable (IN1) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6) async -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async non-throwing closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6, IN7) async -> OUT> { ParameterMatcher() }


// MARK: - Sendable async throwing closures.
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<@Sendable () async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<@Sendable (IN1) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6) async throws -> OUT> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable async throwing closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<@Sendable (IN1, IN2, IN3, IN4, IN5, IN6, IN7) async throws -> OUT> { ParameterMatcher() }


// MARK: - Optional closures.
/// Returns a matcher matching any optional closure.
public func anyClosure<OUT>() -> ParameterMatcher<(() -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(((IN1)) -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(((IN1, IN2)) -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3)) -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4)) -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5)) -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5, IN6)) -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5, IN6, IN7)) -> OUT)?> { notNil() }


// MARK: - Optional async closures.
/// Returns a matcher matching any optional closure.
public func anyClosure<OUT>() -> ParameterMatcher<(() async -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(((IN1)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(((IN1, IN2)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5, IN6)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5, IN6, IN7)) async -> OUT)?> { notNil() }


// MARK: - Optional async throwing closures.
/// Returns a matcher matching any optional closure.
public func anyThrowingClosure<OUT>() -> ParameterMatcher<(() async throws -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyThrowingClosure<IN1, OUT>() -> ParameterMatcher<(((IN1)) async throws -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyThrowingClosure<IN1, IN2, OUT>() -> ParameterMatcher<(((IN1, IN2)) async throws -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyThrowingClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3)) async throws -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4)) async throws -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5)) async throws -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5, IN6)) async throws -> OUT)?> { notNil() }
/// Returns a matcher matching any optional closure.
public func anyThrowingClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(((IN1, IN2, IN3, IN4, IN5, IN6, IN7)) async throws -> OUT)?> { notNil() }


// MARK: - Optional sendable closures.
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<OUT>() -> ParameterMatcher<(@Sendable () -> OUT)?> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(@Sendable ((IN1)) -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2)) -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3)) -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3, IN4)) -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3, IN4, IN5)) -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3, IN4, IN5, IN6)) -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3, IN4, IN5, IN6, IN7)) -> OUT)?> { notNil() }


// MARK: - Optional sendable async closures.
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<OUT>() -> ParameterMatcher<(@Sendable () async -> OUT)?> { ParameterMatcher() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, OUT>() -> ParameterMatcher<(@Sendable ((IN1)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3, IN4)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3, IN4, IN5)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3, IN4, IN5, IN6)) async -> OUT)?> { notNil() }
/// Returns a matcher matching any @Sendable optional closure.
public func anyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> ParameterMatcher<(@Sendable ((IN1, IN2, IN3, IN4, IN5, IN6, IN7)) async -> OUT)?> { notNil() }
