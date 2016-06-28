//
//  StubFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StubFunction<IN, OUT>: StubFunctionThenTrait, StubFunctionThenReturnTrait, StubFunctionThenCallRealImplementationTrait {
    public let stub: ConcreteStub<IN, OUT>

    public init(stub: ConcreteStub<IN, OUT>) {
        self.stub = stub
    }
}