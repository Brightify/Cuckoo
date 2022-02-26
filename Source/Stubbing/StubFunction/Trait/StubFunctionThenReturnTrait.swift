public protocol StubFunctionThenReturnTrait: BaseStubFunctionTrait {
    /// Returns `output` when invoked.
    func thenReturn(_ output: OutputType, _ outputs: OutputType...) -> Self
}

public extension StubFunctionThenReturnTrait {
    @discardableResult
    func thenReturn(_ output: OutputType, _ outputs: OutputType...) -> Self {
        ([output] + outputs).forEach { output in
            stub.appendAction(.returnValue(output))
        }
        return self
    }
}
