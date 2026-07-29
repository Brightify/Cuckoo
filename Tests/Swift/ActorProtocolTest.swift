import XCTest
import Cuckoo
@testable import CuckooMocks

final class ActorProtocolTest: XCTestCase {

    private var mock: MockActorProtocol!

    override func setUp() {
        super.setUp()

        mock = MockActorProtocol()
    }

    func testStubbingAndVerifyingActorMock() async {
        stub(mock) { mock in
            when(mock.value.get).thenReturn(1)
            when(mock.increment()).thenDoNothing()
            when(mock.fetchRemoteValue()).thenReturn(42)
        }

        let value = await mock.value
        XCTAssertEqual(value, 1)

        await mock.increment()

        let remoteValue = await mock.fetchRemoteValue()
        XCTAssertEqual(remoteValue, 42)

        verify(mock).value.get()
        verify(mock).increment()
        verify(mock).fetchRemoteValue()
    }

    func testChildActorProtocolMock() async {
        let childMock = MockChildActorProtocol()

        stub(childMock) { mock in
            when(mock.value.get).thenReturn(2)
            when(mock.childMethod()).thenDoNothing()
        }

        let value = await childMock.value
        XCTAssertEqual(value, 2)

        await childMock.childMethod()

        verify(childMock).value.get()
        verify(childMock).childMethod()
    }
}
