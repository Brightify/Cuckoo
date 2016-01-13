//
//  Mockery.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

enum Mode {
    case Stubbing
    case Verification
    case Default
}

enum ReturnValueOrError {
    case ReturnValue(Any)
    case Error(ErrorType)
}

public class MockManager<STUBBING: StubbingProxy, VERIFICATION: VerificationProxy> {
    public var callOriginalIfNotStubbed: Bool = false
    
    private var mode: Mode = .Default
    
    private var stubs: [String: [Stub]] = [:]
    
    public init() {
    }
    
    public func call<OUT>(method: String) -> OUT {
        return call(method, parameters: Void())
    }
    
    public func call<IN, OUT>(method: String, parameters: IN) -> OUT {
        return try! callThrows(method, parameters: parameters)
    }
    
    public func callThrows<OUT>(method: String) throws -> OUT {
        return try callThrows(method, parameters: Void())
    }
    
    public func callThrows<IN, OUT>(method: String, parameters: IN, original: (IN -> OUT)? = nil) throws -> OUT {
        if let stub = findStub(method, parameters: parameters) {
            switch stub.call() {
            case .ReturnValue(let value):
                return value as! OUT
            case .Error(let error):
                throw error
            }
        } else {
            if callOriginalIfNotStubbed == false {
                fatalError("No stub for method `\(method)` using parameters \(parameters) and forwarding to original is disabled!")
            }
        }
        
        print(method, parameters)
        fatalError("\(method) -- \(parameters)")
    }
    
    private func findStub<IN>(method: String, parameters: IN) -> Stub? {
        guard let stubsWithSameName = stubs[method] else { return nil }
        return stubsWithSameName.filter { $0.inputMatcher.matches(parameters) }.first
    }
    
    private func createNewStub(stub: Stub) {
        if !stubs.keys.contains(stub.name) {
            stubs[stub.name] = []
        }
        
        stubs[stub.name]?.insert(stub, atIndex: 0)
    }
    
    private func verify<IN>(method: String, parameters: IN, matcher: AnyMatcher<Stub?>) {
        let foundStub = findStub(method, parameters: parameters)
        assert(matcher.matches(foundStub), matcher.describe(foundStub))
    }
}

extension MockManager {
    
    public func getStubbingProxy() -> STUBBING {
        return STUBBING(handler: StubbingHandler(createNewStub: createNewStub))
    }
    
    
    
}

extension MockManager {
    
    public func getVerificationProxy(matcher: AnyMatcher<Stub?>) -> VERIFICATION {
        return VERIFICATION(handler: VerificationHandler(matcher: matcher, verifyCall: verify))
    }
    
}

public protocol Mock {
    typealias Stubbing: StubbingProxy
    typealias Verification: VerificationProxy
    
    var manager: MockManager<Stubbing, Verification> { get }
}