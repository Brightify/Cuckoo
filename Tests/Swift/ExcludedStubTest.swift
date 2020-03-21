//
//  ExcludedStubTest.swift
//  Cuckoo
//
//  Created by Arjan Duijzer on 29/12/2017.
//  Copyright © 2017 Brightify. All rights reserved.
//

import XCTest

// This test case is intentionally ran only without `OCMock` because it depends on creating some very particular classes.
// Other test cases are included in the `OCMock` target because they test general Cuckoo functionality.
class ExcludedStubTest: XCTestCase {

    func testClassAvailability() {
        XCTAssertNotNil(ExcludedTestClass())

#if os(iOS)
        XCTAssertNotNil(NSClassFromString("Cuckoo_iOSTests.ExcludedTestClass"))
        XCTAssertNil(NSClassFromString("Cuckoo_iOSTests.MockExcludedTestClass"))
#elseif os(tvOS)
        XCTAssertNotNil(NSClassFromString("Cuckoo_tvOSTests.ExcludedTestClass"))
        XCTAssertNil(NSClassFromString("Cuckoo_tvOSTests.MockExcludedTestClass"))
#else
        XCTAssertNotNil(NSClassFromString("Cuckoo_macOSTests.ExcludedTestClass"))
        XCTAssertNil(NSClassFromString("Cuckoo_macOSTests.MockExcludedTestClass"))
#endif
        XCTAssertNotNil(IncludedTestClass())
        XCTAssertNotNil(MockIncludedTestClass())
    }

    func testProtocolAvailability() {
        XCTAssertNotNil(MockIncludedProtocol())

#if os(iOS)
        XCTAssertNil(NSClassFromString("Cuckoo_iOSTests.MockExcludedProtocol"))
#else
        XCTAssertNil(NSClassFromString("Cuckoo_macOSTests.MockExcludedProtocol"))
#endif
    }

}
