//
//  TestedSubClass.swift
//  Cuckoo
//
//  Created by Arjan Duijzer on 17/02/2017.
//  Copyright © 2017 Brightify. All rights reserved.
//

class TestedSubclass: TestedClass, TestedProtocol {
    required override init() {
        super.init()
    }

    required init(test: String) {
        super.init()
    }

    required init(labelA a: String, _ b: String) {
        super.init()
    }

    init(notRequired: Bool) {
        super.init()
    }

    convenience init(convenient: Bool) {
        self.init(notRequired: convenient)
    }

    func withImplicitlyUnwrappedOptional(i: Int!) -> String {
        return ""
    }
    
    // Should not be conflicting in mocked class
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    override func withAsync() async -> Int {
        return 1
    }
    
    // Should not be conflicting in mocked class
    override func withThrows() throws -> Int {
        return 1
    }

    func withNamedTuple(tuple: (a: String, b: String)) -> Int {
        return 0
    }

    func subclassMethod() -> Int {
        return 0
    }
    
    func withOptionalClosureAndReturn(_ a: String, closure: ((String) -> Void)?) -> Int {
        return 1
    }
    
    func withClosureAndParam(_ a: String, closure: (String) -> Int) -> Int {
        return 0
    }
    
    func withMultClosures(closure: ((String)) -> Int, closureB: (String) -> Int, closureC: (String) -> Int) -> Int {
        return 0
    }
    
    func withThrowingClosure(closure: (String) throws -> String?) -> String? {
        return nil
    }
    
    func withThrowingClosureThrows(closure: (String) throws -> String?) throws -> String? {
        return nil
    }
    
    func withThrowingEscapingClosure(closure: @escaping (String) throws -> String?) -> String? {
        return nil
    }
    
    func withThrowingOptionalClosureThrows(closure: ((String) throws -> String?)?) throws -> String? {
        return nil
    }

    func methodWithParameter(_ param: String) -> String {
        return "b"
    }

    func methodWithParameter(_ param: Int) -> String {
        return "c"
    }

    func genericReturn() -> Dictionary<Int, Void> {
        return [:]
    }
}

class TestedSubSubClass: TestedSubclass {

    func subSubMethod() -> String? {
        return nil
    }
    
}
