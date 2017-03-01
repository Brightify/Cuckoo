// MARK: - Mocks generated from file: SourceFiles/TestedClass.swift
//
//  TestedClass.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 09/02/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

class MockTestedClass: TestedClass, Cuckoo.Mock {
    typealias MocksType = TestedClass
    typealias Stubbing = __StubbingProxy_TestedClass
    typealias Verification = __VerificationProxy_TestedClass
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: TestedClass?
    
    func spy(on victim: TestedClass) -> Self {
        observed = victim
        return self
    }
    
    override var readOnlyProperty: String {
        get {
            return cuckoo_manager.getter("readOnlyProperty", original: observed.map { o in return { () -> String in o.readOnlyProperty } })
        }
    }
    
    override var readWriteProperty: Int {
        get {
            return cuckoo_manager.getter("readWriteProperty", original: observed.map { o in return { () -> Int in o.readWriteProperty } })
        }
        set {
            cuckoo_manager.setter("readWriteProperty", value: newValue, original: observed != nil ? { self.observed?.readWriteProperty = $0 } : nil)
        }
    }
    
    override var optionalProperty: Int? {
        get {
            return cuckoo_manager.getter("optionalProperty", original: observed.map { o in return { () -> Int? in o.optionalProperty } })
        }
        set {
            cuckoo_manager.setter("optionalProperty", value: newValue, original: observed != nil ? { self.observed?.optionalProperty = $0 } : nil)
        }
    }
    
    override func noReturn() {
        return cuckoo_manager.call("noReturn()", parameters: (), original: observed.map { o in return { () in o.noReturn() } })
    }
    
    override func count(characters: String) -> Int {
        return cuckoo_manager.call("count(characters: String) -> Int", parameters: (characters), original: observed.map { o in return { (characters: String) -> Int in o.count(characters: characters) } })
    }
    
    override func withThrows() throws -> Int {
        return try cuckoo_manager.callThrows("withThrows() throws -> Int", parameters: (), original: observed.map { o in return { () throws -> Int in try o.withThrows() } })
    }
    
    override func withNoReturnThrows() throws {
        return try cuckoo_manager.callThrows("withNoReturnThrows() throws", parameters: (), original: observed.map { o in return { () throws in try o.withNoReturnThrows() } })
    }
    
    override func withClosure(_ closure: (String) -> Int) -> Int {
        return cuckoo_manager.call("withClosure(_: (String) -> Int) -> Int", parameters: (closure), original: observed.map { o in return { (closure: (String) -> Int) -> Int in o.withClosure(closure) } })
    }
    
    override func withEscape(_ a: String, action closure: @escaping (String) -> Void) {
        return cuckoo_manager.call("withEscape(_: String, action: @escaping (String) -> Void)", parameters: (a, closure), original: observed.map { o in return { (a: String, closure: @escaping (String) -> Void) in o.withEscape(a, action: closure) } })
    }
    
    override func withOptionalClosure(_ a: String, closure: ((String) -> Void)?) {
        return cuckoo_manager.call("withOptionalClosure(_: String, closure: ((String) -> Void)?)", parameters: (a, closure), original: observed.map { o in return { (a: String, closure: ((String) -> Void)?) in o.withOptionalClosure(a, closure: closure) } })
    }
    
    override func withLabelAndUnderscore(labelA a: String, _ b: String) {
        return cuckoo_manager.call("withLabelAndUnderscore(labelA: String, _: String)", parameters: (a, b), original: observed.map { o in return { (a: String, b: String) in o.withLabelAndUnderscore(labelA: a, b) } })
    }
    
