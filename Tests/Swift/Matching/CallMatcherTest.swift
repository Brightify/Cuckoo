//
//  CallMatcherTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 05.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class CallMatcherTest: XCTestCase {
    
    private let call = [ConcreteStubCall(method: "A", parameters: Void()) as StubCall]
    private var multipleCalls: [StubCall] {
        return [call[0], call[0]]
    }
    
    func testMatches() {
        let matcher = CallMatcher(name: "") { ($0.first?.method ?? "") == "A"}
        let nonMatchingCalls = [ConcreteStubCall(method: "B", parameters: Void()) as StubCall]
        
        XCTAssertTrue(matcher.matches(call))
        XCTAssertFalse(matcher.matches(nonMatchingCalls))
    }
    
    func testOr() {
        let matcher = never().or(times(1))
        
        XCTAssertTrue(matcher.matches(call))
        XCTAssertTrue(matcher.matches([]))
        XCTAssertFalse(matcher.matches(multipleCalls))
    }
    
    func testAnd() {
        let matcher = atLeast(1).and(atMost(2))
        
        XCTAssertTrue(matcher.matches(call))
        XCTAssertTrue(matcher.matches(multipleCalls))
        XCTAssertFalse(matcher.matches([]))
    }
}
