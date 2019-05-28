//
//  ObjectiveVerify.swift
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import XCTest

extension XCTestCase {
    public func objectiveVerify<OUT>(_ invocation: @autoclosure () -> OUT, file: StaticString = #file, line: UInt = #line) {
        OCMMacroState.beginVerifyMacro(at: OCMLocation(testCase: self, file: String(file), line: line))
        _ = invocation()
        OCMMacroState.endVerifyMacro()
    }
}

private extension String {
    init(_ staticString: StaticString) {
        self = staticString.withUTF8Buffer {
            String(decoding: $0, as: UTF8.self)
        }
    }
}
