public protocol StubFunctionThenDoNothingTrait: BaseStubFunctionTrait {   
    /// Does nothing when invoked.
    func thenDoNothing() -> Self
}

public extension StubFunctionThenDoNothingTrait where OutputType == Void {
    @discardableResult
    func thenDoNothing() -> Self {
        stub.appendAction(.returnValue(Void()))
        return self
    }
}
