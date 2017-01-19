//
//  MockManager.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest

public class MockManager {
    static var fail: (_ message: String, _ sourceLocation: SourceLocation) -> () = { XCTFail($0, file: $1.file, line: $1.line) }
    
    private var stubs: [Stub] = []
    private var stubCalls: [StubCall] = []
    private var unverifiedStubCallsIndexes: [Int] = []
    
    public init() {
        
    }

    fileprivate func callInternal<IN, OUT>(_ method: String, parameters: IN, original: ((IN) -> OUT)? = nil) -> OUT {
        return try! callThrowsInternal(method, parameters: parameters, original: original)
    }
    
    fileprivate func callThrowsInternal<IN, OUT>(_ method: String, parameters: IN, original: ((IN) throws -> OUT)? = nil) throws -> OUT {
        let stubCall = ConcreteStubCall(method: method, parameters: parameters)
        stubCalls.append(stubCall)
        unverifiedStubCallsIndexes.append(stubCalls.count - 1)
        
        if let stub = (stubs.filter { $0.method == method }.flatMap { $0 as? ConcreteStub<IN, OUT> }.filter { $0.parameterMatchers.reduce(true) { $0 && $1.matches(parameters) } }.first) {
            if let action = stub.actions.first {
                if stub.actions.count > 1 {
                    // Bug in Swift, this expression resolves as uncalled function
                    _ = stub.actions.removeFirst()
                }
                switch action {
                case .callImplementation(let implementation):
                    return try implementation(parameters)
                case .returnValue(let value):
                    return value
                case .throwError(let error):
                    throw error
                case .callRealImplementation:
                    if let original = original {
                        return try original(parameters)
                    } else {
                        failAndCrash("No real implementation found for method `\(method)`. This may happend because stubbed object is mock or spy of protocol.")
                    }
                }
            } else {
                failAndCrash("Stubbing of method `\(method)` using parameters \(parameters) wasn't finished (missing thenReturn()).")
            }
        } else if let original = original {
            return try original(parameters)
        } else {
            failAndCrash("No stub for method `\(method)` using parameters \(parameters) and no original implementation was provided.")
        }
    }
    
    public func createStub<IN, OUT>(_ method: String, parameterMatchers: [ParameterMatcher<IN>]) -> ConcreteStub<IN, OUT> {
        let stub = ConcreteStub<IN, OUT>(method: method, parameterMatchers: parameterMatchers)
        stubs.insert(stub, at: 0)
        return stub
    }
    
    public func verify<IN, OUT>(_ method: String, callMatcher: CallMatcher, parameterMatchers: [ParameterMatcher<IN>], sourceLocation: SourceLocation) -> __DoNotUse<OUT> {
        var calls: [StubCall] = []
        var indexesToRemove: [Int] = []
        for (i, stubCall) in stubCalls.enumerated() {
            if let stubCall = stubCall as? ConcreteStubCall<IN> , (parameterMatchers.reduce(stubCall.method == method) { $0 && $1.matches(stubCall.parameters) }) {
                calls.append(stubCall)
                indexesToRemove.append(i)
            }
        }
        unverifiedStubCallsIndexes = unverifiedStubCallsIndexes.filter { !indexesToRemove.contains($0) }
        
        if callMatcher.matches(calls) == false {
            let message = "Wanted \(callMatcher.name) but \(calls.count == 0 ? "not invoked" : "invoked \(calls.count) times")."
            MockManager.fail(message, sourceLocation)
        }
        return __DoNotUse()
    }
    
    func reset() {
        clearStubs()
        clearInvocations()
    }
    
    func clearStubs() {
        stubs.removeAll()
    }
    
    func clearInvocations() {
        stubCalls.removeAll()
        unverifiedStubCallsIndexes.removeAll()
    }
    
