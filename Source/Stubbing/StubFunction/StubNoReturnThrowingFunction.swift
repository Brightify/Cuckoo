public protocol StubNoReturnThrowingFunction: StubFunctionThenTrait, StubFunctionThenDoNothingTrait, StubFunctionThenThrowTrait, StubFunctionThenThrowingTrait {
}

public struct ProtocolStubNoReturnThrowingFunction<IN, ERROR: Error>: StubNoReturnThrowingFunction {
    public let stub: ConcreteStub<IN, Void, ERROR>

    public init(stub: ConcreteStub<IN, Void, ERROR>) {
        self.stub = stub
    }
}

public struct ClassStubNoReturnThrowingFunction<IN, ERROR: Error>: StubNoReturnThrowingFunction, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, Void, ERROR>

    public init(stub: ClassConcreteStub<IN, Void, ERROR>) {
        self.stub = stub
    }
}
