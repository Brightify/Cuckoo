public protocol StubFunctionThenCallRealImplementationTrait: BaseStubFunctionTrait {
    /// Invokes real implementation when invoked.
    func thenCallRealImplementation() -> Self
}

public extension StubFunctionThenCallRealImplementationTrait {
    @discardableResult
    func thenCallRealImplementation() -> Self {
        stub.appendAction(.callRealImplementation)
        return self
    }
}