    struct __StubbingProxy_TestedClass: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.manager = cuckoo_manager
        }
        
        var readOnlyProperty: Cuckoo.ToBeStubbedReadOnlyProperty<String> {
            return Cuckoo.ToBeStubbedReadOnlyProperty(manager: cuckoo_manager, name: "readOnlyProperty")
        }
        
        var readWriteProperty: Cuckoo.ToBeStubbedProperty<Int> {
            return Cuckoo.ToBeStubbedProperty(manager: cuckoo_manager, name: "readWriteProperty")
        }
        
        var optionalProperty: Cuckoo.ToBeStubbedProperty<Int?> {
            return Cuckoo.ToBeStubbedProperty(manager: cuckoo_manager, name: "optionalProperty")
        }
        
        func noReturn() -> Cuckoo.StubNoReturnFunction<()> {
            return Cuckoo.StubNoReturnFunction(stub: cuckoo_manager.createStub("noReturn()", parameterMatchers: []))
        }
        
        func count<M1: Cuckoo.Matchable>(characters: M1) -> Cuckoo.StubFunction<(String), Int> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: characters) { $0 }]
            return Cuckoo.StubFunction(stub: cuckoo_manager.createStub("count(characters: String) -> Int", parameterMatchers: matchers))
        }
        
        func withThrows() -> Cuckoo.StubThrowingFunction<(), Int> {
            return Cuckoo.StubThrowingFunction(stub: cuckoo_manager.createStub("withThrows() throws -> Int", parameterMatchers: []))
        }
        
        func withNoReturnThrows() -> Cuckoo.StubNoReturnThrowingFunction<()> {
            return Cuckoo.StubNoReturnThrowingFunction(stub: cuckoo_manager.createStub("withNoReturnThrows() throws", parameterMatchers: []))
        }
        
        func withClosure<M1: Cuckoo.Matchable>(_ closure: M1) -> Cuckoo.StubFunction<((String) -> Int), Int> where M1.MatchedType == (String) -> Int {
            let matchers: [Cuckoo.ParameterMatcher<((String) -> Int)>] = [wrap(matchable: closure) { $0 }]
            return Cuckoo.StubFunction(stub: cuckoo_manager.createStub("withClosure(_: (String) -> Int) -> Int", parameterMatchers: matchers))
        }
        
        func withEscape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ a: M1, action closure: M2) -> Cuckoo.StubNoReturnFunction<(String, (String) -> Void)> where M1.MatchedType == String, M2.MatchedType == (String) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(String, (String) -> Void)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: closure) { $0.1 }]
            return Cuckoo.StubNoReturnFunction(stub: cuckoo_manager.createStub("withEscape(_: String, action: @escaping (String) -> Void)", parameterMatchers: matchers))
        }
        
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ a: M1, closure: M2) -> Cuckoo.StubNoReturnFunction<(String, ((String) -> Void)?)> where M1.MatchedType == String, M2.MatchedType == ((String) -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(String, ((String) -> Void)?)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: closure) { $0.1 }]
            return Cuckoo.StubNoReturnFunction(stub: cuckoo_manager.createStub("withOptionalClosure(_: String, closure: ((String) -> Void)?)", parameterMatchers: matchers))
        }
        
        func withLabelAndUnderscore<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(labelA a: M1, _ b: M2) -> Cuckoo.StubNoReturnFunction<(String, String)> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: b) { $0.1 }]
            return Cuckoo.StubNoReturnFunction(stub: cuckoo_manager.createStub("withLabelAndUnderscore(labelA: String, _: String)", parameterMatchers: matchers))
        }
    }
    
    struct __VerificationProxy_TestedClass: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = cuckoo_manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var readOnlyProperty: Cuckoo.VerifyReadOnlyProperty<String> {
            return Cuckoo.VerifyReadOnlyProperty(manager: cuckoo_manager, name: "readOnlyProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var readWriteProperty: Cuckoo.VerifyProperty<Int> {
            return Cuckoo.VerifyProperty(manager: cuckoo_manager, name: "readWriteProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var optionalProperty: Cuckoo.VerifyProperty<Int?> {
            return Cuckoo.VerifyProperty(manager: cuckoo_manager, name: "optionalProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func noReturn() -> Cuckoo.__DoNotUse<Void> {
            return cuckoo_manager.verify("noReturn()", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func count<M1: Cuckoo.Matchable>(characters: M1) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: characters) { $0 }]
            return cuckoo_manager.verify("count(characters: String) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withThrows() -> Cuckoo.__DoNotUse<Int> {
            return cuckoo_manager.verify("withThrows() throws -> Int", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withNoReturnThrows() -> Cuckoo.__DoNotUse<Void> {
            return cuckoo_manager.verify("withNoReturnThrows() throws", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withClosure<M1: Cuckoo.Matchable>(_ closure: M1) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == (String) -> Int {
            let matchers: [Cuckoo.ParameterMatcher<((String) -> Int)>] = [wrap(matchable: closure) { $0 }]
            return cuckoo_manager.verify("withClosure(_: (String) -> Int) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withEscape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ a: M1, action closure: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == (String) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(String, (String) -> Void)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: closure) { $0.1 }]
            return cuckoo_manager.verify("withEscape(_: String, action: @escaping (String) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == ((String) -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(String, ((String) -> Void)?)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: closure) { $0.1 }]
            return cuckoo_manager.verify("withOptionalClosure(_: String, closure: ((String) -> Void)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withLabelAndUnderscore<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(labelA a: M1, _ b: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: b) { $0.1 }]
            return cuckoo_manager.verify("withLabelAndUnderscore(labelA: String, _: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
    }
}

class TestedClassStub: TestedClass {
    
    override var readOnlyProperty: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    override var readWriteProperty: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        set {
        }
    }
    
    override var optionalProperty: Int? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int?).self)
        }
        set {
        }
    }
    
    override func noReturn() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func count(characters: String) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    override func withThrows() throws -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    override func withNoReturnThrows() throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func withClosure(_ closure: (String) -> Int) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    override func withEscape(_ a: String, action closure: @escaping (String) -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func withOptionalClosure(_ a: String, closure: ((String) -> Void)?) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func withLabelAndUnderscore(labelA a: String, _ b: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}

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
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: TestedProtocol?
    
    func spy(on victim: TestedProtocol) -> Self {
        observed = victim
        return self
    }
    
    var readOnlyProperty: String {
        get {
            return cuckoo_manager.getter("readOnlyProperty", original: observed.map { o in return { () -> String in o.readOnlyProperty } })
        }
    }
    
    var readWriteProperty: Int {
        get {
            return cuckoo_manager.getter("readWriteProperty", original: observed.map { o in return { () -> Int in o.readWriteProperty } })
        }
        set {
            cuckoo_manager.setter("readWriteProperty", value: newValue, original: observed != nil ? { self.observed?.readWriteProperty = $0 } : nil)
        }
    }
    
    var optionalProperty: Int? {
        get {
            return cuckoo_manager.getter("optionalProperty", original: observed.map { o in return { () -> Int? in o.optionalProperty } })
        }
        set {
            cuckoo_manager.setter("optionalProperty", value: newValue, original: observed != nil ? { self.observed?.optionalProperty = $0 } : nil)
        }
    }
    
    func noReturn() {
        return cuckoo_manager.call("noReturn()", parameters: (), original: observed.map { o in return { () in o.noReturn() } })
    }
    
    func count(characters: String) -> Int {
        return cuckoo_manager.call("count(characters: String) -> Int", parameters: (characters), original: observed.map { o in return { (characters: String) -> Int in o.count(characters: characters) } })
    }
    
    func withThrows() throws -> Int {
        return try cuckoo_manager.callThrows("withThrows() throws -> Int", parameters: (), original: observed.map { o in return { () throws -> Int in try o.withThrows() } })
    }
    
    func withNoReturnThrows() throws {
        return try cuckoo_manager.callThrows("withNoReturnThrows() throws", parameters: (), original: observed.map { o in return { () throws in try o.withNoReturnThrows() } })
    }
    
    func withClosure(_ closure: (String) -> Int) -> Int {
        return cuckoo_manager.call("withClosure(_: (String) -> Int) -> Int", parameters: (closure), original: observed.map { o in return { (closure: (String) -> Int) -> Int in o.withClosure(closure) } })
    }
    
    func withEscape(_ a: String, action closure: @escaping (String) -> Void) {
        return cuckoo_manager.call("withEscape(_: String, action: @escaping (String) -> Void)", parameters: (a, closure), original: observed.map { o in return { (a: String, closure: @escaping (String) -> Void) in o.withEscape(a, action: closure) } })
    }
    
    func withOptionalClosure(_ a: String, closure: ((String) -> Void)?) {
        return cuckoo_manager.call("withOptionalClosure(_: String, closure: ((String) -> Void)?)", parameters: (a, closure), original: observed.map { o in return { (a: String, closure: ((String) -> Void)?) in o.withOptionalClosure(a, closure: closure) } })
    }
    
    func withLabelAndUnderscore(labelA a: String, _ b: String) {
        return cuckoo_manager.call("withLabelAndUnderscore(labelA: String, _: String)", parameters: (a, b), original: observed.map { o in return { (a: String, b: String) in o.withLabelAndUnderscore(labelA: a, b) } })
    }
    
    struct __StubbingProxy_TestedProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.manager = cuckoo_manager
        }
        
        var readOnlyProperty: Cuckoo.ToBeStubbedReadOnlyProperty<String> {
            return Cuckoo.ToBeStubbedReadOnlyProperty(manager: cuckoo_manager, name: "readOnlyProperty")
        }
        
        var readWriteProperty: Cuckoo.ToBeStubbedProperty<Int> {
            return Cuckoo.ToBeStubbedProperty(manager: cuckoo_manager, name: "readWriteProperty")
        }
        
        var optionalProperty: Cuckoo.ToBeStubbedProperty<Int?> {
            return Cuckoo.ToBeStubbedProperty(manager: cuckoo_manager, name: "optionalProperty")
        }
        
        func noReturn() -> Cuckoo.StubNoReturnFunction<()> {
            return Cuckoo.StubNoReturnFunction(stub: cuckoo_manager.createStub("noReturn()", parameterMatchers: []))
        }
        
        func count<M1: Cuckoo.Matchable>(characters: M1) -> Cuckoo.StubFunction<(String), Int> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: characters) { $0 }]
            return Cuckoo.StubFunction(stub: cuckoo_manager.createStub("count(characters: String) -> Int", parameterMatchers: matchers))
        }
        
        func withThrows() -> Cuckoo.StubThrowingFunction<(), Int> {
            return Cuckoo.StubThrowingFunction(stub: cuckoo_manager.createStub("withThrows() throws -> Int", parameterMatchers: []))
        }
        
        func withNoReturnThrows() -> Cuckoo.StubNoReturnThrowingFunction<()> {
            return Cuckoo.StubNoReturnThrowingFunction(stub: cuckoo_manager.createStub("withNoReturnThrows() throws", parameterMatchers: []))
        }
        
        func withClosure<M1: Cuckoo.Matchable>(_ closure: M1) -> Cuckoo.StubFunction<((String) -> Int), Int> where M1.MatchedType == (String) -> Int {
            let matchers: [Cuckoo.ParameterMatcher<((String) -> Int)>] = [wrap(matchable: closure) { $0 }]
            return Cuckoo.StubFunction(stub: cuckoo_manager.createStub("withClosure(_: (String) -> Int) -> Int", parameterMatchers: matchers))
        }
        
        func withEscape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ a: M1, action closure: M2) -> Cuckoo.StubNoReturnFunction<(String, (String) -> Void)> where M1.MatchedType == String, M2.MatchedType == (String) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(String, (String) -> Void)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: closure) { $0.1 }]
            return Cuckoo.StubNoReturnFunction(stub: cuckoo_manager.createStub("withEscape(_: String, action: @escaping (String) -> Void)", parameterMatchers: matchers))
        }
        
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ a: M1, closure: M2) -> Cuckoo.StubNoReturnFunction<(String, ((String) -> Void)?)> where M1.MatchedType == String, M2.MatchedType == ((String) -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(String, ((String) -> Void)?)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: closure) { $0.1 }]
            return Cuckoo.StubNoReturnFunction(stub: cuckoo_manager.createStub("withOptionalClosure(_: String, closure: ((String) -> Void)?)", parameterMatchers: matchers))
        }
        
        func withLabelAndUnderscore<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(labelA a: M1, _ b: M2) -> Cuckoo.StubNoReturnFunction<(String, String)> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: b) { $0.1 }]
            return Cuckoo.StubNoReturnFunction(stub: cuckoo_manager.createStub("withLabelAndUnderscore(labelA: String, _: String)", parameterMatchers: matchers))
        }
    }
    
    struct __VerificationProxy_TestedProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = cuckoo_manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var readOnlyProperty: Cuckoo.VerifyReadOnlyProperty<String> {
            return Cuckoo.VerifyReadOnlyProperty(manager: cuckoo_manager, name: "readOnlyProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var readWriteProperty: Cuckoo.VerifyProperty<Int> {
            return Cuckoo.VerifyProperty(manager: cuckoo_manager, name: "readWriteProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var optionalProperty: Cuckoo.VerifyProperty<Int?> {
            return Cuckoo.VerifyProperty(manager: cuckoo_manager, name: "optionalProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func noReturn() -> Cuckoo.__DoNotUse<Void> {
            return cuckoo_manager.verify("noReturn()", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func count<M1: Cuckoo.Matchable>(characters: M1) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: characters) { $0 }]
            return cuckoo_manager.verify("count(characters: String) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withThrows() -> Cuckoo.__DoNotUse<Int> {
            return cuckoo_manager.verify("withThrows() throws -> Int", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withNoReturnThrows() -> Cuckoo.__DoNotUse<Void> {
            return cuckoo_manager.verify("withNoReturnThrows() throws", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withClosure<M1: Cuckoo.Matchable>(_ closure: M1) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == (String) -> Int {
            let matchers: [Cuckoo.ParameterMatcher<((String) -> Int)>] = [wrap(matchable: closure) { $0 }]
            return cuckoo_manager.verify("withClosure(_: (String) -> Int) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withEscape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ a: M1, action closure: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == (String) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(String, (String) -> Void)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: closure) { $0.1 }]
            return cuckoo_manager.verify("withEscape(_: String, action: @escaping (String) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == ((String) -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(String, ((String) -> Void)?)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: closure) { $0.1 }]
            return cuckoo_manager.verify("withOptionalClosure(_: String, closure: ((String) -> Void)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func withLabelAndUnderscore<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(labelA a: M1, _ b: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: a) { $0.0 }, wrap(matchable: b) { $0.1 }]
            return cuckoo_manager.verify("withLabelAndUnderscore(labelA: String, _: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
    }
}

class TestedProtocolStub: TestedProtocol {
    
    var readOnlyProperty: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    var readWriteProperty: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        set {
        }
    }
    
    var optionalProperty: Int? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int?).self)
        }
        set {
        }
    }
    
    func noReturn() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func count(characters: String) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    func withThrows() throws -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    func withNoReturnThrows() throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func withClosure(_ closure: (String) -> Int) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    func withEscape(_ a: String, action closure: @escaping (String) -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func withOptionalClosure(_ a: String, closure: ((String) -> Void)?) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func withLabelAndUnderscore(labelA a: String, _ b: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}
