//
//  StubFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunction: StubFunctionThenTrait, StubFunctionThenReturnTrait {
}

public struct ProtocolStubFunction<IN, OUT>: StubFunction {
    public let stub: ConcreteStub<IN, OUT>

    public init(stub: ConcreteStub<IN, OUT>) {
        self.stub = stub
    }
}

public struct ClassStubFunction<IN, OUT>: StubFunction, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, OUT>

    public init(stub: ClassConcreteStub<IN, OUT>) {
        self.stub = stub
    }
}

