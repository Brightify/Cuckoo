//
//  CuckooAPITest.swift
//  CuckooTests
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class CuckooAPITest: XCTestCase {
    
    func testProtocol() {
        let mock = MockTestedProtocol()
        
        // FIXME Should be fatalError when method was not throwing
        
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("properties!")
            when(mock.readWriteProperty.get).thenReturn(10)
            when(mock.readWriteProperty.set(anyInt())).then {
                print($0)
            }
            when(mock.optionalProperty.set(equalTo(nil))).then { _ in
                when(mock.optionalProperty.get).thenReturn(nil)
            }
            when(mock.optionalProperty.set(anyInt())).then { _ in
                when(mock.optionalProperty.get).thenReturn(10)
            }
            when(mock.optionalProperty.set(eq(1))).then { _ in
                when(mock.optionalProperty.get).thenReturn(1)
            }
            
            when(mock.noParameter()).thenReturn()
            when(mock.countCharacters("hello")).thenReturn(1000)
            when(mock.withReturn()).thenReturn("hello world!")
            when(mock.withThrows()).thenThrow(TestError.Unknown)
            
            when(mock.withClosure(anyClosure())).then {
                $0("hello world")
            }
            when(mock.withClosureReturningInt(anyClosure())).thenReturn(1000)
            when(mock.withNoescape("hello", closure: anyClosure())).then {
                $1($0 + " world")
            }
            when(mock.withOptionalClosure("hello", closure: anyClosure())).then {
                $1?($0 + " world")
            }
        }
        
        XCTAssertEqual(mock.readOnlyProperty, "properties!")
        XCTAssertEqual(mock.readWriteProperty, 10)
        mock.readWriteProperty = 400
        XCTAssertEqual(mock.readWriteProperty, 10)
        
        mock.optionalProperty = nil
        XCTAssertNil(mock.optionalProperty)
        mock.optionalProperty = 5
        XCTAssertEqual(mock.optionalProperty, 10)
        mock.optionalProperty = 1
        XCTAssertEqual(mock.optionalProperty, 1)
        
        mock.noParameter()
        
        XCTAssertEqual(mock.countCharacters("hello"), 1000)
        
        XCTAssertEqual(mock.withReturn(), "hello world!")
        
        XCTAssertEqual(mock.withClosureReturningInt { _ in 10 }, 1000)
        
        var helloWorld: String = ""
        mock.withClosure {
            helloWorld = $0
            return 10
        }
        XCTAssertEqual(helloWorld, "hello world")
        
        // Calling @noescape closure is not currently supported
        /*var helloWorld: String = ""
         mock.withNoescape("hello") {
         helloWorld = $0
         }
         XCTAssertEqual(helloWorld, "hello world")
         */
        
        helloWorld = ""
        mock.withOptionalClosure("hello") {
            helloWorld = $0
        }
        XCTAssertEqual(helloWorld, "hello world")
        
        verify(mock).readOnlyProperty.get
        verify(mock, times(2)).readWriteProperty.get
        verify(mock).readWriteProperty.set(400)
        
        verify(mock).noParameter()
        verify(mock).countCharacters(eq("hello"))
        verify(mock).withReturn()
        verify(mock, never()).withThrows()
        verify(mock).withClosureReturningInt(anyClosure())
        verify(mock).withOptionalClosure("hello", closure: anyClosure())
    }
    
    func testClass() {
        let mock = MockTestedClass()
        
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("properties!")
            when(mock.readWriteProperty.get).thenReturn(10)
            when(mock.readWriteProperty.set(anyInt())).then {
                print($0)
            }
            when(mock.optionalProperty.set(equalTo(nil))).then { _ in
                when(mock.optionalProperty.get).thenReturn(nil)
            }
            when(mock.optionalProperty.set(anyInt())).then { _ in
                when(mock.optionalProperty.get).thenReturn(10)
            }
            when(mock.optionalProperty.set(eq(1))).then { _ in
                when(mock.optionalProperty.get).thenReturn(1)
            }
            
            when(mock.noParameter()).thenReturn()
            when(mock.countCharacters("hello")).thenReturn(1000)
            when(mock.withReturn()).thenReturn("hello world!")
            when(mock.withThrows()).thenThrow(TestError.Unknown)
            
            when(mock.withClosure(anyClosure())).then {
                $0("hello world")
            }
            when(mock.withClosureReturningInt(anyClosure())).thenReturn(1000)
            when(mock.withNoescape("hello", closure: anyClosure())).then {
                $1($0 + " world")
            }
            when(mock.withOptionalClosure("hello", closure: anyClosure())).then {
                $1?($0 + " world")
            }
        }
        
        XCTAssertEqual(mock.readOnlyProperty, "properties!")
        XCTAssertEqual(mock.readWriteProperty, 10)
        mock.readWriteProperty = 400
        XCTAssertEqual(mock.readWriteProperty, 10)
        
        mock.optionalProperty = nil
        XCTAssertNil(mock.optionalProperty)
        mock.optionalProperty = 5
        XCTAssertEqual(mock.optionalProperty, 10)
        mock.optionalProperty = 1
        XCTAssertEqual(mock.optionalProperty, 1)
        
        mock.noParameter()
        
        XCTAssertEqual(mock.countCharacters("hello"), 1000)
        
        XCTAssertEqual(mock.withReturn(), "hello world!")
        
        XCTAssertEqual(mock.withClosureReturningInt { _ in 10 }, 1000)
        
        var helloWorld: String = ""
        mock.withClosure {
            helloWorld = $0
            return 10
        }
        XCTAssertEqual(helloWorld, "hello world")
        
        // Calling @noescape closure is not currently supported
        /*var helloWorld: String = ""
        mock.withNoescape("hello") {
            helloWorld = $0
        }
        XCTAssertEqual(helloWorld, "hello world")
        */
        
        helloWorld = ""
        mock.withOptionalClosure("hello") {
            helloWorld = $0
        }
        XCTAssertEqual(helloWorld, "hello world")
        
        verify(mock).readOnlyProperty.get
        verify(mock, times(2)).readWriteProperty.get
        verify(mock).readWriteProperty.set(400)
        verify(mock).noParameter()
        verify(mock).countCharacters(eq("hello"))
        verify(mock).withReturn()
        verify(mock, never()).withThrows()
        verify(mock).withClosureReturningInt(anyClosure())
        verify(mock).withOptionalClosure("hello", closure: anyClosure())
    }
    
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
        let mock = MockTestedClass(spyOn: TestedClass())
        stub(mock) { mock in
            when(mock.countCharacters(anyString())).thenReturn(10)
        }
        XCTAssertEqual(mock.countCharacters("a"), 10)
        
        clearInvocations(mock)
        
        verify(mock, never()).countCharacters("a")
        XCTAssertEqual(mock.countCharacters("a"), 10)
        verify(mock).countCharacters("a")
    }
    
    private enum TestError: ErrorType {
        case Unknown
    }
}
