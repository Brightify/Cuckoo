import XCTest
import Cuckoo

final class ParameterMatcherTest: XCTestCase {
    func testMatches() {
        let matcher = ParameterMatcher { $0 == 5 }
        
        XCTAssertTrue(matcher.matches(5))
        XCTAssertFalse(matcher.matches(4))
    }
    
    func testOr() {
        let matcher = ParameterMatcher { $0 == 5 }.or(ParameterMatcher { $0 == 4 })
        
        XCTAssertTrue(matcher.matches(5))
        XCTAssertTrue(matcher.matches(4))
        XCTAssertFalse(matcher.matches(3))
    }
    
    func testAnd() {
        let matcher = ParameterMatcher { $0 > 3 }.and(ParameterMatcher { $0 < 5 })
        
        XCTAssertTrue(matcher.matches(4))
        XCTAssertFalse(matcher.matches(3))
    }

    func testNot() {
        let matcher = not(ParameterMatcher { $0 > 3 })

        XCTAssertTrue(matcher.matches(3))
        XCTAssertTrue(matcher.matches(2))
        XCTAssertTrue(matcher.matches(-1))
        XCTAssertFalse(matcher.matches(4))
        XCTAssertFalse(matcher.matches(10))
    }
}
