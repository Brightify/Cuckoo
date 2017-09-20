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

    required init(labelA a: String, _ b: String) {
        super.init()
    }

    // Should not be conflicting in mocked class
    override func withThrows() throws -> Int {
        return 1
    }

    func subclassMethod() -> Int {
        return 0
    }
    
    func withOptionalClosureAndReturn(_ a: String, closure: ((String) -> Void)?) -> Int {
        return 1
    }
    
    func withClosureAndParam(_ a: String, closure: ((String)) -> Int) -> Int {
        return 0
    }
    
    func withMultClosures(closure: ((String)) -> Int, closureB: ((String)) -> Int, closureC: ((String)) -> Int) -> Int {
        return 0
    }
    
    func withThrowingClosure(closure: ((String)) throws -> String?) -> String? {
        return nil
    }
    
    func withThrowingClosureThrows(closure: ((String)) throws -> String?) throws -> String? {
        return nil
    }
    
    func withThrowingEscapingClosure(closure: @escaping ((String)) throws -> String?) -> String? {
        return nil
    }
    
    func withThrowingOptionalClosureThrows(closure: (((String)) throws -> String?)?) throws -> String? {
        return nil
    }
}
