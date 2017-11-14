//
//  StubNoReturnThrowingFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubNoReturnThrowingFunction: StubFunctionThenTrait, StubFunctionThenDoNothingTrait, StubFunctionThenThrowTrait {
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
