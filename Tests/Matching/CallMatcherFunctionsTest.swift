//
//  CallMatcherFunctionsTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class CallMatcherFunctionsTest: XCTestCase {
    private let tests: [(message: String, matcher: CallMatcher, argument: Int, expected: Bool)] = [
        ("times(2) - true", times(2), 2, true),
        ("times(2) - false", times(2), 3, false),
        ("never - true", never(), 0, true),
        ("never - false", never(), 1, false),
        ("atLeastOnce - 2", atLeastOnce(), 2, true),
        ("atLeastOnce - 1", atLeastOnce(), 1, true),
        ("atLeastOnce - 0", atLeastOnce(), 0, false),
        ("atLeast(2) - 3", atLeast(2), 3, true),
        ("atLeast(2) - 2", atLeast(2), 2, true),
        ("atLeast(2) - 1", atLeast(2), 1, false),
        ("atMost(2) - 1", atMost(2), 1, true),
        ("atMost(2) - 2", atMost(2), 2, true),
        ("atMost(2) - 3", atMost(2), 3, false)
    ]
    
    func testParameterizedTests() {
        let call: StubCall = ConcreteStubCall(method: "A", parameters: Void())
        tests.forEach { test in
            let calls = (0..<test.argument).map { _ in call }
            
            XCTAssertEqual(test.matcher.matches(calls), test.expected, test.message)
        }
    }
}
