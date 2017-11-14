//
//  StubFunctionTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
@testable import Cuckoo

class StubFunctionTest: XCTestCase {
    
    func testThen() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.count(characters: "a")).then {
                return $0.count * 2
            }
        }
        
        XCTAssertEqual(mock.count(characters: "a"), 2)
    }
    
    func testThenReturn() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.count(characters: "a")).thenReturn(2)
        }
        
        XCTAssertEqual(mock.count(characters: "a"), 2)
    }
    
    func testThenCallRealImplementation() {
        let mock = MockTestedClass().withEnabledSuperclassSpy()
        stub(mock) { mock in
            when(mock.count(characters: "a")).thenCallRealImplementation()
        }
        
        XCTAssertEqual(mock.count(characters: "a"), 1)
    }
}
