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
}
