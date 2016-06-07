//
//  SelfDescribingTest.swift
//  Cuckoo
//
//  Created by Tadeáš Kříž on 07/06/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

@testable import Cuckoo
import XCTest

class SelfDescribingTest: XCTestCase {

    var stringDescription: StringDescription!

    override func setUp() {
        super.setUp()

        stringDescription = StringDescription()
    }

    func testOptional() {
        let nilValue: String? = nil
        let stringValue: String? = "this is not nil"

        nilValue.describeTo(stringDescription)
        stringDescription.append(character: " ")
        stringValue.describeTo(stringDescription)

        XCTAssertEqual(stringDescription.description, "nil \"this is not nil\"")
    }

    func testString() {
        let value: String = "hello world"

        value.describeTo(stringDescription)

        XCTAssertEqual(stringDescription.description, "\"hello world\"")
    }

    func testBool() {
        let trueValue: Bool = true
        let falseValue: Bool = false

        trueValue.describeTo(stringDescription)
        stringDescription.append(character: " ")
        falseValue.describeTo(stringDescription)

        XCTAssertEqual(stringDescription.description, "<true> <false>")
    }

    func testInt() {
        let value: Int = 33

        value.describeTo(stringDescription)

        XCTAssertEqual(stringDescription.description, "<33>")
    }

    func testFloat() {
        let value: Float = 12.33

        value.describeTo(stringDescription)

        XCTAssertEqual(stringDescription.description, "<12.33>")
    }

    func testDouble() {
        let value: Double = 12.33

        value.describeTo(stringDescription)

        XCTAssertEqual(stringDescription.description, "<12.33>")
    }
}