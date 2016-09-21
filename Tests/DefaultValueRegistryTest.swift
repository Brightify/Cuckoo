//
//  DefaultValueRegistryTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 21.09.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class DefaultValueRegistryTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        DefaultValueRegistry.reset()
    }
    
    override func tearDown() {
        super.tearDown()
        
        DefaultValueRegistry.reset()
    }
    
    func testReset() {
        XCTAssertEqual(0, DefaultValueRegistry.defaultValue(Int.self))
        DefaultValueRegistry.register(10, forType: Int.self)
        DefaultValueRegistry.reset()
        XCTAssertEqual(0, DefaultValueRegistry.defaultValue(Int.self))
    }
    
    func testRegisterValue() {
        let value = 10
        DefaultValueRegistry.register(value, forType: Int.self)
        XCTAssertEqual(value, DefaultValueRegistry.defaultValue(Int.self))
    }
    
    func testRegisterSet() {
        let value = Set([1])
        DefaultValueRegistry.register(value, forType: Set<Int>.self)
        XCTAssertEqual(value, DefaultValueRegistry.defaultValue(Set<Int>.self))
    }
    
    func testRegisterArray() {
        let value = [1]
        DefaultValueRegistry.register(value, forType: Array<Int>.self)
        XCTAssertEqual(value, DefaultValueRegistry.defaultValue(Array<Int>.self))
    }
    
    func testRegisterDictionary() {
        let value = ["A": 1]
        DefaultValueRegistry.register(value, forType: Dictionary<String, Int>.self)
        XCTAssertEqual(value, DefaultValueRegistry.defaultValue(Dictionary<String, Int>.self))
    }
    
    func testRegisterOptional() {
        let value = 1 as Int?
        DefaultValueRegistry.register(value, forType: Optional<Int>.self)
        XCTAssertEqual(value, DefaultValueRegistry.defaultValue(Optional<Int>.self))
    }
    
    func testRegisterTuple1() {
        let value = (1)
        DefaultValueRegistry.register(value, forType: (Int).self)
        XCTAssertTrue(value == DefaultValueRegistry.defaultValue((Int).self))
    }

    func testRegisterTuple2() {
        let value = (1, 1)
        DefaultValueRegistry.register(value, forType: (Int, Int).self)
        XCTAssertTrue(value == DefaultValueRegistry.defaultValue((Int, Int).self))
    }
    
    func testRegisterTuple3() {
        let value = (1, 1, 1)
        DefaultValueRegistry.register(value, forType: (Int, Int, Int).self)
        XCTAssertTrue(value == DefaultValueRegistry.defaultValue((Int, Int, Int).self))
    }
    
    func testRegisterTuple4() {
        let value = (1, 1, 1, 1)
        DefaultValueRegistry.register(value, forType: (Int, Int, Int, Int).self)
        XCTAssertTrue(value == DefaultValueRegistry.defaultValue((Int, Int, Int, Int).self))
    }
    
    func testRegisterTuple5() {
        let value = (1, 1, 1, 1, 1)
        DefaultValueRegistry.register(value, forType: (Int, Int, Int, Int, Int).self)
        XCTAssertTrue(value == DefaultValueRegistry.defaultValue((Int, Int, Int, Int, Int).self))
    }
    
    func testRegisterTuple6() {
        let value = (1, 1, 1, 1, 1, 1)
        DefaultValueRegistry.register(value, forType: (Int, Int, Int, Int, Int, Int).self)
        XCTAssertTrue(value == DefaultValueRegistry.defaultValue((Int, Int, Int, Int, Int, Int).self))
    }
}
