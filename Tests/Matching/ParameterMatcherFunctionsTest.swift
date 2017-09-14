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
        XCTAssertTrue(equal(to: 1).matches(1))
        XCTAssertFalse(equal(to: 1).matches(2))
    }
    
    func testEqualToAnyObject() {
        let x = X()
        
        XCTAssertTrue(equal(to: x).matches(x))
        XCTAssertFalse(equal(to: x).matches(X()))
    }
    
    func testEqualToWithFunction() {
        let tuple = (1, 1)
        let function = { (a: (Int, Int), b: (Int, Int)) -> Bool in
            return a.0 == b.0 && a.1 == b.1
        }
        
        XCTAssertTrue(equal(to: tuple, equalWhen: function).matches((1, 1)))
        XCTAssertFalse(equal(to: tuple, equalWhen: function).matches((1, 2)))
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
        XCTAssertTrue(equal(to: nil as Int?).matches(nil))
        XCTAssertTrue(equal(to: 1 as Int?).matches(1))
        XCTAssertFalse(equal(to: 1 as Int?).matches(2))
        XCTAssertFalse(equal(to: nil).matches(1))
    }
    
    func testOptionalEqualToAnyObject() {
        let x: X? = X()

        XCTAssertTrue(equal(to: nil as X?).matches(nil))
        XCTAssertTrue(equal(to: x).matches(x))
        XCTAssertFalse(equal(to: x).matches(X()))
        XCTAssertFalse(equal(to: nil).matches(x))
    }
    
    func testOptionalEqualToWithFunction() {
        let tuple: (Int, Int)? = (1, 1)
        let function = { (a: (Int, Int)?, b: (Int, Int)?) -> Bool in
            guard let x = a, let y = b else {
                return a == nil && b == nil
            }
            return x.0 == y.0 && x.1 == y.1
        }
        
        XCTAssertTrue(equal(to: nil, equalWhen: function).matches(nil))
        XCTAssertTrue(equal(to: tuple, equalWhen: function).matches((1, 1)))
        XCTAssertFalse(equal(to: tuple, equalWhen: function).matches((1, 2)))
        XCTAssertFalse(equal(to: nil, equalWhen: function).matches(tuple))
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
        XCTAssertTrue(anyClosure().matches({ (arg) in let () = arg; return 0 } as ((()) -> Int)?))
        XCTAssertFalse(anyClosure().matches(nil as ((()) -> Int)?))
    }
    
    func testNotNil() {
        XCTAssertTrue(notNil().matches(X()))
        XCTAssertFalse(notNil().matches(nil as X?))
    }
    
    private class X {
    }
}
