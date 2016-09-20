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
    
    func count(characters: String) -> Int
    
    func withThrows() throws -> Int
    
    func withNoReturnThrows() throws
    
    func withClosure(_ closure: (String) -> Int) -> Int
    
    func withEscape(_ a: String, action closure: @escaping (String) -> Void)
    
    func withOptionalClosure(_ a: String, closure: ((String) -> Void)?)

    func withLabelAndUnderscore(labelA a: String, _ b: String)
}
