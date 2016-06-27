//
//  ToBeStubbedFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedFunction<IN, OUT>: BaseToBeStubbedFunction {
    let handler: StubbingHandler
    
    let name: String
    let parameterMatchers: [AnyMatcher<IN>]
    
    public func createStubFunction() -> StubFunction<IN, OUT> {
        return StubFunction(stub: handler.createStub(name, parameterMatchers: parameterMatchers))
    }
}
