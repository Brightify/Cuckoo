import XCTest
import Cuckoo
import OriginalTypes
import OtherTypes

final class SourceModuleTests: XCTestCase {
    func testClassDefaultImplementationUsesSourceModule() {
        let mock = MockTimer()
        mock.enableDefaultImplementation(OriginalTypes.Timer())
        XCTAssertEqual(mock.read(), 17)
        let stub: OriginalTypes.Timer = TimerStub()
        XCTAssertEqual(stub.read(), 0)
    }

    func testProtocolStubbingUsesSourceModule() {
        let mock = MockClock()
        stub(mock) { when($0.read()).thenReturn(23) }
        XCTAssertEqual(mock.read(), 23)
        verify(mock).read()
        let _: any OriginalTypes.Clock = ClockStub()
    }

    func testGenericProtocolDefaultImplementationUsesSourceModule() {
        struct IntStore: OriginalTypes.Store {
            func read() -> Int { 31 }
        }
        let mock = MockStore<Int>()
        mock.enableDefaultImplementation(IntStore())
        XCTAssertEqual(mock.read(), 31)
        let _: StoreStub<Int> = StoreStub()
    }

    func testNestedProtocolIsGeneratedInsideSourceNamespace() {
        let mock = OriginalTypes.Namespace.MockNestedClock()
        stub(mock) { when($0.read()).thenReturn(41) }
        XCTAssertEqual(mock.read(), 41)
        let _: any OriginalTypes.Namespace.NestedClock = OriginalTypes.Namespace.NestedClockStub()
    }
}
