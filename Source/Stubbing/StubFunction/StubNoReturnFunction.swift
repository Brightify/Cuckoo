//
//  StubNoReturnFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StubNoReturnFunction<IN>: StubFunctionThenTrait, StubFunctionThenCallRealImplementationTrait, StubFunctionThenDoNothingTrait {
    public let stub: ConcreteStub<IN, Void>
    
    public init(stub: ConcreteStub<IN, Void>) {
        self.stub = stub
    }
}