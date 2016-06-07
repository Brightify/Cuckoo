//
//  DescriptionTest.swift
//  Cuckoo
//
//  Created by Tadeáš Kříž on 07/06/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

@testable import Cuckoo
import XCTest

class StringDescriptionTest: XCTestCase {

    func testAppendingText() {
        let description = StringDescription()

        description.append(text: "hello world")

        XCTAssertEqual(description.description, "hello world")

        description.append(text: "!!!")

        XCTAssertEqual(description.description, "hello world!!!")

        description.append(text: "").append(text: " ").append(text: "a").append(text: " ").append(text: "bcd")

        XCTAssertEqual(description.description, "hello world!!! a bcd")
    }

    func testAppendingCharacters() {
        let description = StringDescription()

        description.append(character: "a")

        XCTAssertEqual(description.description, "a")

        description.append(character: " ").append(character: "b").append(character: "c")

        XCTAssertEqual(description.description, "a bc")
    }
}