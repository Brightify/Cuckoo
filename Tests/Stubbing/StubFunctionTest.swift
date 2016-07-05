//
//  StubFunctionTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class StubFunctionTest: XCTestCase {
    
    func testThen() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.countCharacters("a")).then {
                return $0.characters.count * 2
            }
        }
        
        XCTAssertEqual(mock.countCharacters("a"), 2)
    }
    
    func testThenReturn() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.countCharacters("a")).thenReturn(2)
        }
        
        XCTAssertEqual(mock.countCharacters("a"), 2)
    }
    
    func testThenCallRealImplementation() {
        let mock = MockTestedClass(spyOn: TestedClass())
        stub(mock) { mock in
            when(mock.countCharacters("a")).thenCallRealImplementation()
        }
        
        XCTAssertEqual(mock.countCharacters("a"), 1)
    }
}