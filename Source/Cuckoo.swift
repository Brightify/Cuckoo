//
//  Mockery.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import XCTest

enum ReturnValueOrError {
    case ReturnValue(Any)
    case Error(ErrorType)
}

func getterName(property: String) -> String {
    return property + "#get"
}

func setterName(property: String) -> String {
    return property + "#set"
}

public class MockManager<STUBBING: StubbingProxy, VERIFICATION: VerificationProxy> {
    private var stubs: [String: [Stub]] = [:]
    private var stubCalls: [StubCall] = []

    public init() {
        
    }

    private func doCall<IN, OUT>(method: String, parameters: IN, original: (IN -> OUT)? = nil) -> IN -> OUT {
        return { try! self.doCallThrows(method, parameters: parameters, original: original)($0) }
    }

    private func doCallThrows<IN, OUT>(method: String, parameters: IN, original: (IN throws -> OUT)? = nil) -> IN throws -> OUT {
        let stubCall = StubCall(method: method, parameters: parameters)
        stubCalls.append(stubCall)
        
        if let stub = findStub(method, parameters: parameters) {
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

    private func findStub<IN>(method: String, parameters: IN) -> Stub? {
        guard let stubsWithSameName = stubs[method] else { return nil }
        return stubsWithSameName.filter { $0.parameterMatchers.reduce(true) { $0 && $1.matches(parameters) } }.first
    }

    private func createNewStub(stub: Stub) {
        if !stubs.keys.contains(stub.name) {
            stubs[stub.name] = []
        }

        stubs[stub.name]?.insert(stub, atIndex: 0)
    }

    private func verify(method: String, sourceLocation: SourceLocation, callMatcher: AnyMatcher<StubCall>, verificationMatcher: AnyMatcher<[StubCall]>) {
        let calls = stubCalls.filter(callMatcher.matches)
        
        if verificationMatcher.matches(calls) == false {
            let description = StringDescription()
            description
                .appendText("Expected ")
                .appendDescriptionOf(verificationMatcher)
                .appendText(", but ");
            verificationMatcher.describeMismatch(calls, to: description);
            
            XCTFail(description.description, file: sourceLocation.file, line: sourceLocation.line)
        }
        
    }
}

extension MockManager {

    public func getStubbingProxy() -> STUBBING {
        return STUBBING(handler: StubbingHandler(createNewStub: createNewStub))
    }

}

extension MockManager {

    public func getVerificationProxy(matcher: AnyMatcher<[StubCall]>, sourceLocation: SourceLocation) -> VERIFICATION {
        return VERIFICATION(handler: VerificationHandler(matcher: matcher, sourceLocation: sourceLocation, verifyCall: verify))
    }

}

public extension MockManager {
    public func getter<T>(property: String, original: (Void -> T)? = nil) -> (Void -> T) {
        return call(getterName(property), original: original)
    }
    
    public func setter<T>(property: String, value: T, original: (T -> Void)? = nil) -> (T -> Void) {
        return call(setterName(property), parameters: value, original: original)
    }
    
    public func call<OUT>(method: String, original: (Void -> OUT)? = nil) -> Void -> OUT {
        return doCall(method, parameters: Void(), original: original)
    }

    public func call<IN, OUT>(method: String, parameters: IN, original: (IN -> OUT)? = nil) -> IN -> OUT {
        return doCall(method, parameters: parameters, original: original)
    }
 
    public func callThrows<OUT>(method: String, original: (Void throws -> OUT)? = nil) -> Void throws -> OUT {
        return doCallThrows(method, parameters: Void(), original: original)
    }

    public func callThrows<IN, OUT>(method: String, parameters: IN, original: (IN throws -> OUT)? = nil) -> IN throws -> OUT {
        return doCallThrows(method, parameters: parameters, original: original)
    }
}

public protocol Mock {
    typealias MocksType
    typealias Stubbing: StubbingProxy
    typealias Verification: VerificationProxy
    
    var manager: MockManager<Stubbing, Verification> { get }

    init()
    
    init(spyOn: MocksType)
}

public protocol Mockable {
    typealias MockType: Mock
}

public func mock<M: Mockable>(mockable: M.Type) -> M.MockType {
    return M.MockType()
}

public func spy<M: Mockable where M.MockType.MocksType == M>(spied: M) -> M.MockType {
    return M.MockType(spyOn: spied)
}