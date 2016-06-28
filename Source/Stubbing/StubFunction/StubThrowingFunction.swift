//
//  StubThrowingFunction.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StubThrowingFunction<IN, OUT>: StubFunctionThenTrait, StubFunctionThenReturnTrait, StubFunctionThenCallRealImplementationTrait, StubFunctionThenThrowTrait {
    public let stub: ConcreteStub<IN, OUT>

    public init(stub: ConcreteStub<IN, OUT>) {
        self.stub = stub
    }
}