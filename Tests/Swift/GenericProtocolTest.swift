//
//  GenericProtocolTest.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 26/11/2018.
//

import XCTest
import Cuckoo

private class GenericProtocolConformerClass<C: AnyObject, V>: GenericProtocol {
    let readOnlyPropertyC: C
    var readWritePropertyV: V

    let constant: Int = 0
    var optionalProperty: V?

    required init(theC: C, theV: V) {
        readOnlyPropertyC = theC
        readWritePropertyV = theV
    }

    func callSomeC(theC: C) -> Int {
        return 1
    }

    func callSomeV(theV: V) -> Int {
       return processV(theV)
    }

    func compute(classy: C, value: V) -> C {
       return computeC(classy, value)
    }

    func noReturn() {}
    
    func computeAsync(classy: C, value: V) async -> (C, V) {
        return (computeC(classy, value), value)
    }
    
    func noReturnAsync() async {}
    
    private func processV(_ theV: V) -> Int {
        switch theV {
        case let int as Int:
            return int
        case let string as String:
            return Int(string) ?? 8008135
        default:
            return 0
        }
    }

    private func computeC(_ classy: C, _ value: V) -> C {
        guard let testyClassy = classy as? TestedClass else { return classy }
        switch value {
        case let int as Int:
            testyClassy.readWriteProperty = int
        case _ as String:
            testyClassy.optionalProperty = nil
        default:
            break
        }
        return testyClassy as! C
    }
}

private struct GenericProtocolConformerStruct<C: AnyObject, V>: GenericProtocol {
    let readOnlyPropertyC: C
    var readWritePropertyV: V

    let constant: Int = 0
    var optionalProperty: V?

    init(theC: C, theV: V) {
        readOnlyPropertyC = theC
        readWritePropertyV = theV
    }

    func callSomeC(theC: C) -> Int {
        return 1
    }

    func callSomeV(theV: V) -> Int {
        return 0
    }

    func compute(classy: C, value: V) -> C {
        return classy
    }

    func noReturn() {}
    
    func computeAsync(classy: C, value: V) async -> (C, V) {
        return (classy, value)
    }
    
    func noReturnAsync() async {}
}

class GenericProtocolTest: XCTestCase {
    private func createMock<V>(value: V, classy: MockTestedClass = MockTestedClass()) -> MockGenericProtocol<MockTestedClass, V> {
        return MockGenericProtocol(theC: classy, theV: value)
    }

    func testReadOnlyProperty() {
        let mock = createMock(value: 10)
        stub(mock) { mock in
            when(mock.readOnlyPropertyC.get).thenReturn(MockTestedClass())
        }

        _ = mock.readOnlyPropertyC

        verify(mock).readOnlyPropertyC.get()
    }

    func testReadWriteProperty() {
        let mock = createMock(value: 10)
        stub(mock) { mock in
            when(mock.readWritePropertyV.get).then { 11 }
            when(mock.readWritePropertyV.set(anyInt())).thenDoNothing()
        }

        mock.readWritePropertyV = 42
        XCTAssertEqual(mock.readWritePropertyV, 11)
        verify(mock).readWritePropertyV.get()
        verify(mock).readWritePropertyV.set(42)
    }

    func testOptionalProperty() {
        let mock = createMock(value: false)
        var called = false
        stub(mock) { mock in
            when(mock.optionalProperty.get).thenReturn(true)
            when(mock.optionalProperty.set(any())).then { _ in called = true }
            when(mock.optionalProperty.set(isNil())).then { _ in called = true }
        }

        mock.optionalProperty = nil
        mock.optionalProperty = false

        XCTAssertTrue(mock.optionalProperty == true)
        XCTAssertTrue(called)
        verify(mock).optionalProperty.get()
        verify(mock).optionalProperty.set(equal(to: false))
        verify(mock, times(2)).optionalProperty.set(any())
        verify(mock).optionalProperty.set(isNil())
    }

    func testNoReturn() {
        let mock = createMock(value: "Hello. Sniffing through tests? If you're having trouble with Cuckoo, shoot us a message!")
        var called = false
        stub(mock) { mock in
            when(mock.noReturn()).then { _ in called = true }
        }

        mock.noReturn()

        XCTAssertTrue(called)
        verify(mock).noReturn()
    }

