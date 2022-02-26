import XCTest
@testable import Cuckoo

final class StubNoReturnFunctionTest: XCTestCase {
    func testThen() {
        let mock = MockTestedClass()
        var called = false
        stub(mock) { mock in
            when(mock.noReturn()).then {
                called = true
            }
        }

        mock.noReturn()

        XCTAssertTrue(called)
    }

    func testThenCallRealImplementation() {
        let mock = MockTestedClass().withEnabledSuperclassSpy()
        stub(mock) { mock in
            when(mock.noReturn()).thenCallRealImplementation()
        }

        mock.noReturn()
    }

    func testThenDoNothing() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
        }

        mock.noReturn()
    }
}
