//
//  DescriptionTest.swift
//  Cuckoo
//
//  Created by Tadeáš Kříž on 07/06/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

@testable import Cuckoo
import XCTest

class DescriptionTest: XCTestCase {
    private let tests: [(message: String, appendTo: (Description) -> (), expected: String)] = [
        ("append text", { $0.append(text: "hello world") }, "hello world"),
        ("append multiple texts in row", { $0.append(text: "a").append(text: "b").append(text: "c") }, "abc"),
        ("append description of SelfDescribing", { $0.append(descriptionOf: 10)} , "<10>"),
        ("append value of type SelfDescribing", { $0.append(value: 10) }, "<10>"),
        ("append value of type Any", { $0.append(value: X()) }, "X")
    ]
    
    func testParameterizedTests() {
        tests.forEach { test in
            let description = Description()
            
            test.appendTo(description)
            
            XCTAssertEqual(description.description, test.expected, test.message)
        }
    }
    
    private class X: CustomStringConvertible {
        private var description = "X"
    }
}