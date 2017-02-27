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
    
    func withClosureAndParam(_ a: String, closure:(String) -> Int) -> Int
    
    func withEscape(_ a: String, action closure: @escaping (String) -> Void)
    
    func withOptionalClosure(_ a: String, closure: ((String) -> Void)?)
    
    func withOptionalClosureAndReturn(_ a: String, closure: ((String) -> Void)?) -> Int

    func withLabelAndUnderscore(labelA a: String, _ b: String)

    func withNamedTuple(tuple: (a: String, b: String)) -> Int

    func withImplicitlyUnwrappedOptional(i: Int!) -> String

    init()

    init(labelA a: String, _ b: String)

    func protocolMethod() -> String

    func methodWithParameter(_ param: String) -> String
}

extension TestedProtocol {

    func protocolMethod() -> String {
        return "a"
    }

}
