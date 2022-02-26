public protocol StubFunctionThenThrowTrait: BaseStubFunctionTrait {
    /// Throws `error` when invoked.
    func thenThrow(_ error: Error, _ errors: Error...) -> Self
}

public extension StubFunctionThenThrowTrait {
    @discardableResult
    func thenThrow(_ error: Error, _ errors: Error...) -> Self {
        ([error] + errors).forEach { error in
            stub.appendAction(.throwError(error))
        }
        return self
    }
}
