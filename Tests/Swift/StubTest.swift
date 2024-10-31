import Cuckoo
import Testing
import XCTest
@testable import CuckooMocks

final class StubTest: XCTestCase {
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

struct StubSwiftTestingTests {
    let stub = ClassForStubTestingStub()

    @Test
    func intProperty() {
        stub.intProperty = 1
        #expect(stub.intProperty == 0)
    }

    @Test
    func arrayProperty() {
        stub.arrayProperty = [1]
        #expect(stub.arrayProperty == [])
    }

    @Test
    func setProperty() {
        stub.setProperty = Set([1])
        #expect(stub.setProperty == Set())
    }

    @Test
    func dictionaryProperty() {
        stub.dictionaryProperty = ["a": 1]
        #expect(stub.dictionaryProperty == [:])
    }

    @Test
    func tuple1() {
        stub.tuple1 = (2)
        #expect(stub.tuple1 == (0))
    }

    @Test
    func tuple2() {
        stub.tuple2 = (2, 1)
        #expect(stub.tuple2 == (0, 0))
    }

    @Test
    func tuple3() {
        stub.tuple3 = (2, 1, true)
        #expect(stub.tuple3 == (0, 0, false))
    }

    @Test
    func tuple4() {
        stub.tuple4 = (2, 1, 1, 1)
        #expect(stub.tuple4 == (0, 0, 0, 0))
    }

    @Test
    func tuple5() {
        stub.tuple5 = (2, 1, 1, 1, 1)
        #expect(stub.tuple5 == (0, 0, 0, 0, 0))
    }

    @Test
    func tuple6() {
        stub.tuple6 = (2, "A", 1, 1, 1, 1)
        #expect(stub.tuple6 == (0, "", 0, 0, 0, 0))
    }

    @Test
    func intFunction() {
        stub.intProperty = 1
        #expect(stub.intFunction() == 0)
    }

    @Test
    func arrayFunction() {
        stub.arrayProperty = [1]
        #expect(stub.arrayFunction() == [])
    }

    @Test
    func setFunction() {
        stub.setProperty = Set([1])
        #expect(stub.setFunction() == Set())
    }

    @Test
    func dictionaryFunction() {
        stub.dictionaryProperty = ["a": 1]
        #expect(stub.dictionaryFunction() == [:])
    }

    @Test
    func testVoidFunction() {
        // Test for crash
        stub.voidFunction()
    }
}
