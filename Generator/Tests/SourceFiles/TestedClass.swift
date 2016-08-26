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
    
    func countCharacters(test: String) -> Int {
        return test.characters.count
    }
    
    func withThrows() throws -> Int {
        return 0
    }
    
    func withNoReturnThrows() throws {
        
    }
    
    func withClosure(closure: String -> Int) -> Int {
        return closure("hello")
    }
    
    func withNoescape(a: String, @noescape closure: String -> Void) {
        closure(a)
    }
    
    func withOptionalClosure(a: String, closure: (String -> Void)?) {
        closure?(a)
    }
}
