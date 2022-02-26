import XCTest
import Cuckoo

final class MatchableTest: XCTestCase {
    func testOr() {
        let matcher = 5.or(4)
        
        XCTAssertTrue(matcher.matches(5))
        XCTAssertTrue(matcher.matches(4))
        XCTAssertFalse(matcher.matches(3))
    }

    func testAnd() {
        let matcher = 5.and(ParameterMatcher { $0 > 4 })
        
        XCTAssertTrue(matcher.matches(5))
        XCTAssertFalse(matcher.matches(4))
    }

    func testBool() {
        XCTAssertTrue(true.matcher.matches(true))
        XCTAssertFalse(true.matcher.matches(false))
    }

    func testInt() {
        XCTAssertTrue(1.matcher.matches(1))
        XCTAssertFalse(1.matcher.matches(2))
    }

    func testString() {
        XCTAssertTrue("a".matcher.matches("a"))
        XCTAssertFalse("a".matcher.matches("b"))
    }

    func testFloat() {
        XCTAssertTrue(Float(1.1).matcher.matches(1.1))
        XCTAssertFalse(Float(1.1).matcher.matches(1.2))
    }

    func testDouble() {
        XCTAssertTrue(1.1.matcher.matches(1.1))
        XCTAssertFalse(1.1.matcher.matches(1.2))
    }

    func testCharacter() {
        XCTAssertTrue(Character("a").matcher.matches("a"))
        XCTAssertFalse(Character("a").matcher.matches("b"))
    }
}
