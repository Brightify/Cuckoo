//
//  MockManager.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest

public class MockManager<STUBBING: StubbingProxy, VERIFICATION: VerificationProxy> {
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
        return try! self.callThrows(method, parameters: parameters, original: original)
    }
    
    public func callThrows<IN, OUT>(method: String, parameters: IN, original: (IN throws -> OUT)? = nil) throws -> OUT {
        let stubCall = StubCall(method: method, parameters: parameters)
        stubCalls.append(stubCall)
        unverifiedStubCallsIndexes.append(stubCalls.count - 1)
        
        if let stub = (stubs.filter { $0.name == method }.flatMap { $0 as? ConcreteStub<IN, OUT> }.filter { $0.parameterMatchers.reduce(true) { $0 && $1.matches(parameters) } }.first) {
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
                        fail("No real implementation found for method `\(method)`. This may happend because stubbed object is mock or spy of protocol.")
                    }
                }
            } else {
                fail("Stubbing of method `\(method)` using parameters \(parameters) wasn't finished (missing thenReturn()).")
            }
        }

        if let original = original {
            return try original(parameters)
        } else {
            fail("No stub for method `\(method)` using parameters \(parameters) and no original implementation was provided.")
        }
    }
    
    public func getStubbingProxy() -> STUBBING {
        let handler = StubbingHandler { stub in
            self.stubs.insert(stub, atIndex: 0)
        }
        return STUBBING(handler: handler)
    }

    public func getVerificationProxy(callMatcher: CallMatcher, sourceLocation: SourceLocation) -> VERIFICATION {
        let handler = VerificationHandler(callMatcher: callMatcher, sourceLocation: sourceLocation) { method, parameterMatchers in
            let calls = self.stubCalls.enumerate().filter { i, call in
                parameterMatchers.reduce(call.method == method) { $0 && $1.matches(call.parameters) }
            }
            let indexes = calls.map { $0.index }
            self.unverifiedStubCallsIndexes = self.unverifiedStubCallsIndexes.filter { !indexes.contains($0) }
            return calls.map { $0.element }
        }

        return VERIFICATION(handler: handler)
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
            let unverifiedCalls = unverifiedStubCallsIndexes.map { stubCalls[$0] }.map { String($0) }.joinWithSeparator(", ")
            XCTFail("Found unverified call(s): " + unverifiedCalls, file: sourceLocation.file, line: sourceLocation.line)
        }
    }
    
    @noreturn
    private func fail(message: String) {
        XCTFail(message)
        fatalError(message)
    }
}
