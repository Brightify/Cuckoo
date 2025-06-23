public protocol StubFunctionThenThrowingTrait: BaseStubFunctionTrait {
    /// Invokes throwing `implementation` when invoked.
    func then(_ implementation: @escaping (InputType) throws(ErrorType) -> OutputType) -> Self
}

public extension StubFunctionThenThrowingTrait {
    @discardableResult
    func then(_ implementation: @escaping (InputType) throws(ErrorType) -> OutputType) -> Self {
        stub.appendAction(.callImplementation(implementation))
        return self
    }
}
