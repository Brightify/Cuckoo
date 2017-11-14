//
//  StubNoReturnThrowingFunctionTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
@testable import Cuckoo

class StubNoReturnThrowingFunctionTest: XCTestCase {
    
    func testThen() {
        let mock = MockTestedClass()
        var called = false
        stub(mock) { mock in
            when(mock.withNoReturnThrows()).then {
                called = true
            }
        }
        
        try! mock.withNoReturnThrows()
        
        XCTAssertTrue(called)
    }
    
    func testThenCallRealImplementation() {
        let mock = MockTestedClass().withEnabledSuperclassSpy()
        stub(mock) { mock in
            when(mock.withNoReturnThrows()).thenCallRealImplementation()
        }
        
        try! mock.withNoReturnThrows()
    }
    
    func testThenDoNothing() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.withNoReturnThrows()).thenDoNothing()
        }
        
        try! mock.withNoReturnThrows()
    }
    
    func testThenThrow() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.withNoReturnThrows()).thenThrow(TestError.unknown)
        }
        
        var catched = false
        do {
            try mock.withNoReturnThrows()
        } catch {
            catched = true
        }
        
        XCTAssertTrue(catched)
    }
    
    private enum TestError: Error {
        case unknown
    }
}
