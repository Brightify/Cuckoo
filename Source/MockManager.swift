#if canImport(Testing)
import Testing
#endif
#if canImport(XCTest)
import XCTest
#endif

public class MockManager {
    nonisolated(unsafe) public static var fail: ((message: String, sourceLocation: SourceLocation)) -> Void = { arg in
        let (message, sourceLocation) = arg
        #if canImport(XCTest)
        XCTFail(message, file: sourceLocation.file, line: UInt(sourceLocation.line))
        #endif
        #if canImport(Testing)
        Issue.record(
            Comment(rawValue: message),
            sourceLocation: Testing.SourceLocation(
                fileID: sourceLocation.fileID,
                filePath: sourceLocation.filePath,
                line: sourceLocation.line,
                column: sourceLocation.column
            )
        )
        #endif
        #if !canImport(XCTest) && !canImport(Testing)
        print("\(Self.self).fail:", message, sourceLocation)
        #endif
    }

    private var stubs: [Stub] = []
    private var stubCalls: [StubCall] = []
    private var unverifiedStubCallsIndexes: [Int] = []
    // TODO Add either enum or OptionSet for these behavior modifiers and add proper validation
    private var isSuperclassSpyEnabled = false
    private var isDefaultImplementationEnabled = false
    
    private let hasParent: Bool
    
    private let queue = DispatchQueue(label: "cuckoo-mockmanager")

    public init(hasParent: Bool) {
        self.hasParent = hasParent
    }

