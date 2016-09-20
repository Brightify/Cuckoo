//
//  NoImplStubTest.swift
//  Cuckoo
//
//  Created by Tadeáš Kříž on 20/09/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class NoImplStubTest: XCTestCase {

    private var stub: TestedClassStub!

    override func setUp() {
        super.setUp()

        stub = TestedClassStub()
    }

    func testReadOnlyProperty() {
        XCTAssertEqual(stub.readOnlyProperty, "")
    }

    func testReadWriteProperty() {
        XCTAssertEqual(stub.readWriteProperty, 0)
    }

    func testOptionalProperty() {
        XCTAssertNil(stub.optionalProperty)
    }

    func testArrayProperty() {
        XCTAssertEqual(stub.arrayProperty, [])
    }

    func testSetProperty() {
        XCTAssertEqual(stub.setProperty, [])
    }

    func testDictionaryProperty() {
        XCTAssertEqual(stub.dictionaryProperty, [:])
    }

    func testNoReturn() {
        print(stub.noReturn())
    }

    func testCountCharacters() {
        XCTAssertEqual(stub.countCharacters("a"), 0)
    }

    func testWithThrows() {
        do {
            try XCTAssertEqual(stub.withThrows(), 0)
        } catch {
            XCTFail("Can't throw!")
        }
    }

    func testWithNoReturnThrows() {
        do {
            try print(stub.withNoReturnThrows())
        } catch {
            XCTFail("Can't throw!")
        }
    }

    func testWithClosure() {
        XCTAssertEqual(stub.withClosure { _ in 1 }, 0)
    }

    func testWithNoescape() {
        print(stub.withNoescape("a") { _ in 1 })
    }

    func testWithOptionalClosure() {
        print(stub.withOptionalClosure("a") { _ in 1 })
    }

    func testWithLabel() {
        print(stub.withLabel(labelA: "a"))
    }

    private enum TestError: ErrorType {
        case Unknown
    }
}
