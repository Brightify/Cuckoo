// MARK: - Mocks generated from file: SourceFiles/TestedProtocol.swift
//
//  TestedProtocol.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

class MockTestedProtocol: TestedProtocol, Cuckoo.Mock {
    typealias MocksType = TestedProtocol
    typealias Stubbing = __StubbingProxy_TestedProtocol
    typealias Verification = __VerificationProxy_TestedProtocol
    let manager = Cuckoo.MockManager()
    
    private var observed: TestedProtocol?
    
    init() {
    }
    
    func spy(on victim: TestedProtocol) -> Self {
        observed = victim
        return self
    }
    
    var readOnlyProperty: String {
        get {
            return manager.getter("readOnlyProperty", original: observed.map { o in return { () -> String in o.readOnlyProperty } })
        }
    }
    
    var readWriteProperty: Int {
        get {
            return manager.getter("readWriteProperty", original: observed.map { o in return { () -> Int in o.readWriteProperty } })
        }
        set {
            manager.setter("readWriteProperty", value: newValue, original: observed != nil ? { self.observed?.readWriteProperty = $0 } : nil)
        }
    }
    
    var optionalProperty: Int? {
        get {
            return manager.getter("optionalProperty", original: observed.map { o in return { () -> Int? in o.optionalProperty } })
        }
        set {
            manager.setter("optionalProperty", value: newValue, original: observed != nil ? { self.observed?.optionalProperty = $0 } : nil)
        }
    }
    
    func noReturn() {
        return manager.call("noReturn()", parameters: (), original: observed.map { o in return { () in o.noReturn() } })
    }
    
    func countCharacters(test: String) -> Int {
        return manager.call("countCharacters(_: String) -> Int", parameters: (test), original: observed.map { o in return { (test: String) -> Int in o.countCharacters(test) } })
    }
    
    func withThrows() throws -> Int {
        return try manager.callThrows("withThrows() throws -> Int", parameters: (), original: observed.map { o in return { () throws -> Int in try o.withThrows() } })
    }
    
    func withNoReturnThrows() throws {
        return try manager.callThrows("withNoReturnThrows() throws", parameters: (), original: observed.map { o in return { () throws in try o.withNoReturnThrows() } })
    }
    
    func withClosure(closure: String -> Int) -> Int {
        return manager.call("withClosure(_: String -> Int) -> Int", parameters: (closure), original: observed.map { o in return { (closure: String -> Int) -> Int in o.withClosure(closure) } })
    }
    
    func withNoescape(a: String, @noescape closure: String -> Void) {
        return manager.call("withNoescape(_: String, closure: String -> Void)", parameters: (a, Cuckoo.markerFunction()), original: observed.map { o in return { (a: String, @noescape closure: String -> Void) in o.withNoescape(a, closure: closure) } })
    }
    
    func withOptionalClosure(a: String, closure: (String -> Void)?) {
        return manager.call("withOptionalClosure(_: String, closure: (String -> Void)?)", parameters: (a, closure), original: observed.map { o in return { (a: String, closure: (String -> Void)?) in o.withOptionalClosure(a, closure: closure) } })
    }
    
    struct __StubbingProxy_TestedProtocol: Cuckoo.StubbingProxy {
        private let manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
        
        var readOnlyProperty: Cuckoo.ToBeStubbedReadOnlyProperty<String> {
            return Cuckoo.ToBeStubbedReadOnlyProperty(manager: manager, name: "readOnlyProperty")
        }
        
        var readWriteProperty: Cuckoo.ToBeStubbedProperty<Int> {
            return Cuckoo.ToBeStubbedProperty(manager: manager, name: "readWriteProperty")
        }
        
        var optionalProperty: Cuckoo.ToBeStubbedProperty<Int?> {
            return Cuckoo.ToBeStubbedProperty(manager: manager, name: "optionalProperty")
        }
        
        @warn_unused_result
        func noReturn() -> Cuckoo.StubNoReturnFunction<()> {
            return Cuckoo.StubNoReturnFunction(stub: manager.createStub("noReturn()", parameterMatchers: []))
        }
        
