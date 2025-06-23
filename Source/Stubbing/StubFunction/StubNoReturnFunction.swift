public protocol StubNoReturnFunction: StubFunctionThenTrait, StubFunctionThenDoNothingTrait {
}

public struct ProtocolStubNoReturnFunction<IN>: StubNoReturnFunction {
    public let stub: ConcreteStub<IN, Void, Never>
    
    public init(stub: ConcreteStub<IN, Void, Never>) {
        self.stub = stub
    }
}

public struct ClassStubNoReturnFunction<IN>: StubNoReturnFunction, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, Void, Never>

    public init(stub: ClassConcreteStub<IN, Void, Never>) {
        self.stub = stub
    }
}
