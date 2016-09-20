//
//  ClassTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class ClassTest: XCTestCase {

    private var mock: MockTestedClass!
    
    override func setUp() {
        super.setUp()
        
        mock = MockTestedClass()
    }
    
    func testReadOnlyProperty() {
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a")
        }
        
        XCTAssertEqual(mock.readOnlyProperty, "a")
        verify(mock).readOnlyProperty.get
    }
    
    func testReadWriteProperty() {
        var called = false
        stub(mock) { mock in
            when(mock.readWriteProperty.get).thenReturn(1)
            when(mock.readWriteProperty.set(anyInt())).then { _ in called = true }
        }
        
        mock.readWriteProperty = 0
        
        XCTAssertEqual(mock.readWriteProperty, 1)
        XCTAssertTrue(called)
        verify(mock).readWriteProperty.get
        verify(mock).readWriteProperty.set(0)
    }
    
    func testOptionalProperty() {
        var called = false
        stub(mock) { mock in
            when(mock.optionalProperty.get).thenReturn(nil)
            when(mock.optionalProperty.set(anyInt())).then { _ in called = true }
        }
        
        mock.optionalProperty = 0
        
        XCTAssertNil(mock.optionalProperty)
        XCTAssertTrue(called)
        verify(mock).optionalProperty.get
        verify(mock).optionalProperty.set(eq(0))
    }
    
    func testNoReturn() {
        var called = false
        stub(mock) { mock in
            when(mock.noReturn()).then { _ in called = true }
        }
        
        mock.noReturn()
        
        XCTAssertTrue(called)
        verify(mock).noReturn()
    }
    
    func testCountCharacters() {
        stub(mock) { mock in
            when(mock.countCharacters("a")).thenReturn(1)
        }
        
        XCTAssertEqual(mock.countCharacters("a"), 1)
        verify(mock).countCharacters("a")
    }
    
    func testWithThrows() {
        stub(mock) { mock in
            when(mock.withThrows()).thenThrow(TestError.unknown)
        }
        
        var catched = false
        do {
            try mock.withThrows()
        } catch {
            catched = true
        }
        
        XCTAssertTrue(catched)
        verify(mock).withThrows()
    }
    
    func testWithNoReturnThrows() {
        stub(mock) { mock in
            when(mock.withNoReturnThrows()).thenThrow(TestError.unknown)
        }
        
        var catched = false
        do {
            try mock.withNoReturnThrows()
        } catch {
            catched = true
        }
        
        XCTAssertTrue(catched)
        verify(mock).withNoReturnThrows()
    }
    
    func testWithClosure() {
        stub(mock) { mock in
            when(mock.withClosure(anyClosure())).thenReturn(0)
        }
        
        XCTAssertEqual(mock.withClosure { _ in 1 }, 0)
        verify(mock).withClosure(anyClosure())
    }
    
    func testWithNoescape() {
        var called = false
        stub(mock) { mock in
            when(mock.withNoescape(anyString(), action: anyClosure())).then { _ in called = true }
        }
        
        mock.withNoescape("a") { _ in 1 }
        
        XCTAssertTrue(called)
        verify(mock).withNoescape(anyString(), action: anyClosure())
    }
    
    func testWithOptionalClosure() {
        var called = false
        stub(mock) { mock in
            when(mock.withOptionalClosure(anyString(), closure: anyClosure())).then { _ in called = true }
        }
        
        mock.withOptionalClosure("a") { _ in 1 }
        
        XCTAssertTrue(called)
        verify(mock).withOptionalClosure(anyString(), closure: anyClosure())
    }

    func testWithLabel() {
        var called = false
        stub(mock) { mock in
            when(mock.withLabel(labelA: anyString())).then { _ in called = true }
        }

        mock.withLabel(labelA: "a")
        XCTAssertTrue(called)
        verify(mock).withLabel(labelA: anyString())
    }
    
    private enum TestError: Error {
        case unknown
    }
}
