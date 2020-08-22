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

    required init<F>(theC: C, theV: V, f: F) {
        readOnlyPropertyC = theC
        readWritePropertyV = theV
    }

    func callSomeC(theC: C) -> Int {
        return 1
    }

    func callSomeV(theV: V) -> Int {
        switch theV {
        case let int as Int:
            return int
        case let string as String:
            return Int(string) ?? 8008135
        default:
            return 0
        }
    }

    func compute(classy: C, value: V) -> C {
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

    func noReturn() {}
}

private struct GenericProtocolConformerStruct<C: AnyObject, V>: GenericProtocol {
    let readOnlyPropertyC: C
    var readWritePropertyV: V

    let constant: Int = 0
    var optionalProperty: V?

    init<F>(theC: C, theV: V, f: F) {
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
}

class GenericProtocolTest: XCTestCase {
    private func createMock<V>(value: V) -> MockGenericProtocol<MockTestedClass, V> {
        let classy = MockTestedClass()
        return MockGenericProtocol(theC: classy, theV: value, f: 0)
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
        let original = GenericProtocolConformerClass(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"], f: "F")
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
        var original = GenericProtocolConformerStruct(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"], f: "F")
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
    //
    func testStructNonModification() {
        let mock = createMock(value: ["EXTERMINATE!": "EXTERMINATE!!", "EXTERMINATE!!!": "EXTERMINATE!!!!"])
        var original = GenericProtocolConformerStruct(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"], f: "F")
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
}