    func testModification() {
        let mock = createMock(value: ["EXTERMINATE!": "EXTERMINATE!!", "EXTERMINATE!!!": "EXTERMINATE!!!!"])
        let original = GenericProtocolConformerClass(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"])
        mock.enableDefaultImplementation(original)
        
        original.readWritePropertyV["Are you sure?"] = "Yeah, I'm just waiting for my wife."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀", "Are you sure?": "Yeah, I'm just waiting for my wife."])

        original.readWritePropertyV["Alright, have a nice weekend!"] = "Thanks, you too."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀",
                                                 "Are you sure?": "Yeah, I'm just waiting for my wife.",
                                                 "Alright, have a nice weekend!": "Thanks, you too."])

        verify(mock, times(2)).readWritePropertyV.get()
    }

    // the next two test cases show using a struct as the default implementation and changing its state:
    // - NOTE: This only applies for `struct`s, not `class`es.
    // using: `enableDefaultImplementation(mutating:)` reflects the original's state at all times
    func testStructModification() {
        let mock = createMock(value: ["EXTERMINATE!": "EXTERMINATE!!", "EXTERMINATE!!!": "EXTERMINATE!!!!"])
        var original = GenericProtocolConformerStruct(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"])
        mock.enableDefaultImplementation(mutating: &original)

        original.readWritePropertyV["Are you sure?"] = "Yeah, I'm just waiting for my wife."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀", "Are you sure?": "Yeah, I'm just waiting for my wife."])

        original.readWritePropertyV["Alright, have a nice weekend!"] = "Thanks, you too."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀",
                                                 "Are you sure?": "Yeah, I'm just waiting for my wife.",
                                                 "Alright, have a nice weekend!": "Thanks, you too."])

        verify(mock, times(2)).readWritePropertyV.get()
    }

    // using: `enableDefaultImplementation(_:)` reflects the original's state at the time of enabling default implementation with the struct
    func testStructNonModification() {
        let mock = createMock(value: ["EXTERMINATE!": "EXTERMINATE!!", "EXTERMINATE!!!": "EXTERMINATE!!!!"])
        var original = GenericProtocolConformerStruct(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"])
        mock.enableDefaultImplementation(original)

        original.readWritePropertyV["Are you sure?"] = "Yeah, I'm just waiting for my wife."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀"])
        XCTAssertEqual(original.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀", "Are you sure?": "Yeah, I'm just waiting for my wife."])

        original.readWritePropertyV["Alright, have a nice weekend!"] = "Thanks, you too."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀"])
        XCTAssertEqual(original.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀",
                                                 "Are you sure?": "Yeah, I'm just waiting for my wife.",
                                                 "Alright, have a nice weekend!": "Thanks, you too."])

        verify(mock, times(2)).readWritePropertyV.get()
    }

    func testComputeAsync() async {
        let expectedReturn = (MockTestedClass(), 10)
        let mock = createMock(value: expectedReturn.1, classy: expectedReturn.0)
        stub(mock) { mock in
            when(mock.computeAsync(classy: any(), value: any())).thenReturn(expectedReturn)
        }

        let actualReturn = await mock.computeAsync(classy: expectedReturn.0, value: expectedReturn.1)
        
        XCTAssertTrue(expectedReturn.0 === actualReturn.0)
        XCTAssertEqual(expectedReturn.1, actualReturn.1)
        verify(mock).computeAsync(classy: expectedReturn.0, value: expectedReturn.1)
    }

    func testNoReturnAsync() async {
        let mock = createMock(value: 10)
        stub(mock) { mock in
            when(mock.noReturnAsync()).thenDoNothing()
        }

        await mock.noReturnAsync()
        
        verify(mock).noReturnAsync()
    }
}

extension MockTestedClass: Matchable{
    public typealias MatchedType = MockTestedClass
    
    public var matcher: ParameterMatcher<MockTestedClass> {
        return ParameterMatcher<MockTestedClass> { other in
            return self === other
        }
    }
}
