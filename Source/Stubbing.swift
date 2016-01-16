//
//  Stubbing.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubbingProxy {
    init(handler: StubbingHandler)
}

public struct Stub {
    let name: String
    let inputMatcher: AnyMatcher<Any>
    let output: Any -> ReturnValueOrError
}

public struct StubCall {
    let method: String
    let parameters: Any
}

public struct ToBeStubbedFunction<IN, OUT> {
    let handler: StubbingHandler
    
    let name: String
    let matcher: AnyMatcher<IN>
    
    func setOutput(output: Any -> ReturnValueOrError) {
        handler.createStubReturningValue(name, inputMatcher: matcher, output: output)
    }
}

public struct ToBeStubbedFunctionNeedingMatcher<IN, OUT> {
    let handler: StubbingHandler
    
    let name: String
    let parameters: IN
    
    func setInputMatcher(matcher: AnyMatcher<IN>, andOutput output: Any -> ReturnValueOrError) {
        handler.createStubReturningValue(name, inputMatcher: matcher, output: output)
    }
}

public struct ToBeStubbedThrowingFunction<IN, OUT> {
    let handler: StubbingHandler
    
    let name: String
    let matcher: AnyMatcher<IN>
    
    func setOutput(output: Any -> ReturnValueOrError) {
        handler.createStubReturningValue(name, inputMatcher: matcher, output: output)
    }
}

public struct ToBeStubbedThrowingFunctionNeedingMatcher<IN, OUT> {
    let handler: StubbingHandler
    
    let name: String
    let parameters: IN
    
    func setInputMatcher(matcher: AnyMatcher<IN>, andOutput output: Any -> ReturnValueOrError) {
        handler.createStubReturningValue(name, inputMatcher: matcher, output: output)
    }
}



public struct StubbingHandler {
    let createNewStub: Stub -> ()
    
    public func stub<IN, OUT>(method: String, matcher: AnyMatcher<IN>) -> ToBeStubbedFunction<IN, OUT> {
        return ToBeStubbedFunction(handler: self, name: method, matcher: matcher)
    }
    
    public func stub<IN, OUT>(method: String, parameters: IN) -> ToBeStubbedFunctionNeedingMatcher<IN, OUT> {
        return ToBeStubbedFunctionNeedingMatcher(handler: self, name: method, parameters: parameters)
    }
    
    public func stubThrowing<IN, OUT>(method: String, matcher: AnyMatcher<IN>) -> ToBeStubbedThrowingFunction<IN, OUT> {
        return ToBeStubbedThrowingFunction(handler: self, name: method, matcher: matcher)
    }
    
    public func stubThrowing<IN, OUT>(method: String, parameters: IN) -> ToBeStubbedThrowingFunctionNeedingMatcher<IN, OUT> {
        return ToBeStubbedThrowingFunctionNeedingMatcher(handler: self, name: method, parameters: parameters)
    }
    
    private func createStubReturningValue<IN>(method: String, inputMatcher: AnyMatcher<IN>, output: Any -> ReturnValueOrError) {
        let stub = Stub(name: method, inputMatcher: AnyMatcher(inputMatcher), output: output)
        
        self.createNewStub(stub)
    }
    
    private func inputEqualWith<IN>(input: IN, equalWhen: (IN, IN) -> Bool)(otherInput: Any) -> Bool {
        guard let castOtherInput = otherInput as? IN else { return false }
        
        return equalWhen(input, castOtherInput)
    }
}

public struct ThenReturnValue<IN, OUT> {
    internal let setOutput: (Any -> ReturnValueOrError) -> Void
    
    public func then(implementation: IN -> OUT) {
        setOutput {
            guard let parameters = $0 as? IN else { fatalError("Implementation called with wrong input type \($0.self). This is probably a bug in Mockery, please file a ticker.") }
            return .ReturnValue(implementation(parameters))
        }
    }
    
    public func thenReturn(output: OUT) {
        setOutput { _ in .ReturnValue(output) }
    }
}

public struct ThenReturnValueOrThrow<IN, OUT> {
    internal let setOutput: (Any -> ReturnValueOrError) -> Void
    
    public func then(implementation: IN throws -> OUT) {
        setOutput {
            guard let parameters = $0 as? IN else { fatalError("") }
            do {
                return try .ReturnValue(implementation(parameters))
            } catch let error {
                return .Error(error)
            }
        }
    }
    
    public func thenReturn(output: OUT) {
        setOutput { _ in .ReturnValue(output) }
    }
    
    public func thenThrow(error: ErrorType) {
        setOutput { _ in .Error(error) }
    }
}
