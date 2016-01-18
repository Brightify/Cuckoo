//
//  MockeryTests.swift
//  MockeryTests
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class MockeryAPITest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        enum TestError: ErrorType {
            case Unknown
        }
        
        let mock = MockTestedProtocol()
        
        // FIXME Should be fatalError when method was not throwing
        
        stub(mock) { mock in
            when(mock.noParameter()).thenReturn()
            when(mock.countCharacters("hello")).thenReturn(1000)
            when(mock.withReturn()).thenReturn("hello world!")
            when(mock.withThrows()).thenThrow(TestError.Unknown)
            
            when(mock.withNoescape("hello", closure: anyClosure())).then {
                $1($0 + " world")
            }
        }
        
        mock.noParameter()
        
        XCTAssertEqual(mock.countCharacters("hello"), 1000)
        
        XCTAssertEqual(mock.withReturn(), "hello world!")
        
        var helloWorld: String = ""
        mock.withNoescape("hello") {
            helloWorld = $0
        }
        XCTAssertEqual(helloWorld, "hello world")
        
        verify(mock).noParameter()
        
        verify(mock).countCharacters(eq("hello"))
        
        verify(mock).withReturn()
        
        verify(mock, never()).withThrows()
        
    }
        
}