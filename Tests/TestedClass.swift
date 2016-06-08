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
        return ""
    }
    
    lazy var readWriteProperty: Int = 0
    
    func noParameter() {
    
    }
    
    func countCharacters(test: String) -> Int {
        return test.characters.count
    }
    
    func withReturn() -> String {
        return "yello world"
    }
    
    func withThrows() throws {
        
    }
    
    func withClosure(closure: String -> Int) {
        closure("hello")
    }
    
    func withMultipleParameters(a: String, b: Int, c: Float) {
        
    }
    
    func withNoescape(a: String, @noescape closure: String -> Void) {
        closure(a)
    }
    
    func withOptionalClosure(a: String, closure: (String -> Void)?) {
        closure?(a)
    }
}