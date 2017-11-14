//
//  ArgumentCaptorTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class ArgumentCaptorTest: XCTestCase {
    
    func testMultipleCalls() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.readWriteProperty.set(anyInt())).thenDoNothing()
        }
        mock.readWriteProperty = 10
        mock.readWriteProperty = 20
        mock.readWriteProperty = 30
        let captor = ArgumentCaptor<Int>()
        
        verify(mock, times(3)).readWriteProperty.set(captor.capture())
        
        XCTAssertEqual(captor.value, 30)
        XCTAssertEqual(captor.allValues, [10, 20, 30])
    }
    
    func testNoCall() {
        let mock = MockTestedClass()
        let captor = ArgumentCaptor<Int>()
        
        verify(mock, never()).readWriteProperty.set(captor.capture())
        
        XCTAssertNil(captor.value)
        XCTAssertTrue(captor.allValues.isEmpty)
    }
}
