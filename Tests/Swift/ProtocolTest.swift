//
//  ProtocolTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class ProtocolTest: XCTestCase {

    private var mock: MockTestedProtocol!

    override func setUp() {
        super.setUp()

        mock = MockTestedProtocol()
    }

    func testReadOnlyProperty() {
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a")
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        verify(mock).readOnlyProperty.get()
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

    func testThrowingProperty() {
        stub(mock) { mock in
            when(mock.throwsProperty.get).thenReturn(5)
        }

        XCTAssertEqual(try mock.throwsProperty, 5)
        verify(mock).throwsProperty.get()

        clearInvocations(mock)

        stub(mock) { mock in
            when(mock.throwsProperty.get).thenThrow(TestError.unknown)
        }

        XCTAssertThrowsError(try mock.throwsProperty)

        verify(mock).throwsProperty.get()
    }

    func testAsyncProperty() async {
        stub(mock) { mock in
            when(mock.asyncProperty.get).thenReturn(5)
        }

        let result = await mock.asyncProperty
        XCTAssertEqual(result, 5)
        verify(mock).asyncProperty.get()
    }

    func testAsyncThrowingProperty() async {
        stub(mock) { mock in
            when(mock.asyncThrowsProperty.get).thenReturn(5)
        }

        let result = try! await mock.asyncThrowsProperty
        XCTAssertEqual(result, 5)
        verify(mock).asyncThrowsProperty.get()

        clearInvocations(mock)

        stub(mock) { mock in
            when(mock.asyncThrowsProperty.get).thenThrow(TestError.unknown)
        }

        var threw = false
        do {
            _ = try await mock.asyncThrowsProperty
        } catch {
            threw = true
        }

        XCTAssertTrue(threw)
        verify(mock).asyncThrowsProperty.get()
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

    func testWithImplicitlyUnwrappedOptional() {
        stub(mock) { mock in
            when(mock.withImplicitlyUnwrappedOptional(i: anyInt())).thenReturn("test")
        }

        XCTAssertEqual(mock.withImplicitlyUnwrappedOptional(i: 5), "test")
        verify(mock).withImplicitlyUnwrappedOptional(i: equal(to: 5))
    }

    func testEmptyLabels() {
        let mock = MockEmptyLabelProtocol<Bool>()
        stub(mock) { mock in
            when(mock.empty(anyString())).thenReturn(420)
            when(mock.empty(anyString())).then { print("OK: \($0)") }
            when(mock.empty(any())).thenReturn(true)
        }

        XCTAssertEqual(mock.empty("hello there"), 420)
        mock.empty("here") as Void
        XCTAssertTrue(mock.empty(false))

        // the calls are ambiguous if we do not specify the input and output types
        _ = verify(mock).empty(anyString()) as __DoNotUse<String, Int>
        _ = verify(mock).empty(anyString()) as __DoNotUse<String, Void>
        _ = verify(mock).empty(any()) as __DoNotUse<Bool, Bool>
    }

    private enum TestError: Error {
        case unknown
    }
}