    private func callInternal<IN, OUT>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: () -> OUT, defaultCall: () -> OUT) -> OUT {
        return callRethrowsInternal(method, parameters: parameters, escapingParameters: escapingParameters, superclassCall: superclassCall, defaultCall: defaultCall)
    }
    
    private func callInternal<IN, OUT>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: () async -> OUT, defaultCall: () async -> OUT) async -> OUT {
        return await callRethrowsInternal(method, parameters: parameters, escapingParameters: escapingParameters, superclassCall: superclassCall, defaultCall: defaultCall)
    }
    
    private func callRethrowsInternal<IN, OUT, ERROR>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: () throws(ERROR) -> OUT, defaultCall: () throws(ERROR) -> OUT) rethrows -> OUT {
        let stubCall = ConcreteStubCall(method: method, parameters: escapingParameters)
        queue.sync {
            stubCalls.append(stubCall)
            unverifiedStubCallsIndexes.append(stubCalls.count - 1)
        }

        if let stub = (stubs.filter { $0.method == method }.compactMap { $0 as? ConcreteStub<IN, OUT, ERROR> }.filter { $0.parameterMatchers.reduce(true) { $0 && $1.matches(parameters) } }.first) {
            
            guard let action = queue.sync(execute: {
                return stub.actions.count > 1 ? stub.actions.removeFirst() : stub.actions.first
            }) else {
                failAndCrash("Stubbing of method `\(method)` using parameters \(parameters) wasn't finished (missing thenReturn()).")
            }
            
            switch action {
            case .callImplementation(let implementation):
                return try DispatchQueue(label: "No-care?").sync(execute: {
                    return try implementation(parameters)
                })
            case .returnValue(let value):
                return value
            case .throwError(let error):
                return try DispatchQueue(label: "No-care?").sync(execute: {
                    throw error
                })
            case .callRealImplementation where hasParent:
                return try superclassCall()
            default:
                failAndCrash("No real implementation found for method `\(method)`. This is probably caused by stubbed object being a mock of a protocol.")
            }
        } else if isSuperclassSpyEnabled {
            return try superclassCall()
        } else if isDefaultImplementationEnabled {
            return try defaultCall()
        } else {
            failAndCrash("No stub for method `\(method)` using parameters \(parameters).")
        }
    }
    
    private func callRethrowsInternal<IN, OUT, ERROR>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: () async throws(ERROR) -> OUT, defaultCall: () async throws(ERROR) -> OUT) async rethrows -> OUT {
        let stubCall = ConcreteStubCall(method: method, parameters: escapingParameters)
        queue.sync {
            stubCalls.append(stubCall)
            unverifiedStubCallsIndexes.append(stubCalls.count - 1)
        }

        if let stub = (stubs.filter { $0.method == method }.compactMap { $0 as? ConcreteStub<IN, OUT, ERROR> }.filter { $0.parameterMatchers.reduce(true) { $0 && $1.matches(parameters) } }.first) {
            
            guard let action = queue.sync(execute: {
                return stub.actions.count > 1 ? stub.actions.removeFirst() : stub.actions.first
            }) else {
                failAndCrash("Stubbing of method `\(method)` using parameters \(parameters) wasn't finished (missing thenReturn()).")
            }
            
            switch action {
            case .callImplementation(let implementation):
                return try DispatchQueue(label: "No-care?").sync(execute: {
                    return try implementation(parameters)
                })
            case .returnValue(let value):
                return value
            case .throwError(let error):
                return try DispatchQueue(label: "No-care?").sync(execute: {
                    throw error
                })
            case .callRealImplementation where hasParent:
                return try await superclassCall()
            default:
                failAndCrash("No real implementation found for method `\(method)`. This is probably caused by stubbed object being a mock of a protocol.")
            }
        } else if isSuperclassSpyEnabled {
            return try await superclassCall()
        } else if isDefaultImplementationEnabled {
            return try await defaultCall()
        } else {
            failAndCrash("No stub for method `\(method)` using parameters \(parameters).")
        }
    }
    
    private func callThrowsInternal<IN, OUT, ERROR>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: () throws(ERROR) -> OUT, defaultCall: () throws(ERROR) -> OUT) throws(ERROR) -> OUT {
        let stubCall = ConcreteStubCall(method: method, parameters: escapingParameters)
        queue.sync {
            stubCalls.append(stubCall)
            unverifiedStubCallsIndexes.append(stubCalls.count - 1)
        }
        
        if let stub = (stubs.filter { $0.method == method }.compactMap { $0 as? ConcreteStub<IN, OUT, ERROR> }.filter { $0.parameterMatchers.reduce(true) { $0 && $1.matches(parameters) } }.first) {
            
            guard let action = queue.sync(execute: {
                return stub.actions.count > 1 ? stub.actions.removeFirst() : stub.actions.first
            }) else {
                failAndCrash("Stubbing of method `\(method)` using parameters \(parameters) wasn't finished (missing thenReturn()).")
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
        } else if isSuperclassSpyEnabled {
            return try superclassCall()
        } else if isDefaultImplementationEnabled {
            return try defaultCall()
        } else {
            failAndCrash("No stub for method `\(method)` using parameters \(parameters).")
        }
    }
    
    private func callThrowsInternal<IN, OUT, ERROR>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: () async throws(ERROR) -> OUT, defaultCall: () async throws(ERROR) -> OUT) async throws(ERROR) -> OUT {
        let stubCall = ConcreteStubCall(method: method, parameters: escapingParameters)
        queue.sync {
            stubCalls.append(stubCall)
            unverifiedStubCallsIndexes.append(stubCalls.count - 1)
        }
        
        if let stub = (stubs.filter { $0.method == method }.compactMap { $0 as? ConcreteStub<IN, OUT, ERROR> }.filter { $0.parameterMatchers.reduce(true) { $0 && $1.matches(parameters) } }.first) {
            
            guard let action = queue.sync(execute: {
                return stub.actions.count > 1 ? stub.actions.removeFirst() : stub.actions.first
            }) else {
                failAndCrash("Stubbing of method `\(method)` using parameters \(parameters) wasn't finished (missing thenReturn()).")
            }
            
            switch action {
            case .callImplementation(let implementation):
                return try implementation(parameters)
            case .returnValue(let value):
                return value
            case .throwError(let error):
                throw error
            case .callRealImplementation where hasParent:
                return try await superclassCall()
            default:
                failAndCrash("No real implementation found for method `\(method)`. This is probably caused  by stubbed object being a mock of a protocol.")
            }
        } else if isSuperclassSpyEnabled {
            return try await superclassCall()
        } else if isDefaultImplementationEnabled {
            return try await defaultCall()
        } else {
            failAndCrash("No stub for method `\(method)` using parameters \(parameters).")
        }
    }
    
    public func createStub<MOCK: ClassMock, IN, OUT, ERROR>(for _: MOCK.Type, method: String, parameterMatchers: [ParameterMatcher<IN>]) -> ClassConcreteStub<IN, OUT, ERROR> {
        let stub = ClassConcreteStub<IN, OUT, ERROR>(method: method, parameterMatchers: parameterMatchers)
        stubs.insert(stub, at: 0)
        return stub
    }

    public func createStub<MOCK: ProtocolMock, IN, OUT, ERROR>(for _: MOCK.Type, method: String, parameterMatchers: [ParameterMatcher<IN>]) -> ConcreteStub<IN, OUT, ERROR> {
        let stub = ConcreteStub<IN, OUT, ERROR>(method: method, parameterMatchers: parameterMatchers)
        stubs.insert(stub, at: 0)
        return stub
    }
    
    public func verify<IN, OUT>(_ method: String, callMatcher: CallMatcher, parameterMatchers: [ParameterMatcher<IN>], sourceLocation: SourceLocation) -> __DoNotUse<IN, OUT> {
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
            MockManager.fail((message: message, sourceLocation: sourceLocation))
        }
        return __DoNotUse()
    }

    public func enableSuperclassSpy() {
        guard stubCalls.isEmpty else {
            failAndCrash("Enabling superclass spy is not allowed after stubbing! Please do that right after creating the mock.")
        }
        guard !isDefaultImplementationEnabled else {
            failAndCrash("Enabling superclass spy is not allowed with the default stub implementation enabled.")
        }

        isSuperclassSpyEnabled = true
    }

    public func enableDefaultStubImplementation() {
        guard stubCalls.isEmpty else {
            failAndCrash("Enabling default stub implementation is not allowed after stubbing! Please do that right after creating the mock.")
        }
        guard !isSuperclassSpyEnabled else {
            failAndCrash("Enabling default stub implementation is not allowed with superclass spy enabled.")
        }

        isDefaultImplementationEnabled = true
    }
    
    func reset() {
        clearStubs()
        clearInvocations()
    }
    
    func clearStubs() {
        stubs.removeAll()
    }
    
    func clearInvocations() {
        queue.sync {
            stubCalls.removeAll()
            unverifiedStubCallsIndexes.removeAll()
        }
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
            MockManager.fail((message: message + unverifiedCalls, sourceLocation:  sourceLocation))
        }
    }

    private func failAndCrash(_ message: String, file: StaticString = #file, fileID: String = #fileID, filePath: String = #filePath, line: Int = #line, column: Int = #column) -> Never  {
        MockManager.fail((message: message, sourceLocation: (file, fileID, filePath, line, column)))

        #if _runtime(_ObjC)
        NSException(name: .internalInconsistencyException, reason: message, userInfo: nil).raise()
        #endif

        fatalError(message)
    }
}

