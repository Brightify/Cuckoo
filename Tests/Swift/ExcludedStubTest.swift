import XCTest
@testable import CuckooMocks

// This test case is intentionally ran only without `OCMock` because it depends on creating some very particular classes.
// Other test cases are included in the `OCMock` target because they test general Cuckoo functionality.
final class ExcludedStubTest: XCTestCase {
    func testClassAvailability() {
        XCTAssertNotNil(ExcludedTestClass())

        XCTAssertNotNil(NSClassFromString("CuckooMocks.ExcludedTestClass"))
        XCTAssertNil(NSClassFromString("CuckooMocks.MockExcludedTestClass"))
        XCTAssertNotNil(IncludedTestClass())
        XCTAssertNotNil(MockIncludedTestClass())
    }

    func testProtocolAvailability() {
        XCTAssertNotNil(MockIncludedProtocol())

        XCTAssertNil(NSClassFromString("CuckooMocks.MockExcludedProtocol"))
    }
}
