//
//  NestedSubclassTests.swift
//  Cuckoo
//
//  Created by Tyler Thompson on 9/18/20.
//

import Foundation
import XCTest
import Cuckoo

class NestedSubclassTest: XCTestCase {

    private var mock: Nested.MockNestedTestedSubclass!

    override func setUp() {
        super.setUp()

        mock = Nested.MockNestedTestedSubclass()
    }

    func testReadOnlyProperty() {
        let mock = Nested.MockNestedTestedSubclass()

        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a")
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        verify(mock).readOnlyProperty.get()
    }

    func testReadOnlyOptionalProperty() {
        let mock = Nested.MockNestedTestedSubclass()

        stub(mock) { mock in
            when(mock.readOnlyOptionalProperty.get).thenReturn("a")
        }

        XCTAssertEqual(mock.readOnlyOptionalProperty, "a")
        verify(mock).readOnlyOptionalProperty.get()
    }

    func testOptionalReadOnlyPropertyIsNil() {
        let mock = Nested.MockNestedTestedSubclass()

        stub(mock) { mock in
            when(mock.readOnlyOptionalProperty.get).thenReturn(nil)
        }

        XCTAssertNil(mock.readOnlyOptionalProperty)
        verify(mock).readOnlyOptionalProperty.get()
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
        verify(mock).readWriteProperty.get()
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
        verify(mock).optionalProperty.get()
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
        func anyNestedClosure<IN1, IN2, OUT>() -> ParameterMatcher<((IN1) -> IN2) -> OUT> {
            return ParameterMatcher()
        }

        stub(mock) { mock in
            when(mock.withClosure(anyClosure())).then { $0("a") }
            when(mock.withClosureReturningVoid(anyClosure())).then { $0("a")() }
            when(mock.withClosureReturningInt(anyClosure())).then { $0("a")(1) }
            when(mock.withOptionalClosureAlone(anyClosure())).then { $0?("a")(1) ?? 1 }
            when(mock.withNestedClosure1(anyClosure())).then { $0("a")({ Int($0) ?? 1 }) }
            when(mock.withNestedClosure2(anyNestedClosure())).then { $0({ Int($0) ?? 1 })({ Int($0) ?? 1 }) }
        }

        XCTAssertEqual(mock.withClosure { _ in 1 }, 1)
        XCTAssertEqual(mock.withClosureReturningVoid {_ in { return 1 } }, 1)
        XCTAssertEqual(mock.withClosureReturningInt { _ in { _ in return 1 } }, 1)
        XCTAssertEqual(mock.withOptionalClosureAlone { _ in { _ in return 1 } }, 1)
        XCTAssertEqual(mock.withNestedClosure1 { _ in { _ in return 1 } }, 1)
        XCTAssertEqual(mock.withNestedClosure2 { _ in { _ in return 1 } }, 1)

        verify(mock).withClosure(anyClosure())
        verify(mock).withClosureReturningVoid(anyClosure())
        verify(mock).withClosureReturningInt(anyClosure())
        verify(mock).withOptionalClosureAlone(anyClosure())
        verify(mock).withNestedClosure1(anyClosure())
        verify(mock).withNestedClosure2(anyNestedClosure())
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
        mock.enableDefaultImplementation(Nested.NestedTestedSubclassStub())

        XCTAssertEqual(mock.callingCountCharactersMethodWithHello(), 0)
        verify(mock).callingCountCharactersMethodWithHello()
    }
}
