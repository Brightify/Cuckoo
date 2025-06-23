import XCTest
@testable import Cuckoo
@testable import CuckooMocks

final class StubThrowingFunctionTest: XCTestCase {
    func testThen() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.withThrows()).then {
                return 2
            }
        }

        XCTAssertEqual(try! mock.withThrows(), 2)
    }

    func testThenReturn() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.withThrows()).thenReturn(2)
        }
        
        XCTAssertEqual(try! mock.withThrows(), 2)
    }

    func testThenCallRealImplementation() {
        let mock = MockTestedClass().withEnabledSuperclassSpy()
        stub(mock) { mock in
            when(mock.withThrows()).thenCallRealImplementation()
        }
        
        XCTAssertEqual(try! mock.withThrows(), 0)
    }

    func testThenThrow() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.withThrows()).thenThrow(TestError.unknown)
        }

        var catched = false
        do {
            _ = try mock.withThrows()
        } catch {
            catched = true
        }

        XCTAssertTrue(catched)
    }

    func testOverrideThenThrowInSubClass() {
        let mock = MockTestedSubclass()

        XCTAssertNotNil(mock)

        stub(mock) { mock in
            when(mock.withThrows()).thenThrow(TestError.unknown)
        }

        var catched = false
        do {
            _ = try mock.withThrows()
        } catch {
            catched = true
        }

        XCTAssertTrue(catched)
    }
    
    func testTypedThrowsThenTypedError() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.withTypedThrows())
                .thenThrow(NSError())
        }
    }

    private enum TestError: Error {
        case unknown
    }
}
