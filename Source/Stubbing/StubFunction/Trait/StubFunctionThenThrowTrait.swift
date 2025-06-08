public protocol StubFunctionThenThrowTrait: BaseStubFunctionTrait {
    /// Throws `error` when invoked.
    func thenThrow(_ error: ErrorType, _ errors: ErrorType...) -> Self
}

public extension StubFunctionThenThrowTrait {
    @discardableResult
    func thenThrow(_ error: ErrorType, _ errors: ErrorType...) -> Self {
        ([error] + errors).forEach { error in
            stub.appendAction(.throwError(error))
        }
        return self
    }
}
