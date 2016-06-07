//
//  MockManager.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest

public class MockManager<STUBBING: StubbingProxy, VERIFICATION: VerificationProxy> {
    private var stubs: [String: [Stub]] = [:]
    private var stubCalls: [StubCall] = []
    
    public init() {
        
    }

    public func getter<T>(property: String, original: (Void -> T)? = nil) -> (Void -> T) {
        return call(getterName(property), parameters: Void(), original: original)
    }
    
    public func setter<T>(property: String, value: T, original: (T -> Void)? = nil) -> (T -> Void) {
        return call(setterName(property), parameters: value, original: original)
    }
    
    public func call<IN, OUT>(method: String, parameters: IN, original: (IN -> OUT)? = nil) -> IN -> OUT {
        return { try! self.callThrows(method, parameters: parameters, original: original)($0) }
    }
    
    public func callThrows<IN, OUT>(method: String, parameters: IN, original: (IN throws -> OUT)? = nil) -> IN throws -> OUT {
        let stubCall = StubCall(method: method, parameters: parameters)
        stubCalls.append(stubCall)
            
        if let stub = (stubs[method]?.filter { $0.parameterMatchers.reduce(true) { $0 && $1.matches(parameters) } }.first) {
            return {
                switch stub.output($0) {
                case .ReturnValue(let value):
                    return value as! OUT
                case .Error(let error):
                    throw error
                }
            }
        } else if let original = original {
            return { try original($0) }
        } else {
            let message = "No stub for method `\(method)` using parameters \(parameters) and no original implementation was provided."
            XCTFail(message)
            fatalError(message)
        }
    }
    
    public func getStubbingProxy() -> STUBBING {
        let handler = StubbingHandler { stub in
            if self.stubs[stub.name] == nil {
                self.stubs[stub.name] = []
            }
            
            self.stubs[stub.name]?.insert(stub, atIndex: 0)
        }
        return STUBBING(handler: handler)
    }

    public func getVerificationProxy(matcher: AnyMatcher<[StubCall]>, sourceLocation: SourceLocation) -> VERIFICATION {
        let handler = VerificationHandler(matcher: matcher, sourceLocation: sourceLocation) { method, sourceLocation, callMatcher, verificationMatcher in
            let calls = self.stubCalls.filter(callMatcher.matches)
            
            if verificationMatcher.matches(calls) == false {
                let description = StringDescription()
                description
                    .append(text: "Expected ")
                    .append(descriptionOf: verificationMatcher)
                    .append(text: ", but ")
                verificationMatcher.describeMismatch(calls, to: description)

                XCTFail(description.description, file: sourceLocation.file, line: sourceLocation.line)
            }
        }

        return VERIFICATION(handler: handler)
    }
}
