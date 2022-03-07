//
//  ObjectiveVerify.swift
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import XCTest
import OCMock

extension XCTestCase {
    /**
     * Objective-C equivalent to Cuckoo's own `verify`.
     * - parameter invocation: Autoclosured invocation of the method/variable that is being verified.
     * - parameter quantifier: Verification to assert how many times the call was made.
     */
    public func objcVerify<OUT>(_ invocation: @autoclosure () -> OUT, _ quantifier: OCMQuantifier = .atLeast(1), file: StaticString = #file, line: UInt = #line) {
        OCMMacroState.beginVerifyMacro(at: OCMLocation(testCase: self, file: String(file), line: line), with: quantifier)
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
