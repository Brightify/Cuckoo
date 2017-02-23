//
//  StubbingTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
@testable import Cuckoo

class StubbingTest: XCTestCase {
    
    func testMultipleReturns() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a").thenReturn("b", "c")
        }
        
        XCTAssertEqual(mock.readOnlyProperty, "a")
        XCTAssertEqual(mock.readOnlyProperty, "b")
        XCTAssertEqual(mock.readOnlyProperty, "c")
        XCTAssertEqual(mock.readOnlyProperty, "c")
    }
    
    func testOverrideStubWithMoreGeneralParameterMatcher() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.count(characters: "a")).thenReturn(2)
            when(mock.count(characters: anyString())).thenReturn(1)
        }
        
        XCTAssertEqual(mock.count(characters: "a"), 1)
    }
    
    func testOverrideStubWithMoreSpecificParameterMatcher() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.count(characters: anyString())).thenReturn(1)
            when(mock.count(characters: "a")).thenReturn(2)
        }
        
        XCTAssertEqual(mock.count(characters: "a"), 2)
    }
    
    func testUnstubbedSpy() {
        let mock = MockTestedClass().spy(on: TestedClass())
        
        XCTAssertEqual(mock.count(characters: "a"), 1)
    }
    
    func testStubOfMultipleDifferentCalls() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a")
            when(mock.count(characters: "a")).thenReturn(1)
        }
        
        XCTAssertEqual(mock.readOnlyProperty, "a")
        XCTAssertEqual(mock.count(characters: "a"), 1)
    }
    
    func testSubClass() {
        let mock = MockTestedSubclass()
        
        XCTAssertNotNil(mock)
        
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a").thenReturn("b", "c")
        }
        
        XCTAssertEqual(mock.readOnlyProperty, "a")
        XCTAssertEqual(mock.readOnlyProperty, "b")
        XCTAssertEqual(mock.readOnlyProperty, "c")
        XCTAssertEqual(mock.readOnlyProperty, "c")
    }

    func testSubClassMethod() {
        let mock = MockTestedSubclass()

        XCTAssertNotNil(mock)

        stub(mock) { mock in
            when(mock.subclassMethod()).thenReturn(1)
        }

        XCTAssertEqual(mock.subclassMethod(), 1)
    }
}
