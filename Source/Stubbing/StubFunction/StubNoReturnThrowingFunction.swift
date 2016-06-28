//
//  StubNoReturnThrowingFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StubNoReturnThrowingFunction<IN>: StubFunctionThenTrait, StubFunctionThenCallRealImplementationTrait, StubFunctionThenDoNothingTrait, StubFunctionThenThrowTrait {
    public let stub: ConcreteStub<IN, Void>

    public init(stub: ConcreteStub<IN, Void>) {
        self.stub = stub
    }
}