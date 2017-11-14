//
//  CuckooFunctionsTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
@testable import Cuckoo

class CuckooFunctionsTest: XCTestCase {
       
    func testReset() {
        let mock = MockTestedClass().withEnabledSuperclassSpy()
        stub(mock) { mock in
            when(mock.count(characters: anyString())).thenReturn(10)
        }
        XCTAssertEqual(mock.count(characters: "a"), 10)
        
        reset(mock)
        
        verify(mock, never()).count(characters: "a")
        XCTAssertEqual(mock.count(characters: "a"), 1)
        verify(mock).count(characters: "a")
    }
    
    func testClearStubs() {
        let mock = MockTestedClass().withEnabledSuperclassSpy()
        stub(mock) { mock in
            when(mock.count(characters: anyString())).thenReturn(10)
        }
        XCTAssertEqual(mock.count(characters: "a"), 10)
        
        clearStubs(mock)
        
        verify(mock).count(characters: "a")
        XCTAssertEqual(mock.count(characters: "a"), 1)
        verify(mock, times(2)).count(characters: "a")
    }
    
    func testClearInvocations() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.count(characters: anyString())).thenReturn(10)
        }
        XCTAssertEqual(mock.count(characters: "a"), 10)
        
        clearInvocations(mock)
        
        verify(mock, never()).count(characters: "a")
        XCTAssertEqual(mock.count(characters: "a"), 10)
        verify(mock).count(characters: "a")
    }
    
    func testVerifyNoMoreInteractions() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
        }
        
        mock.noReturn()
        verify(mock).noReturn()
        
        verifyNoMoreInteractions(mock)
    }
}
