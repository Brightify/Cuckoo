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
    private let tests: [(message: String, value: SelfDescribing, expected: String)] = [
        ("optional with nil", nil as String?, "nil"),
        ("optional with value", "this is not nil" as String?, "\"this is not nil\""),
        ("string", "hello world", "\"hello world\""),
        ("bool with true", true, "<true>"),
        ("bool with false", false, "<false>"),
        ("int", 33, "<33>"),
        ("float", Float(12.33), "<12.33>"),
        ("double", Double(12.33), "<12.33>")
    ]

    func testParameterizedTests() {
        tests.forEach { test in
            let description = Description()
            
            test.value.describeTo(description)
            
            XCTAssertEqual(description.description, test.expected, test.message)
        }
    }
}