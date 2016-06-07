//
//  MatcherDescriptionsTest.swift
//  Cuckoo
//
//  Created by Tadeáš Kříž on 07/06/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

@testable import Cuckoo
import XCTest

class MatcherDescriptionsTest: XCTestCase {

    var stringDescription: StringDescription!

    override func setUp() {
        super.setUp()

        stringDescription = StringDescription()
    }

    func testEqualTo() {
        equalTo(10).describeTo(stringDescription)
        equalTo(10).describeMismatch(20, to: stringDescription)

        XCTAssertEqual(stringDescription.description, "Expected to be equal to <10> was <20>")
    }

    func testCalledTimes() {
        times(10).describeTo(stringDescription)
        times(10).describeMismatch([], to: stringDescription)

        XCTAssertEqual(stringDescription.description, "Expected to be called <10> times was called <0> times")
    }

    func testCalledAtLest() {
        atLeast(10).describeTo(stringDescription)
        atLeast(10).describeMismatch([], to: stringDescription)

        XCTAssertEqual(stringDescription.description, "Expected to be called at least <10> times was called <0> times")
    }

    func testCalledAtMost() {
        atMost(10).describeTo(stringDescription)
        atMost(10).describeMismatch([], to: stringDescription)

        XCTAssertEqual(stringDescription.description, "Expected to be called at most <10> times was called <0> times")
    }
}