import XCTest
import Cuckoo
@testable import CuckooMocks

final class VerificationTest: XCTestCase {
    func testVerify() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
        }
        
        mock.noReturn()
        
        verify(mock).noReturn()
    }

    func testVerifyWithCallMatcher() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
        }
        
        mock.noReturn()
        mock.noReturn()
        
        verify(mock, times(2)).noReturn()
    }

    func testVerifyWithMultipleDifferentCalls() {
        let mock = MockTestedClass()
        stub(mock) { mock in
            when(mock.noReturn()).thenDoNothing()
            when(mock.count(characters: anyString())).thenReturn(1)
        }

        _ = mock.count(characters: "a")
        mock.noReturn()

        verify(mock).noReturn()
        verify(mock).count(characters: anyString())
    }

    func testVerifyWithGenericReturn() {
        let mock = MockGenericMethodClass<String>()
        stub(mock) { mock in
            when(mock.genericReturn(any())).thenReturn("")
        }

        let _: String? = mock.genericReturn("Foo")

        verify(mock).genericReturn(equal(to: "Foo")).with(returnType: String?.self)
    }
}
