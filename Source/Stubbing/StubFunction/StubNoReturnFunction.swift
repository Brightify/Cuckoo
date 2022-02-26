public protocol StubNoReturnFunction: StubFunctionThenTrait, StubFunctionThenDoNothingTrait {
}

public struct ProtocolStubNoReturnFunction<IN>: StubNoReturnFunction {
    public let stub: ConcreteStub<IN, Void>
    
    public init(stub: ConcreteStub<IN, Void>) {
        self.stub = stub
    }
}

public struct ClassStubNoReturnFunction<IN>: StubNoReturnFunction, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, Void>

    public init(stub: ClassConcreteStub<IN, Void>) {
        self.stub = stub
    }
}
