//
//  ParameterMatcherTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 05.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class ParameterMatcherTest: XCTestCase {
    
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
}