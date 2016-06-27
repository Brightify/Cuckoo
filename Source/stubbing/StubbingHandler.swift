//
//  StubbingHandler.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StubbingHandler {
    let registerStub: Stub -> ()
    
    public func createStub<IN, OUT>(method: String, parameterMatchers: [AnyMatcher<IN>]) -> ConcreteStub<IN, OUT> {
        let stub = ConcreteStub<IN, OUT>(name: method, parameterMatchers: parameterMatchers)
        registerStub(stub)
        return stub
    }
}