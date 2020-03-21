//
//  StubNoReturnFunctionTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
@testable import Cuckoo

class StubNoReturnFunctionTest: XCTestCase {
    
    func testThen() {
        let mock = MockTestedClass()
        var called = false
        stub(mock) { mock in
            when(mock.noReturn()).then {
                called = true
            }
        }
        
        mock.noReturn()
        
        XCTAssertTrue(called)
    }
    
    func testThenCallRealImplementation() {
        let mock = MockTestedClass().withEnabledSuperclassSpy()
        stub(mock) { mock in
            when(mock.noReturn()).thenCallRealImplementation()
        }
        
        mock.noReturn()
    }
    
    func testThenDoNothing() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
        }
        
        mock.noReturn()
    }
}
