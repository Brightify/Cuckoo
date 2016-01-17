//
//  Mockery.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import XCTest

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
    public var callOriginalIfNotStubbed: Bool

    private var mode: Mode = .Default

    private var stubs: [String: [Stub]] = [:]
    private var stubCalls: [StubCall] = []

    public init(callOriginalIfNotStubbed: Bool = false) {
        self.callOriginalIfNotStubbed = callOriginalIfNotStubbed
    }

    private func doCall<IN, OUT>(method: String, parameters: IN, @noescape original: Void -> OUT?) -> OUT {
        return try! doCallThrows(method, parameters: parameters, original: original)
    }

    private func doCallThrows<IN, OUT>(method: String, parameters: IN, @noescape original: Void throws -> OUT?) throws -> OUT {
        let stubCall = StubCall(method: method, parameters: parameters)
        stubCalls.append(stubCall)
        
        if let stub = findStub(method, parameters: parameters) {
            switch stub.output(parameters) {
            case .ReturnValue(let value):
                return value as! OUT
            case .Error(let error):
                throw error
            }
        } else {
            if callOriginalIfNotStubbed == false {
                let message = "No stub for method `\(method)` using parameters \(parameters) and forwarding to original is disabled!"
                XCTFail(message)
                fatalError(message)
            } else if let output = try original() {
                 return output
            } else {
                let message = "No stub for method `\(method)` using parameters \(parameters). Forwarding to original is enabled, but no original was supplied!"
                XCTFail(message)
                fatalError(message)
            }
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

    private func verify(method: String, callMatcher: AnyMatcher<StubCall>, verificationMatcher: AnyMatcher<[StubCall]>) {
        let calls = stubCalls.filter(callMatcher.matches)
        
        if verificationMatcher.matches(calls) == false {
            let description = StringDescription()
            description
                .appendText("Expected: ")
                .appendDescriptionOf(verificationMatcher)
                .appendText("\n     but: ");
            verificationMatcher.describeMismatch(calls, to: description);
            
            XCTFail(description.description)
        }
        
    }
}

extension MockManager {

    public func getStubbingProxy() -> STUBBING {
        return STUBBING(handler: StubbingHandler(createNewStub: createNewStub))
    }

}

extension MockManager {

    public func getVerificationProxy(matcher: AnyMatcher<[StubCall]>) -> VERIFICATION {
        return VERIFICATION(handler: VerificationHandler(matcher: matcher, verifyCall: verify))
    }

}

public extension MockManager {
    public func call<OUT>(method: String) -> OUT {
        return doCall(method, parameters: Void(), original: { nil })
    }

    public func call<OUT>(method: String, @noescape original: Void -> OUT) -> OUT {
        return doCall(method, parameters: Void(), original: original)
    }

    public func call<IN, OUT>(method: String, parameters: IN) -> OUT {
        return doCall(method, parameters: parameters, original: { nil })
    }

    public func call<IN, OUT>(method: String, parameters: IN, @noescape original: Void -> OUT) -> OUT {
        return doCall(method, parameters: parameters, original: original)
    }

    public func callThrows<OUT>(method: String) throws -> OUT {
        return try doCallThrows(method, parameters: Void(), original: { nil })
    }

    public func callThrows<OUT>(method: String, @noescape original: Void throws -> OUT) throws -> OUT {
        return try doCallThrows(method, parameters: Void(), original: original)
    }

    public func callThrows<IN, OUT>(method: String, parameters: IN) throws -> OUT {
        return try doCallThrows(method, parameters: parameters, original: { nil })
    }

    public func callThrows<IN, OUT>(method: String, parameters: IN, @noescape original: Void throws -> OUT) throws -> OUT {
        return try doCallThrows(method, parameters: parameters, original: original)
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