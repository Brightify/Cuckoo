//
//  TestedClass.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 09/02/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

#warning("TODO: Create a new library and move this file to the library to ensure the use case is the same as our users'")
import class Foundation.NSArray ;import Foundation

@available(iOS 42.0, *)
protocol UnavailableProtocol { }

@available(swift 4.0)
class TestedClass {

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

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withAsync() async -> Int {
        return 0
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withNoReturnAsync() async {
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withAsyncThrows() async throws -> Int {
        return 0
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withNoReturnAsyncThrows() async throws {
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withAsyncClosure(closure: (String) async -> String?) -> String? {
        return nil
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withAsyncClosureAsync(closure: (String) async -> String?) async -> String? {
        return nil
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withAsyncEscapingClosure(closure: @escaping (String) async -> String?) -> String? {
        return nil
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func withAsyncOptionalClosureAsync(closure: ((String) async -> String?)?) async -> String? {
        return nil
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

private class ThisClassShouldNotBeMocked1 {
    var property: Int?
}

open class OpenTestedClass {

    let constant = 1

    open func printConstant() {
        print(constant)
    }
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

// Notice the subtle difference, this class is public. The generated code does not compile.
public class PublicTestedClass {
    let constant: Float = 0.0

    var readOnlyProperty: String {
        return "a"
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

    func withEscape(_ a: String, action closure: @escaping (String) -> Void) {
        closure(a)
    }

    func withOptionalClosure(_ a: String, closure: ((String) -> Void)?) {
        closure?(a)
    }

    func withLabelAndUnderscore(labelA a: String, _ b: String) {
    }
}

public class PublicPublicTestedClass {
    public let constant: Float = 0.0

    public var readOnlyProperty: String {
        return "a"
    }

    public lazy var readWriteProperty: Int = 0

    public lazy var optionalProperty: Int? = 0

    public func noReturn() {
    }

    public func count(characters: String) -> Int {
        return characters.count
    }

    public func withThrows() throws -> Int {
        return 0
    }

    public func withNoReturnThrows() throws {
    }

    public func withClosure(_ closure: (String) -> Int) -> Int {
        return closure("hello")
    }

    public func withEscape(_ a: String, action closure: @escaping (String) -> Void) {
        closure(a)
    }

    public func withOptionalClosure(_ a: String, closure: ((String) -> Void)?) {
        closure?(a)
    }

    public func withLabelAndUnderscore(labelA a: String, _ b: String) {
    }
}

class ClassWithInnerEnum {
    enum InnerEnum {
        case foo
        case bar
    }
}

class ClassUsingInnerEnum {
    func doFoo() -> ClassWithInnerEnum.InnerEnum {
        return .foo
    }

    func doFooOpt() -> ClassWithInnerEnum.InnerEnum? {
        return .foo
    }
}

final class FinalClass {
    var shouldBeIgnoredByCuckoo = true
}

protocol GenericFunctionProtocol {
    func method<T>(param: T) where T: CustomStringConvertible, T: StringProtocol
}

class OptionalParamsClass {
    var implicitOptionalProperty: Int!

    func function(param: String?) { }

    func functionImplicit(param: String!) { }

    func functionClosure(param: ((String?) -> Void)?) { }

    // the next two methods are exactly the same except for parameter types
    // this is not ambiguous for Swift, however, mocking this in a way so
    // that the stubbing and verifying calls wouldn't be ambiguous would require
    // some serious amount of hacks, so we decided to postpone this feature for now
    // see `clashingFunction` calls in tests to see how to disambiguate if you're ever
    // in need of two almost identical methods
    func clashingFunction(param1: Int?, param2: String) { }

    func clashingFunction(param1: Int, param2: String?) { }
}

public class InternalFieldsInPublicClass {
    internal var field: Int? = nil

    private(set) var privateSetField: Int? = nil

    internal func function() { }
}

#warning("TODO: When this file is moved to a separate library, uncomment and test this code compiles.")
//public class PublicClassWithInternalFieldsUsingPublicType {
//    internal var internalField: InternalType = InternalType()
//    var internalField2: InternalType = InternalType()
//    func internalFunc(internalType: InternalType) {
//    }
//
//    internal var internalField3: PublicType = PublicType()
//    var internalField4: PublicType = PublicType()
//    func internalFunc(publicType: PublicType) {
//    }
//}
//class InternalType {
//}
//public class PublicType {
//}

class FinalFields {
    final var field: Int? = nil

    final func function() { }
}

class InoutMethodClass {
    func inoutko(param: inout Int) { }

    func inoutkoMultiple(param1: inout Int, param2: inout String, param3: Void) { }

    func inoutkoClosure(param: (inout Int) -> Void) { }
}

class ClosureNClass {
    func f0(closure: () -> Void) { }

    func f1(closure: (String) -> String) { }

    func f2(closure: (String, Int) -> Int) { }

    func f3(closure: (String, Int, Bool) -> Bool) { }

    func f4(closure: (String, Int, Bool, [String]?) -> [String]?) { }

    func f5(closure: (String, Int, Bool, [String]?, Set<Int>) -> Set<Int>) { }

    func f6(closure: (String, Int, Bool, [String]?, Set<Int>, Void) -> Void) { }

    func f7(closure: (String, Int, Bool, [String]?, Set<Int>, Void, [String: String]) -> [String: String]) { }
}

class ClosureNThrowingClass {
    func f0(closure: () throws -> Void) { }

    func f1(closure: (String) throws -> String) { }

    func f2(closure: (String, Int) throws -> Int) { }

    func f3(closure: (String, Int, Bool) throws -> Bool) { }

    func f4(closure: (String, Int, Bool, [String]?) throws -> [String]?) { }

    func f5(closure: (String, Int, Bool, [String]?, Set<Int>) throws -> Set<Int>) { }

    func f6(closure: (String, Int, Bool, [String]?, Set<Int>, Void) throws -> Void) { }

    func f7(closure: (String, Int, Bool, [String]?, Set<Int>, Void, [String: String]) throws -> [String: String]) { }
}

class ClosureNThrowingThrowsClass {
    func f0(closure: () throws -> Void) throws { }

    func f1(closure: (String) throws -> String) throws { }

    func f2(closure: (String, Int) throws -> Int) throws { }

    func f3(closure: (String, Int, Bool) throws -> Bool) throws { }

    func f4(closure: (String, Int, Bool, [String]?) throws -> [String]?) throws { }

    func f5(closure: (String, Int, Bool, [String]?, Set<Int>) throws -> Set<Int>) throws { }

    func f6(closure: (String, Int, Bool, [String]?, Set<Int>, Void) throws -> Void) throws { }

    func f7(closure: (String, Int, Bool, [String]?, Set<Int>, Void, [String: String]) throws -> [String: String]) throws { }
}

class ClosureNRethrowingClass {
    func f0(closure: () throws -> Void) rethrows { }

    func f1(closure: (String) throws -> String) rethrows { }

    func f2(closure: (String, Int) throws -> Int) rethrows { }

    func f3(closure: (String, Int, Bool) throws -> Bool) rethrows { }

    func f4(closure: (String, Int, Bool, [String]?) throws -> [String]?) rethrows { }

    func f5(closure: (String, Int, Bool, [String]?, Set<Int>) throws -> Set<Int>) rethrows { }

    func f6(closure: (String, Int, Bool, [String]?, Set<Int>, Void) throws -> Void) rethrows { }

    func f7(closure: (String, Int, Bool, [String]?, Set<Int>, Void, [String: String]) throws -> [String: String]) rethrows { }
}

class TypeIsRightClass {
    var stringo = "my man"
    var stringyStringo = String("my man")
    var optionallyStringo = "my man" as String?
    var floatyNoPointy = 0 as Float
    var doublySo = 0.123
    var negative = -1250
    var zero = 0
    var genericClass = GenericClass<Int, Int, Int>(theT: 1, theU: 2, theV: 3)
    var genericClassAs = GenericClass(theT: 1, theU: 2, theV: 3) as GenericClass<Int, Int, Int>
    var array = [] as [String]
    var boolNo = false
    var boolYes = true
    var boolMaybeYes = true as Bool?
    var largeInty = 1_234_567
}

class ConvenienceMatchersAmbiguer {
    func arrays(array a: [Int], array b: [String], array c: [Bool]) { }

    // The methods' names are identical to find out ambiguity immediately if introduced.
    func a(a: String) -> Bool { return true }
    func a(a: [Int]) -> Bool { return true }
    func a(a: [String]) -> Bool { return true }
    func a(a: [Bool]) -> Bool { return true }
    func a(a: [Int: Bool]) -> Bool { return true }
    func a(a: [String: Bool]) -> Bool { return true }
    func a(a: Set<String>) -> Bool { return true }
    func a(a: Set<Bool>) -> Bool { return true }
}
