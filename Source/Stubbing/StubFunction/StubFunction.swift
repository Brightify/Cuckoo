public protocol StubFunction: StubFunctionThenTrait, StubFunctionThenReturnTrait {
}

public struct ProtocolStubFunction<IN, OUT>: StubFunction {
    public let stub: ConcreteStub<IN, OUT, Never>

    public init(stub: ConcreteStub<IN, OUT, Never>) {
        self.stub = stub
    }
}

public struct ClassStubFunction<IN, OUT>: StubFunction, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, OUT, Never>

    public init(stub: ClassConcreteStub<IN, OUT, Never>) {
        self.stub = stub
    }
}

