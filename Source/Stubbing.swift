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
    let parameterMatchers: [AnyMatcher<Any>]
    let output: Any -> ReturnValueOrError
}

public struct StubCall {
    let method: String
    let parameters: Any
}

public struct ToBeStubbedFunction<IN, OUT> {
    let handler: StubbingHandler
    
    let name: String
    let parameterMatchers: [AnyMatcher<IN>]
    
    func setOutput(output: Any -> ReturnValueOrError) {
        handler.createStubReturningValue(name, parameterMatchers: parameterMatchers, output: output)
    }
}

public struct ToBeStubbedThrowingFunction<IN, OUT> {
    let handler: StubbingHandler
    
    let name: String
    let parameterMatchers: [AnyMatcher<IN>]
    
    func setOutput(output: Any -> ReturnValueOrError) {
        handler.createStubReturningValue(name, parameterMatchers: parameterMatchers, output: output)
    }
}

public struct ToBeStubbedReadOnlyProperty<T> {
    let handler: StubbingHandler
    
    let name: String
    
    public var get: ToBeStubbedFunction<Void, T> {
        return ToBeStubbedFunction(handler: handler, name: getterName(name), parameterMatchers: [])
    }
}

public struct ToBeStubbedProperty<T> {
    let handler: StubbingHandler
    
    let name: String
    
    public var get: ToBeStubbedFunction<Void, T> {
        return ToBeStubbedFunction(handler: handler, name: getterName(name), parameterMatchers: [])
    }
    
    public func set<M: Matchable where M.MatchedType == T>(matcher: M) -> ToBeStubbedFunction<T, Void> {
        return ToBeStubbedFunction(handler: handler, name: setterName(name), parameterMatchers: [matcher.matcher])
    }
}

public struct StubbingHandler {
    let createNewStub: Stub -> ()
    
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
    
    private func createStubReturningValue<IN>(method: String, parameterMatchers: [AnyMatcher<IN>], output: Any -> ReturnValueOrError) {
        let stub = Stub(name: method, parameterMatchers: parameterMatchers.map(AnyMatcher.init), output: output)
        
        self.createNewStub(stub)
    }
    
    private func inputEqualWith<IN>(input: IN, equalWhen: (IN, IN) -> Bool)(otherInput: Any) -> Bool {
        guard let castOtherInput = otherInput as? IN else { return false }
        
        return equalWhen(input, castOtherInput)
    }
}

public struct ThenReturnValue<IN, OUT> {
    internal let setOutput: (Any -> ReturnValueOrError) -> Void
    
    /// Invoke `implementation` when invoked.
    public func then(implementation: IN -> OUT) {
        setOutput {
            guard let parameters = $0 as? IN else { fatalError("Implementation called with wrong input type \($0.self). This is probably a bug in Mockery, please file a ticket.") }
            return .ReturnValue(implementation(parameters))
        }
    }
    
    /// Return `output` when invoked.
    public func thenReturn(output: OUT) {
        setOutput { _ in .ReturnValue(output) }
    }
}

public struct ThenReturnValueOrThrow<IN, OUT> {
    internal let setOutput: (Any -> ReturnValueOrError) -> Void
    
    /// Invoke `implementation` when invoked.
    public func then(implementation: IN throws -> OUT) {
        setOutput {
            guard let parameters = $0 as? IN else { fatalError("Implementation called with wrong input type \($0.self). This is probably a bug in Mockery, please file a ticket.") }
            do {
                return try .ReturnValue(implementation(parameters))
            } catch let error {
                return .Error(error)
            }
        }
    }
    
    /// Return `output` when invoked.
    public func thenReturn(output: OUT) {
        setOutput { _ in .ReturnValue(output) }
    }
    
    /// Throw `error` when invoked.
    public func thenThrow(error: ErrorType) {
        setOutput { _ in .Error(error) }
    }
}
