import Testing
import XCTest
@testable import Cuckoo
@testable import CuckooMocks

final class FailTest: XCTestCase {
    func testMissingInvocation() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass()

            verify(mock).noReturn()
        }

        XCTAssertEqual(error, "Wanted 1 times but not invoked.")
    }

    func testNoInvocation2Wanted() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            mock.noReturn()

            verify(mock, times(2)).noReturn()
        }

        XCTAssertEqual(error, "Wanted 2 times but invoked 1 times.")
    }

    func testInvocationNeverWanted() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            mock.noReturn()

            verify(mock, never()).noReturn()
        }

        XCTAssertEqual(error, "Wanted never but invoked 1 times.")
    }

    func testInvocationAtLeast2Wanted() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            mock.noReturn()

            verify(mock, atLeast(2)).noReturn()
        }

        XCTAssertEqual(error, "Wanted at least 2 times but invoked 1 times.")
    }

    func test2InvocationAtMost1Wanted() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            mock.noReturn()
            mock.noReturn()

            verify(mock, atMost(1)).noReturn()
        }
        
        XCTAssertEqual(error, "Wanted at most 1 times but invoked 2 times.")
    }

    func testCallMatcherOr() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            verify(mock, times(1).or(times(2))).noReturn()
        }

        XCTAssertEqual(error, "Wanted either 1 times or 2 times but not invoked.")
    }

    func testCallMatcherAnd() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }
            
            verify(mock, atLeast(1).and(atMost(2))).noReturn()
        }

        XCTAssertEqual(error, "Wanted both at least 1 times and at most 2 times but not invoked.")
    }

    func testVerifyNoMoreInteractionsFail() {
        let error = TestUtils.catchCuckooFail {
            let mock = MockTestedClass().withEnabledSuperclassSpy()

            mock.withOptionalClosure("a", closure: nil)
            mock.noReturn()
            _ = mock.count(characters: "b")
            let _ = mock.readWriteProperty
            mock.readWriteProperty = 1
            mock.withOptionalClosure("c", closure: { _ in })

            verifyNoMoreInteractions(mock)
        }

        XCTAssertEqual(error, ["No more interactions wanted but some found:",
                               "1. withOptionalClosure(\"a\", nil)",
                               "2. noReturn()",
                               "3. count(\"b\")",
                               "4. readWriteProperty#get",
                               "5. readWriteProperty#set(1)",
                               "6. withOptionalClosure(\"c\", Optional((Function)))"].joined(separator: "\n"))
    }
}

struct FailSwiftTestingTests {
    @Test
    func missingInvocation() {
        withKnownIssue {
            let mock = MockTestedClass()

            verify(mock).noReturn()
        } matching: { issue in
            issue.comments.map(\.rawValue) == [
                "Wanted 1 times but not invoked."
            ]
        }
    }

    @Test
    func noInvocation2Wanted() {
        withKnownIssue {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            mock.noReturn()

            verify(mock, times(2)).noReturn()
        } matching: { issue in
            issue.comments.map(\.rawValue) == [
                "Wanted 2 times but invoked 1 times."
            ]
        }
    }

    @Test
    func invocationNeverWanted() {
        withKnownIssue {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            mock.noReturn()

            verify(mock, never()).noReturn()
        } matching: { issue in
            issue.comments.map(\.rawValue) == [
                "Wanted never but invoked 1 times."
            ]
        }
    }

    @Test
    func invocationAtLeast2Wanted() {
        withKnownIssue {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            mock.noReturn()

            verify(mock, atLeast(2)).noReturn()
        } matching: { issue in
            issue.comments.map(\.rawValue) == [
                "Wanted at least 2 times but invoked 1 times."
            ]
        }
    }

    @Test
    func invocationAtMost1Wanted() {
        withKnownIssue {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            mock.noReturn()
            mock.noReturn()

            verify(mock, atMost(1)).noReturn()
        } matching: { issue in
            issue.comments.map(\.rawValue) == [
                "Wanted at most 1 times but invoked 2 times."
            ]
        }
    }

    @Test
    func callMatcherOr() {
        withKnownIssue {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }

            verify(mock, times(1).or(times(2))).noReturn()
        } matching: { issue in
            issue.comments.map(\.rawValue) == [
                "Wanted either 1 times or 2 times but not invoked."
            ]
        }
    }

    @Test
    func callMatcherAnd() {
        withKnownIssue {
            let mock = MockTestedClass()
            stub(mock) { mock in
                when(mock.noReturn()).thenDoNothing()
            }
            
            verify(mock, atLeast(1).and(atMost(2))).noReturn()
        } matching: { issue in
            issue.comments.map(\.rawValue) == [
                "Wanted both at least 1 times and at most 2 times but not invoked."
            ]
        }
    }

    @Test
    func verifyNoMoreInteractionsFail() {
        withKnownIssue {
            let mock = MockTestedClass().withEnabledSuperclassSpy()

            mock.withOptionalClosure("a", closure: nil)
            mock.noReturn()
            _ = mock.count(characters: "b")
            let _ = mock.readWriteProperty
            mock.readWriteProperty = 1
            mock.withOptionalClosure("c", closure: { _ in })

            verifyNoMoreInteractions(mock)
        } matching: { issue in
            issue.comments.map(\.rawValue) == [
                ["No more interactions wanted but some found:",
               "1. withOptionalClosure(\"a\", nil)",
               "2. noReturn()",
               "3. count(\"b\")",
               "4. readWriteProperty#get",
               "5. readWriteProperty#set(1)",
               "6. withOptionalClosure(\"c\", Optional((Function)))"
                ].joined(separator: "\n")
            ]
        }
    }
}