    func verifyNoMoreInteractions(_ sourceLocation: SourceLocation) {
        if unverifiedStubCallsIndexes.isEmpty == false {
            let unverifiedCalls = unverifiedStubCallsIndexes.map { stubCalls[$0] }.map { call in
                    if let bracketIndex = call.method.range(of: "(")?.lowerBound {
                        let name = call.method.substring(to: bracketIndex)
                        return name + call.parametersAsString
                    } else {
                        if call.method.hasSuffix("#set") {
                            return call.method + call.parametersAsString
                        } else {
                            return call.method
                        }
                    }
                }.enumerated().map { "\($0 + 1). " + $1 }.joined(separator: "\n")
            let message = "No more interactions wanted but some found:\n"
            MockManager.fail(message + unverifiedCalls, sourceLocation)
        }
    }
    
    
    private func failAndCrash(_ message: String, file: StaticString = #file, line: UInt = #line) -> Never  {
        MockManager.fail(message, (file, line))

        #if _runtime(_ObjC)
            NSException(name: .internalInconsistencyException, reason:message, userInfo: nil).raise()
        #endif

        fatalError(message)
    }
}

extension MockManager {
    public func getter<T>(_ property: String, original: ((Void) -> T)? = nil) -> T {
        return call(getterName(property), parameters: Void(), original: original)
    }

    public func setter<T>(_ property: String, value: T, original: ((T) -> Void)? = nil) {
        return call(setterName(property), parameters: value, original: original)
    }

}

// DSL helpers workarounding Swift 3's removal of parameter splat
extension MockManager {
    public func call<IN, OUT>(_ method: String, parameters: IN, original: ((IN) -> OUT)? = nil) -> OUT {
        return callInternal(method, parameters: parameters, original: original)
    }

    public func call<IN1, IN2, OUT>(_ method: String, parameters: (IN1, IN2), original: ((IN1, IN2) -> OUT)? = nil) -> OUT {
        return callInternal(method, parameters: parameters, original: original)
    }

    public func call<IN1, IN2, IN3, OUT>(_ method: String, parameters: (IN1, IN2, IN3), original: ((IN1, IN2, IN3) -> OUT)? = nil) -> OUT {
        return callInternal(method, parameters: parameters, original: original)
    }

    public func call<IN1, IN2, IN3, IN4, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4), original: ((IN1, IN2, IN3, IN4) -> OUT)? = nil) -> OUT {
        return callInternal(method, parameters: parameters, original: original)
    }

    public func call<IN1, IN2, IN3, IN4, IN5, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5), original: ((IN1, IN2, IN3, IN4, IN5) -> OUT)? = nil) -> OUT {
        return callInternal(method, parameters: parameters, original: original)
    }

    public func call<IN1, IN2, IN3, IN4, IN5, IN6, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6), original: ((IN1, IN2, IN3, IN4, IN5, IN6) -> OUT)? = nil) -> OUT {
        return callInternal(method, parameters: parameters, original: original)
    }

    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7), original: ((IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT)? = nil) -> OUT {
        return callInternal(method, parameters: parameters, original: original)
    }

    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8), original: ((IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8) -> OUT)? = nil) -> OUT {
        return callInternal(method, parameters: parameters, original: original)
    }
}

extension MockManager {
    public func callThrows<IN, OUT>(_ method: String, parameters: IN, original: ((IN) throws -> OUT)? = nil) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, original: original)
    }

    public func callThrows<IN1, IN2, OUT>(_ method: String, parameters: (IN1, IN2), original: ((IN1, IN2) throws -> OUT)? = nil) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, original: original)
    }

    public func callThrows<IN1, IN2, IN3, OUT>(_ method: String, parameters: (IN1, IN2, IN3), original: ((IN1, IN2, IN3) throws -> OUT)? = nil) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, original: original)
    }

    public func callThrows<IN1, IN2, IN3, IN4, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4), original: ((IN1, IN2, IN3, IN4) throws -> OUT)? = nil) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, original: original)
    }

    public func callThrows<IN1, IN2, IN3, IN4, IN5, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5), original: ((IN1, IN2, IN3, IN4, IN5) throws -> OUT)? = nil) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, original: original)
    }

    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6), original: ((IN1, IN2, IN3, IN4, IN5, IN6) throws -> OUT)? = nil) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, original: original)
    }

    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7), original: ((IN1, IN2, IN3, IN4, IN5, IN6, IN7) throws -> OUT)? = nil) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, original: original)
    }

    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8), original: ((IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8) throws -> OUT)? = nil) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, original: original)
    }
}


















