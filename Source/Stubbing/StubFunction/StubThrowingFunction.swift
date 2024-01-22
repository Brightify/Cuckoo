public protocol StubThrowingFunction: StubFunctionThenTrait, StubFunctionThenReturnTrait, StubFunctionThenThrowTrait, StubFunctionThenThrowingTrait {
}

public struct ProtocolStubThrowingFunction<IN, OUT>: StubThrowingFunction {
    public let stub: ConcreteStub<IN, OUT>

    public init(stub: ConcreteStub<IN, OUT>) {
        self.stub = stub
    }
}

public struct ClassStubThrowingFunction<IN, OUT>: StubThrowingFunction, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, OUT>

    public init(stub: ClassConcreteStub<IN, OUT>) {
        self.stub = stub
    }
}
