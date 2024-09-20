import XCTest
import Cuckoo
import CuckooMocks // not @testable

final class OpenClassTest: XCTestCase {
    func testOpenClass() throws {
        XCTAssertNotNil(MockOpenClass())
    }
}
