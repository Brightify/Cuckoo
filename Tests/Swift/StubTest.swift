//
//  StubTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 21.09.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class StubTest: XCTestCase {
    
    private var stub: ClassForStubTestingStub!
    
    override func setUp() {
        super.setUp()
        
        stub = ClassForStubTestingStub()
    }
    
    func testIntProperty() {
        stub.intProperty = 1
        XCTAssertEqual(0, stub.intProperty)
    }
    
    func testArrayProperty() {
        stub.arrayProperty = [1]
        XCTAssertEqual([], stub.arrayProperty)
    }
    
    func testSetProperty() {
        stub.setProperty = Set([1])
        XCTAssertEqual(Set(), stub.setProperty)
    }
    
    func testDictionaryProperty() {
        stub.dictionaryProperty = ["a": 1]
        XCTAssertEqual([:], stub.dictionaryProperty)
    }
    
    func testTuple1() {
        stub.tuple1 = (2)
        XCTAssertTrue((0) == stub.tuple1)
    }
    
    func testTuple2() {
        stub.tuple2 = (2, 1)
        XCTAssertTrue((0, 0) == stub.tuple2)
    }
    
    func testTuple3() {
        stub.tuple3 = (2, 1, true)
        XCTAssertTrue((0, 0, false) == stub.tuple3)
    }
    
    func testTuple4() {
        stub.tuple4 = (2, 1, 1, 1)
        XCTAssertTrue((0, 0, 0, 0) == stub.tuple4)
    }
    
    func testTuple5() {
        stub.tuple5 = (2, 1, 1, 1, 1)
        XCTAssertTrue((0, 0, 0, 0, 0) == stub.tuple5)
    }
    
    func testTuple6() {
        stub.tuple6 = (2, "A", 1, 1, 1, 1)
        XCTAssertTrue((0, "", 0, 0, 0, 0) == stub.tuple6)
    }
    
    func testIntFunction() {
        stub.intProperty = 1
        XCTAssertEqual(0, stub.intFunction())
    }
    
    func testArrayFunction() {
        stub.arrayProperty = [1]
        XCTAssertEqual([], stub.arrayFunction())
    }
    
    func testSetFunction() {
        stub.setProperty = Set([1])
        XCTAssertEqual(Set(), stub.setFunction())
    }
    
    func testDictionaryFunction() {
        stub.dictionaryProperty = ["a": 1]
        XCTAssertEqual([:], stub.dictionaryFunction())
    }
    
    func testVoidFunction() {
        // Test for crash
        stub.voidFunction()
    }
}