extension MockManager {
    public static func callOrCrash<T, OUT>(_ value: T?, call: (T) throws -> OUT) rethrows -> OUT {
        guard let value = value else { return crashOnProtocolSuperclassCall() }
        return try call(value)
    }

    public static func crashOnProtocolSuperclassCall<OUT>() -> OUT {
        fatalError("This should never get called. If it does, please report an issue to Cuckoo repository.")
    }
}

extension MockManager {
    public func getter<T>(_ property: String, superclassCall: @autoclosure () -> T, defaultCall: @autoclosure () -> T) -> T {
        return call(getterName(property), parameters: Void(), escapingParameters: Void(), superclassCall: superclassCall(), defaultCall: defaultCall())
    }

    public func getter<T>(_ property: String, superclassCall: @autoclosure () async -> T, defaultCall: @autoclosure () async -> T) async -> T {
        return await call(getterName(property), parameters: Void(), escapingParameters: Void(), superclassCall: await superclassCall(), defaultCall: await defaultCall())
    }

    public func setter<T>(_ property: String, value: T, superclassCall: @autoclosure () -> Void, defaultCall: @autoclosure () -> Void) {
        return call(setterName(property), parameters: value, escapingParameters: value, superclassCall: superclassCall(), defaultCall: defaultCall())
    }
}

