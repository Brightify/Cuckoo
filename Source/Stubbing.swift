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

public class Stub {
    let name: String
    let inputMatcher: AnyMatcher<Any>
    let output: () -> ReturnValueOrError
    
    var calledTimes: Int = 0
    
    init(name: String, inputMatcher: AnyMatcher<Any>, output: () -> ReturnValueOrError) {
        self.name = name
        self.inputMatcher = inputMatcher
        self.output = output
    }
    
    func call() -> ReturnValueOrError {
        calledTimes += 1
        
        return output()
    }
}

public struct ToBeStubbedFunction<IN, OUT> {
    let handler: StubbingHandler
    
    let name: String
    let parameters: IN
    
    func setInputMatcher(matcher: AnyMatcher<IN>, @autoclosure(escaping) andOutput output: Void -> ReturnValueOrError) {
        handler.createStubReturningValue(name, inputMatcher: matcher, output: output)
    }
}

public struct ToBeStubbedThrowingFunction<IN, OUT> {
    let handler: StubbingHandler
    
    let name: String
    let parameters: IN
    
    func setInputMatcher(matcher: AnyMatcher<IN>, @autoclosure(escaping) andOutput output: Void -> ReturnValueOrError) {
        handler.createStubReturningValue(name, inputMatcher: matcher, output: output)
    }
}

public struct StubbingHandler {
    let createNewStub: Stub -> ()
    
    public func stub<IN, OUT>(method: String, parameters: IN) -> ToBeStubbedFunction<IN, OUT> {
        return ToBeStubbedFunction(handler: self, name: method, parameters: parameters)
    }
    
    public func stubThrowing<IN, OUT>(method: String, parameters: IN) -> ToBeStubbedThrowingFunction<IN, OUT> {
        return ToBeStubbedThrowingFunction(handler: self, name: method, parameters: parameters)
    }
    
    private func createStubReturningValue<IN>(method: String, inputMatcher: AnyMatcher<IN>, output: Void -> ReturnValueOrError) {
        let stub = Stub(name: method, inputMatcher: AnyMatcher(inputMatcher), output: output)
        
        self.createNewStub(stub)
    }
    
    private func inputEqualWith<IN>(input: IN, equalWhen: (IN, IN) -> Bool)(otherInput: Any) -> Bool {
        guard let castOtherInput = otherInput as? IN else { return false }
        
        return equalWhen(input, castOtherInput)
    }
}

public struct ThenReturnValue<IN, OUT> {
    public let thenReturn: OUT -> ()
}

public struct ThenReturnValueOrThrow<IN, OUT> {
    public let thenReturn: OUT -> ()
    
    public let thenThrow: ErrorType -> ()
}
