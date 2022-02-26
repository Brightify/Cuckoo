public protocol StubFunctionThenTrait: BaseStubFunctionTrait {
    /// Invokes `implementation` when invoked.
    func then(_ implementation: @escaping (InputType) -> OutputType) -> Self
}

public extension StubFunctionThenTrait {
    @discardableResult
    func then(_ implementation: @escaping (InputType) -> OutputType) -> Self {
        stub.appendAction(.callImplementation(implementation))
        return self
    }
}