        @warn_unused_result
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == String>(test: M1) -> Cuckoo.StubFunction<(String), Int> {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrapMatchable(test) { $0 }]
            return Cuckoo.StubFunction(stub: manager.createStub("countCharacters(_: String) -> Int", parameterMatchers: matchers))
        }
        
        @warn_unused_result
        func withThrows() -> Cuckoo.StubThrowingFunction<(), Int> {
            return Cuckoo.StubThrowingFunction(stub: manager.createStub("withThrows() throws -> Int", parameterMatchers: []))
        }
        
        @warn_unused_result
        func withNoReturnThrows() -> Cuckoo.StubNoReturnThrowingFunction<()> {
            return Cuckoo.StubNoReturnThrowingFunction(stub: manager.createStub("withNoReturnThrows() throws", parameterMatchers: []))
        }
        
        @warn_unused_result
        func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == String -> Int>(closure: M1) -> Cuckoo.StubFunction<(String -> Int), Int> {
            let matchers: [Cuckoo.ParameterMatcher<(String -> Int)>] = [wrapMatchable(closure) { $0 }]
            return Cuckoo.StubFunction(stub: manager.createStub("withClosure(_: String -> Int) -> Int", parameterMatchers: matchers))
        }
        
        @warn_unused_result
        func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == String, M2.MatchedType == String -> Void>(a: M1, closure: M2) -> Cuckoo.StubNoReturnFunction<(String, String -> Void)> {
            let matchers: [Cuckoo.ParameterMatcher<(String, String -> Void)>] = [wrapMatchable(a) { $0.0 }, wrapMatchable(closure) { $0.1 }]
            return Cuckoo.StubNoReturnFunction(stub: manager.createStub("withNoescape(_: String, closure: String -> Void)", parameterMatchers: matchers))
        }
        
        @warn_unused_result
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == String, M2.MatchedType == (String -> Void)?>(a: M1, closure: M2) -> Cuckoo.StubNoReturnFunction<(String, (String -> Void)?)> {
            let matchers: [Cuckoo.ParameterMatcher<(String, (String -> Void)?)>] = [wrapMatchable(a) { $0.0 }, wrapMatchable(closure) { $0.1 }]
            return Cuckoo.StubNoReturnFunction(stub: manager.createStub("withOptionalClosure(_: String, closure: (String -> Void)?)", parameterMatchers: matchers))
        }
    }
    
    struct __VerificationProxy_TestedProtocol: Cuckoo.VerificationProxy {
        private let manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var readOnlyProperty: Cuckoo.VerifyReadOnlyProperty<String> {
            return Cuckoo.VerifyReadOnlyProperty(manager: manager, name: "readOnlyProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var readWriteProperty: Cuckoo.VerifyProperty<Int> {
            return Cuckoo.VerifyProperty(manager: manager, name: "readWriteProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var optionalProperty: Cuckoo.VerifyProperty<Int?> {
            return Cuckoo.VerifyProperty(manager: manager, name: "optionalProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        func noReturn() -> Cuckoo.__DoNotUse<Void> {
            return manager.verify("noReturn()", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == String>(test: M1) -> Cuckoo.__DoNotUse<Int> {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrapMatchable(test) { $0 }]
            return manager.verify("countCharacters(_: String) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        func withThrows() -> Cuckoo.__DoNotUse<Int> {
            return manager.verify("withThrows() throws -> Int", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        func withNoReturnThrows() -> Cuckoo.__DoNotUse<Void> {
            return manager.verify("withNoReturnThrows() throws", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == String -> Int>(closure: M1) -> Cuckoo.__DoNotUse<Int> {
            let matchers: [Cuckoo.ParameterMatcher<(String -> Int)>] = [wrapMatchable(closure) { $0 }]
            return manager.verify("withClosure(_: String -> Int) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == String, M2.MatchedType == String -> Void>(a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<(String, String -> Void)>] = [wrapMatchable(a) { $0.0 }, wrapMatchable(closure) { $0.1 }]
            return manager.verify("withNoescape(_: String, closure: String -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == String, M2.MatchedType == (String -> Void)?>(a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<(String, (String -> Void)?)>] = [wrapMatchable(a) { $0.0 }, wrapMatchable(closure) { $0.1 }]
            return manager.verify("withOptionalClosure(_: String, closure: (String -> Void)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
    }
}
