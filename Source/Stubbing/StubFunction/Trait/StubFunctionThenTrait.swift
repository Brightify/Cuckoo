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

    /// Invokes `implementation` when invoked, allowing it to mutate the mocked method's `inout` parameter.
    @discardableResult
    func then<Value>(_ implementation: @escaping (inout Value) -> OutputType) -> Self where InputType == InoutContainer<Value> {
        stub.appendAction(.callImplementation({ container in implementation(&container.value) }))
        return self
    }
}
