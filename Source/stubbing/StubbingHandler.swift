//
//  StubbingHandler.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StubbingHandler {
    let registerStub: Stub -> ()
    
    public func stubProperty<T>(property: String) -> ToBeStubbedProperty<T> {
        return ToBeStubbedProperty(handler: self, name: property)
    }
    
    public func stubReadOnlyProperty<T>(property: String) -> ToBeStubbedReadOnlyProperty<T> {
        return ToBeStubbedReadOnlyProperty(handler: self, name: property)
    }
    
    public func stub<OUT>(method: String) -> ToBeStubbedFunction<Void, OUT> {
        return stub(method, parameterMatchers: [] as [AnyMatcher<Void>])
    }
    
    public func stub<IN, OUT>(method: String, parameterMatchers: [AnyMatcher<IN>]) -> ToBeStubbedFunction<IN, OUT> {
        return ToBeStubbedFunction(handler: self, name: method, parameterMatchers: parameterMatchers)
    }
    
    public func stubThrowing<OUT>(method: String) -> ToBeStubbedThrowingFunction<Void, OUT> {
        return stubThrowing(method, parameterMatchers: [] as [AnyMatcher<Void>])
    }
    
    public func stubThrowing<IN, OUT>(method: String, parameterMatchers: [AnyMatcher<IN>]) -> ToBeStubbedThrowingFunction<IN, OUT> {
        return ToBeStubbedThrowingFunction(handler: self, name: method, parameterMatchers: parameterMatchers)
    }
    
    func createStub<IN, OUT>(method: String, parameterMatchers: [AnyMatcher<IN>]) -> ConcreteStub<IN, OUT> {
        let stub = ConcreteStub<IN, OUT>(name: method, parameterMatchers: parameterMatchers)
        registerStub(stub)
        return stub
    }
}