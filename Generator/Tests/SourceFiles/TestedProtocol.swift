//
//  TestedProtocol.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

protocol TestedProtocol {
    var readOnlyProperty: String { get }
    
    var readWriteProperty: Int { get set }
    
    var optionalProperty: Int? { get set }
    
    func noReturn()
    
    func countCharacters(test: String) -> Int
    
    func withThrows() throws -> Int
    
    func withNoReturnThrows() throws
    
    func withClosure(closure: String -> Int) -> Int
    
    func withNoescape(a: String, @noescape closure: String -> Void)
    
    func withOptionalClosure(a: String, closure: (String -> Void)?)
}