extension MockManager {
    public func getterThrows<T>(_ property: String, superclassCall: @autoclosure () throws -> T, defaultCall: @autoclosure () throws -> T) throws -> T {
        return try callThrows(getterName(property), parameters: Void(), escapingParameters: Void(), errorType: (Error).self, superclassCall: try superclassCall(), defaultCall: try defaultCall())
    }

    public func getterThrows<T>(_ property: String, superclassCall: @autoclosure () async throws -> T, defaultCall: @autoclosure () async throws -> T) async throws -> T {
        return try await callThrows(getterName(property), parameters: Void(), escapingParameters: Void(), errorType: (Error).self, superclassCall: try await superclassCall(), defaultCall: try await defaultCall())
    }
}

extension MockManager {
    public func call<IN, OUT>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: @autoclosure () -> OUT, defaultCall: @autoclosure () -> OUT) -> OUT {
        return callInternal(method, parameters: parameters, escapingParameters: escapingParameters, superclassCall: superclassCall, defaultCall: defaultCall)
    }
    
    public func call<IN, OUT>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: @autoclosure () async -> OUT, defaultCall: @autoclosure () async -> OUT) async -> OUT {
        return await callInternal(method, parameters: parameters, escapingParameters: escapingParameters, superclassCall: superclassCall, defaultCall: defaultCall)
    }
}

extension MockManager {
    public func callThrows<IN, OUT, ERROR>(_ method: String, parameters: IN, escapingParameters: IN, errorType: ERROR.Type, superclassCall: @autoclosure () throws(ERROR) -> OUT, defaultCall: @autoclosure () throws(ERROR) -> OUT) throws(ERROR) -> OUT {
        return try callThrowsInternal(method, parameters: parameters, escapingParameters: escapingParameters, superclassCall: superclassCall, defaultCall: defaultCall)
    }
    
    public func callThrows<IN, OUT, ERROR>(_ method: String, parameters: IN, escapingParameters: IN, errorType: ERROR.Type, superclassCall: @autoclosure () async throws(ERROR) -> OUT, defaultCall: @autoclosure () async throws(ERROR) -> OUT) async throws(ERROR) -> OUT {
        return try await callThrowsInternal(method, parameters: parameters, escapingParameters: escapingParameters, superclassCall: superclassCall, defaultCall: defaultCall)
    }
}

extension MockManager {
    public func callRethrows<IN, OUT>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: @autoclosure () throws -> OUT, defaultCall: @autoclosure () throws -> OUT) rethrows -> OUT {
        return try callRethrowsInternal(method, parameters: parameters, escapingParameters: escapingParameters, superclassCall: superclassCall, defaultCall: defaultCall)
    }
    
    public func callRethrows<IN, OUT>(_ method: String, parameters: IN, escapingParameters: IN, superclassCall: @autoclosure () async throws -> OUT, defaultCall: @autoclosure () async throws -> OUT) async rethrows -> OUT {
        return try await callRethrowsInternal(method, parameters: parameters, escapingParameters: escapingParameters, superclassCall: superclassCall, defaultCall: defaultCall)
    }
}
