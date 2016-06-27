//
//  ToBeStubbedNoReturnFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedNoReturnFunction<IN>: BaseToBeStubbedFunction {
    let handler: StubbingHandler
    
    let name: String
    let parameterMatchers: [AnyMatcher<IN>]
    
    public func createStubFunction() -> StubNoReturnFunction<IN> {
        return StubNoReturnFunction(stub: handler.createStub(name, parameterMatchers: parameterMatchers))
    }
}
