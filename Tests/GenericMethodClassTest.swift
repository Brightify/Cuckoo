//
//  GenericMethodClassTest.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 14/05/2019.
//

import XCTest
import Cuckoo

class GenericMethodClassTest: XCTestCase {
    private var kawaiiMock: MockGenericMethodClass<Int>!
    private var angeryMock: MockGenericMethodClass<Int>!
    private var original: GenericMethodClass<Int>!

    override func setUp() {
        super.setUp()

        kawaiiMock = MockGenericMethodClass()
        angeryMock = MockGenericMethodClass()
        original = GenericMethodClass()
    }

    func testRethrowing() {
        let matcher = anyThrowingClosure() as ParameterMatcher<() throws -> Void>

        stub(kawaiiMock) { mock in
            when(mock.someRethrowing(param: matcher)).thenDoNothing()
            when(mock.moreRethrowing(param: matcher)).thenReturn(())
            when(mock.noticeMe(param: matcher)).thenReturn({ (intka: Int) -> (Void) in () })
        }

        kawaiiMock.someRethrowing(param: { })
        kawaiiMock.moreRethrowing(param: { })
        kawaiiMock.noticeMe(param: { })(1)
        verify(kawaiiMock).someRethrowing(param: matcher)
        verify(kawaiiMock).moreRethrowing(param: matcher)
        verify(kawaiiMock).noticeMe(param: matcher)


        stub(angeryMock) { mock in
            when(mock.someRethrowing(param: matcher)).thenThrow(TestError.unknown)
            when(mock.moreRethrowing(param: matcher)).thenThrow(TestError.unknown)
            when(mock.noticeMe(param: matcher)).thenThrow(TestError.unknown)
        }

        XCTAssertThrowsError(try angeryMock.someRethrowing(param: { throw TestError.unknown }))
        XCTAssertThrowsError(try angeryMock.moreRethrowing(param: { throw TestError.unknown }))
        XCTAssertThrowsError(try angeryMock.noticeMe(param: { throw TestError.unknown })(1))
        verify(angeryMock).someRethrowing(param: matcher)
        verify(angeryMock).moreRethrowing(param: matcher)
        verify(angeryMock).noticeMe(param: matcher)
    }
}
