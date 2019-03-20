//
//  ClassTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

extension TestedClass: Mocked {
    typealias MockType = MockTestedClass
}

class ClassTest: XCTestCase {
    
    private var mock: MockTestedClass!
    
    override func setUp() {
        super.setUp()
        
        mock = MockTestedClass()
    }
    
    func testReadOnlyPropertyWithMockCreator() {
        let mock = createMock(for: TestedClass.self) { builder, stub in
            when(stub.readOnlyProperty.get).thenReturn("a")

            return MockTestedClass()
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        _ = verify(mock).readOnlyProperty.get
    }

    func testReadOnlyProperty() {
        let mock = MockTestedClass()

        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a")
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        _ = verify(mock).readOnlyProperty.get
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
        _ = verify(mock).readWriteProperty.get
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
        _ = verify(mock).optionalProperty.get
        verify(mock).optionalProperty.set(equal(to: 0))
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
            when(mock.count(characters: "a")).thenReturn(1)
        }
        
        XCTAssertEqual(mock.count(characters: "a"), 1)
        verify(mock).count(characters: "a")
    }
    
    func testWithThrows() {
        stub(mock) { mock in
            when(mock.withThrows()).thenThrow(TestError.unknown)
        }
        
        var catched = false
        do {
            _ = try mock.withThrows()
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
            when(mock.withClosure(anyClosure())).then { $0("a") }
        }
        
        XCTAssertEqual(mock.withClosure { _ in 1 }, 1)
        verify(mock).withClosure(anyClosure())
    }
    
    func testWithEscape() {
        var called = false
        stub(mock) { mock in
            when(mock.withEscape(anyString(), action: anyClosure())).then { text, closure in closure(text) }
        }
        
        mock.withEscape("a") { called = $0 == "a" }
        
        XCTAssertTrue(called)
        verify(mock).withEscape(anyString(), action: anyClosure())
    }
    
    func testWithOptionalClosure() {
        var called = false
        stub(mock) { mock in
            when(mock.withOptionalClosure(anyString(), closure: anyClosure())).then { text, closure in closure?(text)  }
        }
        
        mock.withOptionalClosure("a") { called = $0 == "a" }
        
        XCTAssertTrue(called)
        verify(mock).withOptionalClosure(anyString(), closure: anyClosure())
    }

    func testWithLabel() {
        var called = false
        stub(mock) { mock in
            when(mock.withLabelAndUnderscore(labelA: anyString(), anyString())).then { _ in called = true }
        }

        mock.withLabelAndUnderscore(labelA: "a", "b")
        XCTAssertTrue(called)
        verify(mock).withLabelAndUnderscore(labelA: anyString(), anyString())
    }

    func testCallingCountCharactersMethodWithHello() {
        stub(mock) { mock in
            when(mock.callingCountCharactersMethodWithHello()).thenCallRealImplementation()
            when(mock.count(characters: any())).thenReturn(0)
        }

        XCTAssertEqual(mock.callingCountCharactersMethodWithHello(), 0)
        verify(mock).callingCountCharactersMethodWithHello()
        verify(mock).count(characters: "Hello")
    }

    func testDefaultImplCall() {
        mock.enableDefaultImplementation(TestedClassStub())

        XCTAssertEqual(mock.callingCountCharactersMethodWithHello(), 0)
        verify(mock).callingCountCharactersMethodWithHello()
    }

    func testInout() {
        let mock = MockInoutMethodClass()
        stub(mock) { mock in
            when(mock.inoutko(param: anyInt())).then { param in
                print(param)
            }
        }

        var integer = 12
        mock.inoutko(param: &integer)
    }

    func testOptionals() {
        let mock = MockOptionalParamsClass()

        stub(mock) { mock in
            when(mock.clashingFunction(param1: Optional(1), param2: "Henlo Fren") as Cuckoo.ClassStubNoReturnFunction<(Int?, String)>).thenDoNothing()
            when(mock.clashingFunction(param1: Optional.none, param2: "Henlo Fren") as Cuckoo.ClassStubNoReturnFunction<(Int?, String)>).thenDoNothing()
            when(mock.clashingFunction(param1: anyInt(), param2: "What's the question?") as Cuckoo.ClassStubNoReturnFunction<(Int, String?)>).then {
                print("What's 6 times 9? \($0.0)")
            }
            when(mock.clashingFunction(param1: anyInt(), param2: isNil()) as Cuckoo.ClassStubNoReturnFunction<(Int, String?)>).then {
                print("What's 6 times 9? \($0.0)")
            }
            mock.function(param: "string")
            when(mock.function(param: "string")).thenDoNothing()
        }

        mock.clashingFunction(param1: Optional(22), param2: "Henlo Fren")
        mock.clashingFunction(param1: 42, param2: Optional("What's the question?"))

        _ = verify(mock).clashingFunction(param1: anyInt(), param2: "Henlo Fren") as Cuckoo.__DoNotUse<(Int?, String), Void>
        _ = verify(mock).clashingFunction(param1: 42, param2: "What's the question?") as Cuckoo.__DoNotUse<(Int, String?), Void>
    }
    
    private enum TestError: Error {
        case unknown
    }
}
