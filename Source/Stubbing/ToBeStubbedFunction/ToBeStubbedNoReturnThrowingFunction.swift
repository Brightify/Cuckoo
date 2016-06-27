//
//  ToBeStubbedNoReturnThrowingFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedNoReturnThrowingFunction<IN>: BaseToBeStubbedFunction {
    let handler: StubbingHandler
    
    let name: String
    let parameterMatchers: [AnyMatcher<IN>]
    
    public func createStubFunction() -> StubNoReturnThrowingFunction<IN> {
        return StubNoReturnThrowingFunction(stub: handler.createStub(name, parameterMatchers: parameterMatchers))
    }
}
