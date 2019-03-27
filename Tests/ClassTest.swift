//
//  ClassTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

extension TestedClass: Mocked {
    typealias MockType = MockTestedClass
}

class ClassTest: XCTestCase {

    private var mock: MockTestedClass!

    override func setUp() {
        super.setUp()

        mock = MockTestedClass()
    }

    func testReadOnlyPropertyWithMockCreator() {
        let mock = createMock(for: TestedClass.self) { builder, stub in
            when(stub.readOnlyProperty.get).thenReturn("a")

            return MockTestedClass()
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        _ = verify(mock).readOnlyProperty.get
    }

    func testReadOnlyProperty() {
        let mock = MockTestedClass()

        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a")
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        _ = verify(mock).readOnlyProperty.get
    }

    func testReadWriteProperty() {
        var called = false
        stub(mock) { mock in
            when(mock.readWriteProperty.get).thenReturn(1)
            when(mock.readWriteProperty.set(anyInt())).then { _ in called = true }
        }

        mock.readWriteProperty = 0

        XCTAssertEqual(mock.readWriteProperty, 1)
        XCTAssertTrue(called)
        _ = verify(mock).readWriteProperty.get
        verify(mock).readWriteProperty.set(0)
    }

    func testOptionalProperty() {
        var called = false
        stub(mock) { mock in
            when(mock.optionalProperty.get).thenReturn(nil)
            when(mock.optionalProperty.set(anyInt())).then { _ in called = true }
        }

        mock.optionalProperty = 0

        XCTAssertNil(mock.optionalProperty)
        XCTAssertTrue(called)
        _ = verify(mock).optionalProperty.get
        verify(mock).optionalProperty.set(equal(to: 0))
    }

    func testNoReturn() {
        var called = false
        stub(mock) { mock in
            when(mock.noReturn()).then { _ in called = true }
        }

        mock.noReturn()

        XCTAssertTrue(called)
        verify(mock).noReturn()
    }

    func testCountCharacters() {
        stub(mock) { mock in
            when(mock.count(characters: "a")).thenReturn(1)
        }

        XCTAssertEqual(mock.count(characters: "a"), 1)
        verify(mock).count(characters: "a")
    }

    func testWithThrows() {
        stub(mock) { mock in
            when(mock.withThrows()).thenThrow(TestError.unknown)
        }

        var catched = false
        do {
            _ = try mock.withThrows()
        } catch {
            catched = true
        }

        XCTAssertTrue(catched)
        verify(mock).withThrows()
    }

    func testWithNoReturnThrows() {
        stub(mock) { mock in
            when(mock.withNoReturnThrows()).thenThrow(TestError.unknown)
        }

        var catched = false
        do {
            try mock.withNoReturnThrows()
        } catch {
            catched = true
        }

        XCTAssertTrue(catched)
        verify(mock).withNoReturnThrows()
    }

    func testWithClosure() {
        stub(mock) { mock in
            when(mock.withClosure(anyClosure())).then { $0("a") }
        }

        XCTAssertEqual(mock.withClosure { _ in 1 }, 1)
        verify(mock).withClosure(anyClosure())
    }

    func testWithEscape() {
        var called = false
        stub(mock) { mock in
            when(mock.withEscape(anyString(), action: anyClosure())).then { text, closure in closure(text) }
        }

        mock.withEscape("a") { called = $0 == "a" }

        XCTAssertTrue(called)
        verify(mock).withEscape(anyString(), action: anyClosure())
    }

    func testWithOptionalClosure() {
        var called = false
        stub(mock) { mock in
            when(mock.withOptionalClosure(anyString(), closure: anyClosure())).then { text, closure in closure?(text)  }
        }

        mock.withOptionalClosure("a") { called = $0 == "a" }

        XCTAssertTrue(called)
        verify(mock).withOptionalClosure(anyString(), closure: anyClosure())
    }

    func testWithLabel() {
        var called = false
        stub(mock) { mock in
            when(mock.withLabelAndUnderscore(labelA: anyString(), anyString())).then { _ in called = true }
        }

        mock.withLabelAndUnderscore(labelA: "a", "b")
        XCTAssertTrue(called)
        verify(mock).withLabelAndUnderscore(labelA: anyString(), anyString())
    }

    func testCallingCountCharactersMethodWithHello() {
        stub(mock) { mock in
            when(mock.callingCountCharactersMethodWithHello()).thenCallRealImplementation()
            when(mock.count(characters: any())).thenReturn(0)
        }

        XCTAssertEqual(mock.callingCountCharactersMethodWithHello(), 0)
        verify(mock).callingCountCharactersMethodWithHello()
        verify(mock).count(characters: "Hello")
    }

    func testDefaultImplCall() {
        mock.enableDefaultImplementation(TestedClassStub())

        XCTAssertEqual(mock.callingCountCharactersMethodWithHello(), 0)
        verify(mock).callingCountCharactersMethodWithHello()
    }

    func testInout() {
        let mock = MockInoutMethodClass()
        stub(mock) { mock in
            when(mock.inoutko(param: anyInt())).then { param in
                print(param)
            }
        }

        var integer = 12
        mock.inoutko(param: &integer)
    }

    func testOptionals() {
        let mock = MockOptionalParamsClass()

        stub(mock) { mock in
            when(mock.clashingFunction(param1: Optional(1), param2: "Henlo Fren") as Cuckoo.ClassStubNoReturnFunction<(Int?, String)>).thenDoNothing()
            when(mock.clashingFunction(param1: Optional.none, param2: "Henlo Fren") as Cuckoo.ClassStubNoReturnFunction<(Int?, String)>).thenDoNothing()
            when(mock.clashingFunction(param1: anyInt(), param2: "What's the question?") as Cuckoo.ClassStubNoReturnFunction<(Int, String?)>).then {
                print("What's 6 times 9? \($0.0)")
            }
            when(mock.clashingFunction(param1: anyInt(), param2: isNil()) as Cuckoo.ClassStubNoReturnFunction<(Int, String?)>).then {
                print("What's 6 times 9? \($0.0)")
            }
            when(mock.function(param: "string")).thenDoNothing()
        }

        mock.clashingFunction(param1: Optional(1), param2: "Henlo Fren")
        mock.clashingFunction(param1: nil, param2: "Henlo Fren")
        mock.clashingFunction(param1: 42, param2: Optional("What's the question?"))

        _ = verify(mock).clashingFunction(param1: anyInt(), param2: "Henlo Fren") as Cuckoo.__DoNotUse<(Int?, String), Void>
        _ = verify(mock).clashingFunction(param1: isNil(), param2: "Henlo Fren") as Cuckoo.__DoNotUse<(Int?, String), Void>
        _ = verify(mock).clashingFunction(param1: 42, param2: "What's the question?") as Cuckoo.__DoNotUse<(Int, String?), Void>
    }

    func testClosureN() {
        let mock = MockClosureNClass()
        stub(mock) { mock in
            when(mock.f0(closure: anyClosure())).then { closure in
                closure()
            }
            when(mock.f1(closure: anyClosure())).then { closure in
                _ = closure("Hello")
            }
            when(mock.f2(closure: anyClosure())).then { closure in
                _ = closure("Cuckoo", 7)
            }
            when(mock.f3(closure: anyClosure())).then { closure in
                _ = closure("World", 1, true)
            }
            when(mock.f4(closure: anyClosure())).then { closure in
                _ = closure("Dude", 0, false, Optional(["Hello", "World"])) ?? ["defaultko"]
            }
            when(mock.f5(closure: anyClosure())).then { closure in
                _ = closure("How", 2, true, nil, Set([1, 2, 3]))
            }
            when(mock.f6(closure: anyClosure())).then { closure in
                _ = closure("Are", 5, true, nil, Set([1, 2, 3]), ())
            }
            when(mock.f7(closure: anyClosure())).then { closure in
                _ = closure("You", 13, false, nil, Set([1, 2]), (), ["hello": "world"])
            }
        }

        mock.f0(closure: { })
        mock.f1(closure: { $0 })
        mock.f2(closure: { $1 })
        mock.f3(closure: { $2 })
        mock.f4(closure: { $3 })
        mock.f5(closure: { $4 })
        mock.f6(closure: { $5 })
        mock.f7(closure: { $6 })

        verify(mock).f0(closure: anyClosure())
        verify(mock).f1(closure: anyClosure())
        verify(mock).f2(closure: anyClosure())
        verify(mock).f3(closure: anyClosure())
        verify(mock).f4(closure: anyClosure())
        verify(mock).f5(closure: anyClosure())
        verify(mock).f6(closure: anyClosure())
        verify(mock).f7(closure: anyClosure())
    }

    func testClosureNThrowing() {
        let mock = MockClosureNThrowingClass()
        stub(mock) { mock in
            when(mock.f0(closure: anyThrowingClosure())).then { closure in
                _ = try? closure()
            }
            when(mock.f1(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("Hello")
            }
            when(mock.f2(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("Cuckoo", 7)
            }
            when(mock.f3(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("World", 1, true)
            }
            when(mock.f4(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("Dude", 0, false, Optional(["Hello", "World"]))
            }
            when(mock.f5(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("How", 2, true, nil, Set([1, 2, 3]))
            }
            when(mock.f6(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("Are", 5, true, nil, Set([1, 2, 3]), ())
            }
            when(mock.f7(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("You", 13, false, nil, Set([1, 2]), (), ["hello": "world"])
            }
        }

        mock.f0(closure: { })
        mock.f1(closure: { $0 })
        mock.f2(closure: { $1 })
        mock.f3(closure: { $2 })
        mock.f4(closure: { $3 })
        mock.f5(closure: { $4 })
        mock.f6(closure: { $5 })
        mock.f7(closure: { $6 })

        verify(mock).f0(closure: anyThrowingClosure())
        verify(mock).f1(closure: anyThrowingClosure())
        verify(mock).f2(closure: anyThrowingClosure())
        verify(mock).f3(closure: anyThrowingClosure())
        verify(mock).f4(closure: anyThrowingClosure())
        verify(mock).f5(closure: anyThrowingClosure())
        verify(mock).f6(closure: anyThrowingClosure())
        verify(mock).f7(closure: anyThrowingClosure())
    }

    func testClosureNThrowingThrows() {
        let mock = MockClosureNThrowingThrowsClass()
        stub(mock) { mock in
            when(mock.f0(closure: anyThrowingClosure())).then { closure in
                try closure()
            }
            when(mock.f1(closure: anyThrowingClosure())).then { closure in
                _ = try closure("Hello")
            }
            when(mock.f2(closure: anyThrowingClosure())).then { closure in
                _ = try closure("Cuckoo", 7)
            }
            when(mock.f3(closure: anyThrowingClosure())).then { closure in
                _ = try closure("World", 1, true)
            }
            when(mock.f4(closure: anyThrowingClosure())).then { closure in
                _ = try closure("Dude", 0, false, Optional(["Hello", "World"])) ?? ["defaultko"]
            }
            when(mock.f5(closure: anyThrowingClosure())).then { closure in
                _ = try closure("How", 2, true, nil, Set([1, 2, 3]))
            }
            when(mock.f6(closure: anyThrowingClosure())).then { closure in
                _ = try closure("Are", 5, true, nil, Set([1, 2, 3]), ())
            }
            when(mock.f7(closure: anyThrowingClosure())).then { closure in
                _ = try closure("You", 13, false, nil, Set([1, 2]), (), ["hello": "world"])
            }
        }

        struct Erre: Error {

        }

        XCTAssertThrowsError(try mock.f0(closure: { throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f1(closure: { _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f2(closure: { _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f3(closure: { _, _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f4(closure: { _, _, _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f5(closure: { _, _, _, _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f6(closure: { _, _, _, _, _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f7(closure: { _, _, _, _, _, _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())

        verify(mock).f0(closure: anyThrowingClosure())
        verify(mock).f1(closure: anyThrowingClosure())
        verify(mock).f2(closure: anyThrowingClosure())
        verify(mock).f3(closure: anyThrowingClosure())
        verify(mock).f4(closure: anyThrowingClosure())
        verify(mock).f5(closure: anyThrowingClosure())
        verify(mock).f6(closure: anyThrowingClosure())
        verify(mock).f7(closure: anyThrowingClosure())
    }

    func testClosureNRehrowing() {
        let mock = MockClosureNRethrowingClass()
        stub(mock) { mock in
            when(mock.f0(closure: anyThrowingClosure())).then { closure in
                _ = try closure()
            }
            when(mock.f1(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("Hello")
            }
            when(mock.f2(closure: anyThrowingClosure())).then { closure in
                _ = try closure("Cuckoo", 7)
            }
            when(mock.f3(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("World", 1, true)
            }
            when(mock.f4(closure: anyThrowingClosure())).then { closure in
                _ = try closure("Dude", 0, false, Optional(["Hello", "World"])) ?? ["defaultko"]
            }
            when(mock.f5(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("How", 2, true, nil, Set([1, 2, 3]))
            }
            when(mock.f6(closure: anyThrowingClosure())).then { closure in
                _ = try closure("Are", 5, true, nil, Set([1, 2, 3]), ())
            }
            when(mock.f7(closure: anyThrowingClosure())).then { closure in
                _ = try? closure("You", 13, false, nil, Set([1, 2]), (), ["hello": "world"])
            }
        }

        // testing that when the closure is not throwing, no need to call it with `try`
        mock.f0(closure: { })
        mock.f1(closure: { $0 })
        mock.f2(closure: { $1 })
        mock.f3(closure: { $2 })
        mock.f4(closure: { $3 })
        mock.f5(closure: { $4 })
        mock.f6(closure: { $5 })
        mock.f7(closure: { $6 })

        // testing the cases where stub calls closure with `try`
        XCTAssertThrowsError(try mock.f0(closure: { throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f2(closure: { _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f4(closure: { _, _, _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())
        XCTAssertThrowsError(try mock.f6(closure: { _, _, _, _, _, _ in throw TestError.unknown }), "Expected thrown TestError.", TestError.errorCheck())

        verify(mock, times(2)).f0(closure: anyThrowingClosure())
        verify(mock).f1(closure: anyThrowingClosure())
        verify(mock, times(2)).f2(closure: anyThrowingClosure())
        verify(mock).f3(closure: anyThrowingClosure())
        verify(mock, times(2)).f4(closure: anyThrowingClosure())
        verify(mock).f5(closure: anyThrowingClosure())
        verify(mock, times(2)).f6(closure: anyThrowingClosure())
        verify(mock).f7(closure: anyThrowingClosure())
    }

    private enum TestError: Error {
        case unknown

        static func errorCheck(file: StaticString = #file, line: UInt = #line) -> (Error) -> Void {
            return {
                if $0 is TestError {
                } else {
                    XCTFail("Expected TestError, got: \(type(of: $0))(\($0.localizedDescription))", file: file, line: line)
                }
            }
        }
    }
}
