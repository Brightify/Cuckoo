//
//  NestedInNestedClass.swift
//  Cuckoo
//
//  Created by Tyler Thompson on 9/18/20.
//

import Foundation
@available(swift 4.0)
class Nested {
    class NestedTestedSubclass: TestedClass { }
    
    private class ThisClassShouldNotBeMocked3 {
        var property: Int?
    }
    
    class NestedTestedClass {

        let constant: Float = 0.0

        private(set) var privateSetProperty: Int = 0

        var readOnlyProperty: String {
            return "a"
        }

        var readOnlyOptionalProperty: String? {
            return "a"
        }

        @available(iOS 42.0, *)
        var unavailableProperty: UnavailableProtocol? {
            return nil
        }

        lazy var readWriteProperty: Int = 0

        lazy var optionalProperty: Int? = 0

        func noReturn() {
        }

        func count(characters: String) -> Int {
            return characters.count
        }

        func withThrows() throws -> Int {
            return 0
        }

        func withNoReturnThrows() throws {
        }

        func withClosure(_ closure: (String) -> Int) -> Int {
            return closure("hello")
        }

        func withClosureReturningVoid(_ closure: (String) -> () -> Int) -> Int {
            return closure("hello")()
        }

        func withClosureReturningInt(_ closure: (String) -> (Int) -> Int) -> Int {
            return closure("hello")(3)
        }

        func withOptionalClosureAlone(_ closure: ((String) -> (Int) -> Int)?) -> Int {
            return (closure?("hello") ?? { $0 })(3)
        }

        func withNestedClosure1(_ closure: (String) -> ((String) -> Int) -> Int) -> Int {
            return closure("hello")({ Int($0) ?? 0 })
        }

        func withNestedClosure2(_ closure: ((String) -> Int) -> ((String) -> Int) -> Int) -> Int {
            return closure({ Int($0) ?? 0 })({ Int($0) ?? 0 })
        }

        func withEscape(_ a: String, action closure: @escaping (String) -> Void) {
            closure(a)
        }

        func withOptionalClosure(_ a: String, closure: ((String) -> Void)?) {
            closure?(a)
        }

        func empty(_: String) {
            // hello there
        }

        func withLabelAndUnderscore(labelA a: String, _ b: String) {
        }

        func callingCountCharactersMethodWithHello() -> Int {
            return count(characters: "Hello")
        }

        // How to test for the absence of all these?
        private func thisFunctionShouldNotBeMocked1() {
        }

        fileprivate func thisFunctionShouldNotBeMocked2() {
        }

        private var notMocked1: Int?
        fileprivate var notMocked2: Int?

        deinit {

        }
    }
}
