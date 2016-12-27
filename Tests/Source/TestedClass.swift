//
//  TestedClass.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 09/02/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

class TestedClass {
    
    let constant: Float = 0.0
    
    var readOnlyProperty: String {
        return "a"
    }
    
    lazy var readWriteProperty: Int = 0
    
    lazy var optionalProperty: Int? = 0

    func noReturn() {
    }
    
    func count(characters: String) -> Int {
        return characters.characters.count
    }
    
    func withThrows() throws -> Int {
        return 0
    }
    
    func withNoReturnThrows() throws {
    }
    
    func withClosure(_ closure: (String) -> Int) -> Int {
        return closure("hello")
    }
    
    func withEscape(_ a: String, action closure: @escaping (String) -> Void) {
        closure(a)
    }
    
    func withOptionalClosure(_ a: String, closure: ((String) -> Void)?) {
        closure?(a)
    }

    func withLabelAndUnderscore(labelA a: String, _ b: String) {
    }

    // How to test for the absence of all these?
    private func thisFunctionShouldNotBeMocked1() {
    }

    fileprivate func thisFunctionShouldNotBeMocked2() {
    }

    private var notMocked1: Int?
    fileprivate var notMocked2: Int?
}

private class ThisClassShouldNotBeMocked1 {
    var property: Int?
}

fileprivate class ThisClassShouldNotBeMocked2 {
    var property: Int?
    // How to test that the expected output is generated??
    func withTwoDefaultConstructedValues(value1: Int = Int(10), value2: Int = Int(10)) {
    }

    // How to test that the expected output is generated??
    func withTwoDefaultConstructedValues(_ value3: Int = Int(10), value4: Int = Int(10)) {
    }
}
