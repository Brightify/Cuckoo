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

    var closureProperty: ((String) -> Int) -> () { get set }

    var closureWithArgumentNameProperty: (_ i: (_ j: String) -> Int) -> () { get set }

    var closureWithArgumentNameMultilineProperty: (
        _ i   : (
            _ j
            : Int
        ) -> String
    ) -> () { get set }

    var closureWithComplexArgumentNameProperty: (_ i_iI0: (_ j_jJ0: String) -> Int) -> () { get set }

    var closureWithComplexArgumentNameMultilineProperty: (
        _ i_iI0   : (
            _ j_jJ0
            : Int
        ) -> String
    ) -> () { get set }

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

    // Don't fix the whitespace in the return type.
    // It makes sure that inconsistent whitespace doesn't generate duplicate mock methods.
    func genericReturn() -> Dictionary<Int,Void>

    // Don't fix method line breaks.
    // This method is for testing multiline argument.
    func multilineMethod(
        completion: @escaping (
            _ bar: Int,
            _ baz: Int,
            _ qux: Int
        ) -> Void
    )

    @available(iOS 13.0, *)
    @available(tvOS 13.0, *)
    @available(macOS 10.15, *)
    func asyncMethod() async
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
