//
//  VerificationTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class VerificationTest: XCTestCase {
    
    func testVerify() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
        }
        
        mock.noReturn()
        
        verify(mock).noReturn()
    }
    
    func testVerifyWithCallMatcher() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
        }
        
        mock.noReturn()
        mock.noReturn()
        
        verify(mock, times(2)).noReturn()
    }
    
    func testVerifyWithMultipleDifferentCalls() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
            when(mock.count(characters: anyString())).thenReturn(1)
        }
        
        _ = mock.count(characters: "a")
        mock.noReturn()
        
        verify(mock).noReturn()
        verify(mock).count(characters: anyString())
    }
}
