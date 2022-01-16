//
//  StubbingTest.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
@testable import Cuckoo

class StubbingTest: XCTestCase {
    func testMultipleReturns() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a").thenReturn("b", "c")
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        XCTAssertEqual(mock.readOnlyProperty, "b")
        XCTAssertEqual(mock.readOnlyProperty, "c")
        XCTAssertEqual(mock.readOnlyProperty, "c")
    }

    func testOverrideStubWithMoreGeneralParameterMatcher() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.count(characters: "a")).thenReturn(2)
            when(mock.count(characters: anyString())).thenReturn(1)
        }

        XCTAssertEqual(mock.count(characters: "a"), 1)
    }

    func testOverrideStubWithMoreSpecificParameterMatcher() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.count(characters: anyString())).thenReturn(1)
            when(mock.count(characters: "a")).thenReturn(2)
        }

        XCTAssertEqual(mock.count(characters: "a"), 2)
    }

    func testUnstubbedSpy() {
        let mock = MockTestedClass().withEnabledSuperclassSpy()

        XCTAssertEqual(mock.count(characters: "a"), 1)
    }

    func testStubOfMultipleDifferentCalls() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a")
            when(mock.count(characters: "a")).thenReturn(1)
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        XCTAssertEqual(mock.count(characters: "a"), 1)
    }

    func testSubClass() {
        let mock = MockTestedSubclass()

        XCTAssertNotNil(mock)

        stub(mock) { mock in
            when(mock.readOnlyProperty.get).thenReturn("a").thenReturn("b", "c")
        }

        XCTAssertEqual(mock.readOnlyProperty, "a")
        XCTAssertEqual(mock.readOnlyProperty, "b")
        XCTAssertEqual(mock.readOnlyProperty, "c")
        XCTAssertEqual(mock.readOnlyProperty, "c")
    }

    func testSubClassMethod() {
        let mock = MockTestedSubclass()

        XCTAssertNotNil(mock)

        stub(mock) { mock in
            when(mock.subclassMethod()).thenReturn(1)
        }

        XCTAssertEqual(mock.subclassMethod(), 1)
    }

    func testSubclassMethodWithStringParameter() {
        let mock = MockTestedSubclass()

        XCTAssertNotNil(mock)

        stub(mock) { mock in
            when(mock.methodWithParameter(anyInt())).thenReturn("t1")
            when(mock.methodWithParameter(anyString())).thenReturn("t")
        }

        XCTAssertEqual(mock.methodWithParameter("a"), "t")
    }

    func testSubclassMethodWithIntParameter() {
        let mock = MockTestedSubclass()

        XCTAssertNotNil(mock)

        stub(mock) { mock in
            when(mock.methodWithParameter(anyInt())).thenReturn("t1")
            when(mock.methodWithParameter(anyString())).thenReturn("s1")
        }

        XCTAssertEqual(mock.methodWithParameter(1), "t1")
    }

    func testSubclassProtocolExtensionMethod() {
        /// Test dynamic dispatching
        let mock = MockTestedSubclass()

        XCTAssertNotNil(mock)

        stub(mock) { mock in
            when(mock.protocolMethod()).thenReturn("a1")
        }

        XCTAssertEqual(mock.protocolMethod(), "a1")
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testAsyncMethods() async {
        let mock = MockTestedSubSubClass()

        XCTAssertNotNil(mock)
        
        var callNoReturnAsync = false
        var callNoReturnAsyncThrows = false
        
        stub(mock) { stub in
            when(stub.withAsync()).thenReturn(10)
            when(stub.withAsyncThrows()).thenReturn(11)
            when(stub.withNoReturnAsync()).then {
                callNoReturnAsync = true
            }
            when(stub.withNoReturnAsyncThrows()).then {
                callNoReturnAsyncThrows = true
            }
            when(stub.withAsyncClosure(closure: anyClosure())).thenReturn("async closure")
            when(stub.withAsyncClosureAsync(closure: anyClosure())).thenReturn("closure async")
            when(stub.withAsyncEscapingClosure(closure: anyClosure())).thenReturn("escaping async")
            when(stub.withAsyncOptionalClosureAsync(closure: anyClosure())).thenReturn("optional async closure async")
        }
        
        let resultAsync = await mock.withAsync()
        XCTAssertEqual(resultAsync, 10)
        let resultAsyncThrows = try! await mock.withAsyncThrows()
        XCTAssertEqual(resultAsyncThrows, 11)
        await mock.withNoReturnAsync()
        XCTAssertTrue(callNoReturnAsync)
        try! await mock.withNoReturnAsyncThrows()
        XCTAssertTrue(callNoReturnAsyncThrows)
        XCTAssertEqual(mock.withAsyncClosure { p async in
            return nil
        }, "async closure")
        let resultAsyncClosure = await mock.withAsyncClosureAsync(closure: { _ in nil })
        XCTAssertEqual(resultAsyncClosure, "closure async")
        XCTAssertEqual(mock.withAsyncEscapingClosure(closure: { _ in nil }), "escaping async")
        let resultAsyncClosureAsync = await mock.withAsyncOptionalClosureAsync(closure: { _ in nil })
        XCTAssertEqual(resultAsyncClosureAsync, "optional async closure async")
        
        verify(mock, times(1)).withAsync()
        verify(mock, times(1)).withNoReturnAsync()
        verify(mock, times(1)).withAsyncClosure(closure: anyClosure())
        verify(mock, times(1)).withAsyncClosureAsync(closure: anyClosure())
        verify(mock, times(1)).withAsyncEscapingClosure(closure: anyClosure())
        verify(mock, times(1)).withAsyncOptionalClosureAsync(closure: anyClosure())
    }

    func testSubclassWithGrandparentsInheritanceAcceptanceTest() {
        let mock = MockTestedSubSubClass()

        XCTAssertNotNil(mock)

        var setReadWriteProperty: Int = -1
        var setOptionalProperty = -1
        var callNoReturn = false
        var callNoReturnThrows = false
        var callWithEscape = false
        var callWithOptionalClosure = false
        var callWithLabelAndUnderscore = false

        // Mock all available functions
        stub(mock) { stub in
            // sub-sub class
            when(stub.subSubMethod()).thenReturn("not nil")

            // sub-class
            when(stub.withImplicitlyUnwrappedOptional(i: anyInt())).thenReturn("implicit unwrapped return")
            when(stub.withThrows()).thenReturn(10)
            when(stub.withNamedTuple(tuple: any())).thenReturn(11)
            when(stub.subclassMethod()).thenReturn(12)
            when(stub.withOptionalClosureAndReturn(anyString(), closure: isNil())).thenReturn(2)
            when(stub.withOptionalClosureAndReturn(anyString(), closure: anyClosure())).thenReturn(3)
            when(stub.withClosureAndParam(anyString(), closure: anyClosure())).thenReturn(3)
            when(stub.withMultClosures(closure: anyClosure(), closureB: anyClosure(), closureC: anyClosure())).thenReturn(4)
            when(stub.withThrowingClosure(closure: anyThrowingClosure())).thenReturn("throwing closure")
            when(stub.withThrowingClosureThrows(closure: anyThrowingClosure())).thenReturn("closure throwing")
            when(stub.withThrowingEscapingClosure(closure: anyThrowingClosure())).thenReturn("escaping closure")
            when(stub.withThrowingOptionalClosureThrows(closure: anyOptionalThrowingClosure())).thenReturn("optional closure throwing")
            when(stub.methodWithParameter(anyString())).thenReturn("parameter string")
            when(stub.methodWithParameter(anyInt())).thenReturn("parameter int")

            // class
            when(stub.privateSetProperty.get).thenReturn(5)
            when(stub.readOnlyProperty.get).thenReturn("b")
            when(stub.readWriteProperty.set(anyInt())).then { i in
                setReadWriteProperty = i
            }
            when(stub.readWriteProperty.get).thenReturn(7)
            when(stub.optionalProperty.set(anyInt())).then { i in
                setOptionalProperty = i!
            }
            when(stub.optionalProperty.get).thenReturn(8)
            when(stub.noReturn()).then { _ in
                callNoReturn = true
            }
            when(stub.count(characters: anyString())).thenReturn(9)
            when(stub.withNoReturnThrows()).then { _ in
                callNoReturnThrows = true
            }
            when(stub.withClosure(anyClosure())).thenReturn(14)
            when(stub.withEscape(anyString(), action: anyClosure())).then { _ in
                callWithEscape = true
            }
            when(stub.withOptionalClosure(anyString(), closure: anyClosure())).then { _ in
                callWithOptionalClosure = true
            }
            when(stub.withLabelAndUnderscore(labelA: anyString(), anyString())).then { _ in
                callWithLabelAndUnderscore = true
            }
            when(stub.callingCountCharactersMethodWithHello()).thenReturn(15)

            // protocol
            when(stub.protocolMethod()).thenReturn("protocol method")
        }

        //
        // Test stubbing
        XCTAssertEqual(mock.subSubMethod(), "not nil")

        // sub-class
        XCTAssertEqual(mock.withImplicitlyUnwrappedOptional(i: 0), "implicit unwrapped return")
        XCTAssertEqual(try! mock.withThrows(), 10)
        XCTAssertEqual(mock.withNamedTuple(tuple: (a: "A", b: "B")), 11)
        XCTAssertEqual(mock.subclassMethod(), 12)
        XCTAssertEqual(mock.withOptionalClosureAndReturn("a", closure: Optional.none), 2)
        XCTAssertEqual(mock.withOptionalClosureAndReturn("a", closure: { _ in }), 3)
        XCTAssertEqual(mock.withClosureAndParam("a", closure: { _ in 0 }), 3)
        XCTAssertEqual(mock.withMultClosures(closure: { _ in 0 }, closureB: { _ in 1 }, closureC: { _ in 2 }), 4)
        XCTAssertEqual(mock.withThrowingClosure { p throws in
            return nil
        }, "throwing closure")
        XCTAssertEqual(try! mock.withThrowingClosureThrows(closure: { _ in nil }), "closure throwing")
        XCTAssertEqual(mock.withThrowingEscapingClosure(closure: { _ in nil }), "escaping closure")
        XCTAssertEqual(try! mock.withThrowingOptionalClosureThrows(closure: { _ in nil }), "optional closure throwing")
        XCTAssertEqual(mock.methodWithParameter("a"), "parameter string")
        XCTAssertEqual(mock.methodWithParameter(1), "parameter int")

        // class
        XCTAssertEqual(mock.privateSetProperty, 5)
        XCTAssertEqual(mock.readOnlyProperty, "b")
        XCTAssertEqual({
            mock.readWriteProperty = 100
            return setReadWriteProperty
        }(), 100)
        XCTAssertEqual(mock.readWriteProperty, 7)
        XCTAssertEqual({
            mock.optionalProperty = 200
            return setOptionalProperty
        }(), 200)
        XCTAssertEqual(mock.optionalProperty, 8)
        XCTAssertTrue({
            mock.noReturn()
            return callNoReturn
        }())
        XCTAssertEqual(mock.count(characters: "a"), 9)
        XCTAssertTrue({
            try! mock.withNoReturnThrows()
            return callNoReturnThrows
        }())
        XCTAssertEqual(mock.withClosure { _ in
            41
        }, 14)
        XCTAssertTrue({
            mock.withEscape("a") { _ in }
            return callWithEscape
        }())
        XCTAssertTrue({
            mock.withOptionalClosure("a") { _ in }
            return callWithOptionalClosure
        }())
        XCTAssertTrue({
            mock.withLabelAndUnderscore(labelA: "labelA", "any")
            return callWithLabelAndUnderscore
        }())
        XCTAssertEqual(mock.callingCountCharactersMethodWithHello(), 15)

        // Protocol
        XCTAssertEqual(mock.protocolMethod(), "protocol method")

        //
        // Test Verification
        // sub-sub class
        verify(mock, times(1)).subSubMethod()

        // sub-class
        verify(mock, times(1)).withImplicitlyUnwrappedOptional(i: anyInt())
        verify(mock, times(1)).withThrows()
        verify(mock, times(1)).withNamedTuple(tuple: any())
        verify(mock, times(1)).subclassMethod()
        verify(mock, times(1)).withOptionalClosureAndReturn(anyString(), closure: isNil())
        verify(mock, times(1)).withClosureAndParam(anyString(), closure: anyClosure())
        verify(mock, times(1)).withMultClosures(closure: anyClosure(), closureB: anyClosure(), closureC: anyClosure())
        verify(mock, times(1)).withThrowingClosure(closure: anyThrowingClosure())
        verify(mock, times(1)).withThrowingClosureThrows(closure: anyThrowingClosure())
        verify(mock, times(1)).withThrowingEscapingClosure(closure: anyThrowingClosure())
        verify(mock, times(1)).withThrowingOptionalClosureThrows(closure: anyOptionalThrowingClosure())
        verify(mock, times(1)).methodWithParameter(anyString())
        verify(mock, times(1)).methodWithParameter(anyInt())

        // class
        verify(mock, times(1)).privateSetProperty.get()
        verify(mock, times(1)).readOnlyProperty.get()
        verify(mock, times(1)).readWriteProperty.set(anyInt())
        verify(mock, times(1)).readWriteProperty.get()
        verify(mock, times(1)).optionalProperty.set(anyInt())
        verify(mock, times(1)).optionalProperty.get()
        verify(mock, times(1)).noReturn()
        verify(mock, times(1)).count(characters: anyString())
        verify(mock, times(1)).withNoReturnThrows()
        verify(mock, times(1)).withClosure(anyClosure())
        verify(mock, times(1)).withEscape(anyString(), action: anyClosure())
        verify(mock, times(1)).withOptionalClosure(anyString(), closure: anyClosure())
        verify(mock, times(1)).withLabelAndUnderscore(labelA: anyString(), anyString())
        verify(mock, times(1)).callingCountCharactersMethodWithHello()

        // protocol
        verify(mock, times(1)).protocolMethod()
    }

    func testSubProtocolMethod() {
        let mock = MockTestedSubProtocol()

        XCTAssertNotNil(mock)

        let invocationExpectation = expectation(description: "function is called")
        stub(mock) { mock in
            when(mock.noReturnSub()).then {
                invocationExpectation.fulfill()
            }
        }

        mock.noReturnSub()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testThreadSafety() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.count(characters: any())).thenReturn(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
        }

        // Verify that we can call a stub from multiple threads, 2 or more of which may hit the MockManager at the same time.
        // MockManager should handle this without race conditions or EXC_BAD_INSTRUCTION errors.
        DispatchQueue.concurrentPerform(iterations: 1000) { index in
            _ = mock.count(characters: "")
        }

        verify(mock, times(1000)).count(characters: any())
    }
}
