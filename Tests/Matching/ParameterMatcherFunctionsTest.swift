//
//  ParameterMatcherFunctionsTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class ParameterMatcherFunctionsTest: XCTestCase {  
    
    func testEqualToEquatable() {
        XCTAssertTrue(eq(1).matches(1))
        XCTAssertFalse(eq(1).matches(2))
        
        XCTAssertTrue(equalTo(1).matches(1))
        XCTAssertFalse(equalTo(1).matches(2))
    }
    
    func testEqualToAnyObject() {
        let x = X()
        
        XCTAssertTrue(eq(x).matches(x))
        XCTAssertFalse(eq(x).matches(X()))
        
        XCTAssertTrue(equalTo(x).matches(x))
        XCTAssertFalse(equalTo(x).matches(X()))
    }
    
    func testEqualToWithFunction() {
        let tuple = (1, 1)
        let function = { (a: (Int, Int), b: (Int, Int)) -> Bool in
            return a.0 == b.0 && a.1 == b.1
        }
        
        XCTAssertTrue(eq(tuple, equalWhen: function).matches((1, 1)))
        XCTAssertFalse(eq(tuple, equalWhen: function).matches((1, 2)))
        
        XCTAssertTrue(equalTo(tuple, equalWhen: function).matches((1, 1)))
        XCTAssertFalse(equalTo(tuple, equalWhen: function).matches((1, 2)))
    }
    
    func testAnyInt() {
        XCTAssertTrue(anyInt().matches(1))
    }
    
    func testAnyString() {
        XCTAssertTrue(anyString().matches("a"))
    }
    
    func testAny() {
        XCTAssertTrue(any().matches(X()))
    }
    
    func testAnyClosure() {
        XCTAssertTrue(anyClosure().matches({ 0 }))
    }
    
    func testOptionalEqualToEquatable() {
        XCTAssertTrue(eq(nil as Int?).matches(nil))
        XCTAssertTrue(eq(1 as Int?).matches(1))
        XCTAssertFalse(equalTo(1 as Int?).matches(2))
        XCTAssertFalse(eq(nil).matches(1))
        
        XCTAssertTrue(equalTo(nil as Int?).matches(nil))
        XCTAssertTrue(equalTo(1 as Int?).matches(1))
        XCTAssertFalse(equalTo(1 as Int?).matches(2))
        XCTAssertFalse(equalTo(nil).matches(1))
    }
    
    func testOptionalEqualToAnyObject() {
        let x: X? = X()
        
        XCTAssertTrue(eq(nil as X?).matches(nil))
        XCTAssertTrue(eq(x).matches(x))
        XCTAssertFalse(eq(x).matches(X()))
        XCTAssertFalse(eq(nil).matches(x))
        
        XCTAssertTrue(eq(nil as X?).matches(nil))
        XCTAssertTrue(equalTo(x).matches(x))
        XCTAssertFalse(equalTo(x).matches(X()))
        XCTAssertFalse(eq(nil).matches(x))
    }
    
    func testOptionalEqualToWithFunction() {
        let tuple: (Int, Int)? = (1, 1)
        let function = { (a: (Int, Int)?, b: (Int, Int)?) -> Bool in
            guard let x = a, let y = b else {
                return a == nil && b == nil
            }
            return x.0 == y.0 && x.1 == y.1
        }
        
        XCTAssertTrue(eq(nil, equalWhen: function).matches(nil))
        XCTAssertTrue(eq(tuple, equalWhen: function).matches((1, 1)))
        XCTAssertFalse(eq(tuple, equalWhen: function).matches((1, 2)))
        XCTAssertFalse(eq(nil, equalWhen: function).matches(tuple))
        
        XCTAssertTrue(equalTo(nil, equalWhen: function).matches(nil))
        XCTAssertTrue(equalTo(tuple, equalWhen: function).matches((1, 1)))
        XCTAssertFalse(equalTo(tuple, equalWhen: function).matches((1, 2)))
        XCTAssertFalse(equalTo(nil, equalWhen: function).matches(tuple))
    }
    
    func testOptionalAnyInt() {
        XCTAssertTrue(anyInt().matches(1 as Int?))
        XCTAssertFalse(anyString().matches(nil as String?))
    }
    
    func testOptionalAnyString() {
        XCTAssertTrue(anyString().matches("a" as String?))
        XCTAssertFalse(anyString().matches(nil as String?))
    }
    
    func testOptionalAny() {
        XCTAssertTrue(any().matches(X() as X?))
        XCTAssertTrue(any().matches(nil as X?))
    }
    
    func testOptionalAnyClosure() {
        XCTAssertTrue(anyClosure().matches({ 0 } as (() -> Int)?))
        XCTAssertFalse(anyClosure().matches(nil as (() -> Int)?))
    }
    
    func testNotNil() {
        XCTAssertTrue(notNil().matches(X()))
        XCTAssertFalse(notNil().matches(nil as X?))
    }
    
    private class X {
    }
}
