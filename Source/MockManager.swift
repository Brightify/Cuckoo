//
//  MockManager.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest

public class MockManager {
    static var fail: (message: String, sourceLocation: SourceLocation) -> () = { XCTFail($0, file: $1.file, line: $1.line) }
    
    private var stubs: [Stub] = []
    private var stubCalls: [StubCall] = []
    private var unverifiedStubCallsIndexes: [Int] = []
    
    public init() {
        
    }

    public func getter<T>(property: String, original: (Void -> T)? = nil) -> T {
        return call(getterName(property), parameters: Void(), original: original)
    }
    
    public func setter<T>(property: String, value: T, original: (T -> Void)? = nil) {
        return call(setterName(property), parameters: value, original: original)
    }
    
    public func call<IN, OUT>(method: String, parameters: IN, original: (IN -> OUT)? = nil) -> OUT {
        return try! callThrows(method, parameters: parameters, original: original)
    }
    
    public func callThrows<IN, OUT>(method: String, parameters: IN, original: (IN throws -> OUT)? = nil) throws -> OUT {
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
                case .CallImplementation(let implementation):
                    return try implementation(parameters)
                case .ReturnValue(let value):
                    return value
                case .ThrowError(let error):
                    throw error
                case .CallRealImplementation:
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
    
    public func createStub<IN, OUT>(method: String, parameterMatchers: [ParameterMatcher<IN>]) -> ConcreteStub<IN, OUT> {
        let stub = ConcreteStub<IN, OUT>(method: method, parameterMatchers: parameterMatchers)
        stubs.insert(stub, atIndex: 0)
        return stub
    }
    
    public func verify<IN, OUT>(method: String, callMatcher: CallMatcher, parameterMatchers: [ParameterMatcher<IN>], sourceLocation: SourceLocation) -> __DoNotUse<OUT> {
        var calls: [StubCall] = []
        var indexesToRemove: [Int] = []
        for (i, stubCall) in stubCalls.enumerate() {
            if let stubCall = stubCall as? ConcreteStubCall<IN> where (parameterMatchers.reduce(stubCall.method == method) { $0 && $1.matches(stubCall.parameters) }) {
                calls.append(stubCall)
                indexesToRemove.append(i)
            }
        }
        unverifiedStubCallsIndexes = unverifiedStubCallsIndexes.filter { !indexesToRemove.contains($0) }
        
        if callMatcher.matches(calls) == false {
            let message = "Wanted \(callMatcher.name) but \(calls.count == 0 ? "not invoked" : "invoked \(calls.count) times")."
            MockManager.fail(message: message, sourceLocation: sourceLocation)
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
    
    func verifyNoMoreInteractions(sourceLocation: SourceLocation) {
        if unverifiedStubCallsIndexes.isEmpty == false {
            let unverifiedCalls = unverifiedStubCallsIndexes.map { stubCalls[$0] }.map { call in
                    if let bracketIndex = call.method.rangeOfString("(")?.startIndex {
                        let name = call.method.substringToIndex(bracketIndex)
                        return name + call.parametersAsString
                    } else {
                        if call.method.hasSuffix("#set") {
                            return call.method + call.parametersAsString
                        } else {
                            return call.method
                        }
                    }
                }.enumerate().map { "\($0 + 1). " + $1 }.joinWithSeparator("\n")
            let message = "No more interactions wanted but some found:\n"
            MockManager.fail(message: message + unverifiedCalls, sourceLocation: sourceLocation)
        }
    }
    
    @noreturn
    private func failAndCrash(message: String, file: StaticString = #file, line: UInt = #line) {
        MockManager.fail(message: message, sourceLocation: (file, line))
        fatalError(message)
    }
}
