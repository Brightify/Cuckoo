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
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withAsync() async -> Int
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withNoReturnAsync() async
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withAsyncThrows() async throws -> Int
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withNoReturnAsyncThrows() async throws
    
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

    // Don't fix the whitespace in the return type.
    // It makes sure that inconsistent whitespace doesn't generate duplicate mock methods.
    func genericReturn() -> Dictionary<Int,Void>
}

extension TestedProtocol {

    func protocolMethod() -> String {
        return "a"
    }

}

protocol EmptyLabelProtocol {
    associatedtype T

    func empty(_: String)

    func empty(_: String) -> Int

    func empty(_: T) -> T
}

protocol OnlyLabelProtocol {
    func empty(_: String)

    func some(some: Int)

    func double(here there: Bool)
}

class OnlyLabelClass: OnlyLabelProtocol {
    func empty(_ mine: String) {
    }

    func some(some none: Int) {
    }

    func double(here notInHere: Bool) {
    }
}

public protocol PublicoProtocolo {
    associatedtype InternaloTypo

    var stringoStar: String { get set }

    init(hola: String)

    func internalMethod()
}
