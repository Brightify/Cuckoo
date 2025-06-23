public protocol StubThrowingFunction: StubFunctionThenTrait, StubFunctionThenReturnTrait, StubFunctionThenThrowTrait, StubFunctionThenThrowingTrait {
}

public struct ProtocolStubThrowingFunction<IN, OUT, ERROR: Error>: StubThrowingFunction {
    public let stub: ConcreteStub<IN, OUT, ERROR>

    public init(stub: ConcreteStub<IN, OUT, ERROR>) {
        self.stub = stub
    }
}

public struct ClassStubThrowingFunction<IN, OUT, ERROR: Error>: StubThrowingFunction, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, OUT, ERROR>

    public init(stub: ClassConcreteStub<IN, OUT, ERROR>) {
        self.stub = stub
    }
}
