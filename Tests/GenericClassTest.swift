//
//  GenericClassTest.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 26/11/2018.
//

import XCTest
import Cuckoo

extension GenericClass: Mocked {
    typealias MockType = MockGenericClass<T, U, V>
}

class GenericClassTest: XCTestCase {
    private var mock: MockGenericClass<Int, String, Bool>!
    private var original: GenericClass<Int, String, Bool>!

    override func setUp() {
        super.setUp()

        mock = MockGenericClass(theT: 10, theU: "Hello, generics!", theV: false)
        original = GenericClass(theT: 42, theU: "Hello world!", theV: false)
    }

    func testReadWritePropertyWithMockCreator() {
        let mock = createMock(for: GenericClass<Int, String, Bool>.self) { builder, stub in
            when(stub.readWritePropertyU.get).thenReturn("a")

            return MockGenericClass(theT: 0, theU: "", theV: true)
        }

        XCTAssertEqual(mock.readWritePropertyU, "a")
        _ = verify(mock).readWritePropertyU.get
    }

    func testReadWriteProperty() {
        stub(mock) { mock in
            when(mock.readWritePropertyV.get).thenReturn(true)
        }

        XCTAssertEqual(mock.readWritePropertyV, true)
        _ = verify(mock).readWritePropertyV.get
    }

    func testConstantProperty() {
        mock.enableDefaultImplementation(original)
        XCTAssertEqual(mock.constant, 10.0)
    }

    func testModification() {
        mock.enableDefaultImplementation(original)
        let numbers = [127, 0, 0, 1]
        for number in numbers {
            original.readWritePropertyT = number
            XCTAssertEqual(mock.readWritePropertyT, number)
        }

        verify(mock, times(numbers.count)).readWritePropertyT.get
    }

    func testReadWriteProperties() {
        var calledT = false
        var calledU = false
        var calledV = false
        stub(mock) { mock in
            when(mock.readWritePropertyT.get).thenReturn(1)
            when(mock.readWritePropertyT.set(anyInt())).then { _ in calledT = true }

            when(mock.readWritePropertyU.get).thenReturn("Hello, mocker!")
            when(mock.readWritePropertyU.set(anyString())).then { _ in calledU = true }

            when(mock.readWritePropertyV.get).thenReturn(false)
            when(mock.readWritePropertyV.set(any(Bool.self))).then { _ in calledV = true }
        }

        mock.readWritePropertyT = 0
        XCTAssertEqual(mock.readWritePropertyT, 1)
        XCTAssertTrue(calledT)
        _ = verify(mock).readWritePropertyT.get
        verify(mock).readWritePropertyT.set(0)

        mock.readWritePropertyU = "NO MOCKING FOR YOU"
        XCTAssertEqual(mock.readWritePropertyU, "Hello, mocker!")
        XCTAssertTrue(calledU)
        _ = verify(mock).readWritePropertyU.get
        verify(mock).readWritePropertyU.set("NO MOCKING FOR YOU")

        mock.readWritePropertyV = true
        XCTAssertEqual(mock.readWritePropertyV, false)
        XCTAssertTrue(calledV)
        _ = verify(mock).readWritePropertyV.get
        verify(mock).readWritePropertyV.set(true)
    }

    func testOptionalProperty() {
        var called = false
        stub(mock) { mock in
            when(mock.optionalProperty.get).thenReturn(nil)
            when(mock.optionalProperty.set(anyString())).then { _ in called = true }
        }

        mock.optionalProperty = "tukabel"

        XCTAssertNil(mock.optionalProperty)
        XCTAssertTrue(called)
        _ = verify(mock).optionalProperty.get
        verify(mock).optionalProperty.set(equal(to: "tukabel"))
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

    func testUnequal() {
        stub(mock) { mock in
            when(mock.unequal(one: false, two: false)).thenReturn(false)
            when(mock.unequal(one: false, two: true)).thenReturn(true)
            when(mock.unequal(one: true, two: false)).thenReturn(true)
            when(mock.unequal(one: true, two: true)).thenReturn(false)
        }

        XCTAssertFalse(mock.unequal(one: false, two: false))
        XCTAssertTrue(mock.unequal(one: false, two: true))
        XCTAssertTrue(mock.unequal(one: true, two: false))
        XCTAssertFalse(mock.unequal(one: true, two: true))
    }

    func testGetThird() {
        stub(mock) { mock in
            when(mock.getThird(foo: anyInt(), bar: "gimme true", baz: any(Bool.self))).thenReturn(false)
            when(mock.getThird(foo: anyInt(), bar: "gimme false", baz: any(Bool.self))).thenReturn(true)
        }

        XCTAssertFalse(mock.getThird(foo: 10, bar: "gimme true", baz: true))
        verify(mock).getThird(foo: 10, bar: "gimme true", baz: true)
        XCTAssertTrue(mock.getThird(foo: 1099, bar: "gimme false", baz: false))
        verify(mock).getThird(foo: 1099, bar: "gimme false", baz: false)
    }

    func testPrint() {
        stub(mock) { mock in
            when(mock.print(theT: anyInt())).thenDoNothing()
        }

        mock.print(theT: 555)
        verify(mock).print(theT: 555)
    }

    func testEncode() {
        mock.enableDefaultImplementation(original)
        stub(mock) { mock in
            when(mock.encode(theU: anyString())).thenCallRealImplementation()
        }

        let encoder = JSONEncoder()
        let world = "Hello, world!"
        XCTAssertEqual(mock.encode(theU: world), try! encoder.encode(["root": world]))
        verify(mock).encode(theU: world)
    }

    func testWithClosure() {
        stub(mock) { mock in
            when(mock.withClosure(anyClosure())).then { $0(666) }
        }

        XCTAssertEqual(mock.withClosure { number in number * 2 + 5 }, 1337)
        verify(mock).withClosure(anyClosure())
    }
}
