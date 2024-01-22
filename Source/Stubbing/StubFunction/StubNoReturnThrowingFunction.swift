public protocol StubNoReturnThrowingFunction: StubFunctionThenTrait, StubFunctionThenDoNothingTrait, StubFunctionThenThrowTrait, StubFunctionThenThrowingTrait {
}

public struct ProtocolStubNoReturnThrowingFunction<IN>: StubNoReturnThrowingFunction {
    public let stub: ConcreteStub<IN, Void>

    public init(stub: ConcreteStub<IN, Void>) {
        self.stub = stub
    }
}

public struct ClassStubNoReturnThrowingFunction<IN>: StubNoReturnThrowingFunction, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, Void>

    public init(stub: ClassConcreteStub<IN, Void>) {
        self.stub = stub
    }
}
