//
//  MockManager.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest

public class MockManager {
    public static var fail: ((message: String, sourceLocation: SourceLocation)) -> () = { (arg) in let (message, sourceLocation) = arg; XCTFail(message, file: sourceLocation.file, line: sourceLocation.line) }
    private var stubs: [Stub] = []
    private var stubCalls: [StubCall] = []
    private var unverifiedStubCallsIndexes: [Int] = []
    private var isSuperclassSpyEnabled = false
    
    private let hasParent: Bool

    public init(hasParent: Bool) {
        self.hasParent = hasParent
    }

    private func callInternal<IN, OUT>(_ method: String, parameters: IN, superclassCall: () -> OUT) -> OUT {
        return try! callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
    }
    
    private func callThrowsInternal<IN, OUT>(_ method: String, parameters: IN, superclassCall: () throws -> OUT) throws -> OUT {
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
                case .callRealImplementation where hasParent:
                    return try superclassCall()
                default:
                    failAndCrash("No real implementation found for method `\(method)`. This is probably caused  by stubbed object being a mock of a protocol.")
                }
            } else {
                failAndCrash("Stubbing of method `\(method)` using parameters \(parameters) wasn't finished (missing thenReturn()).")
            }
        } else if isSuperclassSpyEnabled {
            return try superclassCall()
        } else {
            failAndCrash("No stub for method `\(method)` using parameters \(parameters).")
        }
    }
    
    public func createStub<MOCK: ClassMock, IN, OUT>(for _: MOCK.Type, method: String, parameterMatchers: [ParameterMatcher<IN>]) -> ClassConcreteStub<IN, OUT> {
        let stub = ClassConcreteStub<IN, OUT>(method: method, parameterMatchers: parameterMatchers)
        stubs.insert(stub, at: 0)
        return stub
    }

    public func createStub<MOCK: ProtocolMock, IN, OUT>(for _: MOCK.Type, method: String, parameterMatchers: [ParameterMatcher<IN>]) -> ConcreteStub<IN, OUT> {
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
            MockManager.fail((message, sourceLocation))
        }
        return __DoNotUse()
    }

    public func enableSuperclassSpy() {
        guard stubCalls.isEmpty else {
            failAndCrash("Enabling superclass spy is not allowed after stubbing! Please do that right after creating the mock.")
        }

        isSuperclassSpyEnabled = true
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
                        let name = call.method[..<bracketIndex]
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
            MockManager.fail((message + unverifiedCalls, sourceLocation))
        }
    }
    
    
    private func failAndCrash(_ message: String, file: StaticString = #file, line: UInt = #line) -> Never  {
        MockManager.fail((message, (file, line)))

        #if _runtime(_ObjC)
            NSException(name: .internalInconsistencyException, reason:message, userInfo: nil).raise()
        #endif

        fatalError(message)
    }
}

extension MockManager {
    public static func crashOnProtocolSuperclassCall<OUT>() -> OUT {
        fatalError("This should never get called. If it does, please report an issue to Cuckoo repository.")
    }
}

extension MockManager {
    public func getter<T>(_ property: String, superclassCall: @autoclosure () -> T) -> T {
        return call(getterName(property), parameters: Void(), superclassCall: superclassCall())
    }

    public func setter<T>(_ property: String, value: T, superclassCall: @autoclosure () -> Void) {
        return call(setterName(property), parameters: value, superclassCall: superclassCall())
    }

}

// DSL helpers workarounding Swift 3's removal of parameter splat
// All the casting below is to not require extra parenthesses, introduced in Swift 4
extension MockManager {
//    public func call<IN, OUT>(_ method: String, parameters: IN, superclassCall: @escaping (IN) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }

    public func call<IN, OUT>(_ method: String, parameters: IN, superclassCall: @autoclosure () -> OUT) -> OUT {
        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
    }

//    public func call<IN1, IN2, OUT>(_ method: String, parameters: (IN1, IN2), superclassCall: (IN1, IN2) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, OUT>(_ method: String, parameters: (IN1, IN2, IN3), superclassCall: (IN1, IN2, IN3) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4), superclassCall: (IN1, IN2, IN3, IN4) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5), superclassCall: (IN1, IN2, IN3, IN4, IN5) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func call<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16) -> OUT) -> OUT {
//        return callInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
}

extension MockManager {
    public func callThrows<IN, OUT>(_ method: String, parameters: IN, superclassCall: @autoclosure () throws -> OUT) throws -> OUT {
        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
    }

//    public func callThrows<IN1, IN2, OUT>(_ method: String, parameters: (IN1, IN2), superclassCall: (IN1, IN2) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, OUT>(_ method: String, parameters: (IN1, IN2, IN3), superclassCall: (IN1, IN2, IN3) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4), superclassCall: (IN1, IN2, IN3, IN4) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5), superclassCall: (IN1, IN2, IN3, IN4, IN5) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
//
//    public func callThrows<IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16, OUT>(_ method: String, parameters: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16), superclassCall: (IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, IN16) throws -> OUT) throws -> OUT {
//        return try callThrowsInternal(method, parameters: parameters, superclassCall: superclassCall)
//    }
}
