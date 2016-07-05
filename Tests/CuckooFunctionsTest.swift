//
//  CuckooFunctionsTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class CuckooFunctionsTest: XCTestCase {
    
    func testReset() {
        let mock = MockTestedClass(spyOn: TestedClass())
        stub(mock) { mock in
            when(mock.countCharacters(anyString())).thenReturn(10)
        }
        XCTAssertEqual(mock.countCharacters("a"), 10)
        
        reset(mock)
        
        verify(mock, never()).countCharacters("a")
        XCTAssertEqual(mock.countCharacters("a"), 1)
        verify(mock).countCharacters("a")
    }
    
    func testClearStubs() {
        let mock = MockTestedClass(spyOn: TestedClass())
        stub(mock) { mock in
            when(mock.countCharacters(anyString())).thenReturn(10)
        }
        XCTAssertEqual(mock.countCharacters("a"), 10)
        
        clearStubs(mock)
        
        verify(mock).countCharacters("a")
        XCTAssertEqual(mock.countCharacters("a"), 1)
        verify(mock, times(2)).countCharacters("a")
    }
    
    func testClearInvocations() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.countCharacters(anyString())).thenReturn(10)
        }
        XCTAssertEqual(mock.countCharacters("a"), 10)
        
        clearInvocations(mock)
        
        verify(mock, never()).countCharacters("a")
        XCTAssertEqual(mock.countCharacters("a"), 10)
        verify(mock).countCharacters("a")
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
    
    func testVerifyNoMoreInteractionsFail() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }
            
            mock.noReturn()
            
            verifyNoMoreInteractions(mock)
        }
        
        XCTAssertNotNil(error)
    }
}
