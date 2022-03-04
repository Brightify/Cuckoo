//
//  ObjectiveAssertThrows.swift
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import XCTest

public func objectiveAssertThrows<OUT>(message: String = "Expected the method to throw.", file: StaticString = #file, line: UInt = #line, errorHandler: (Error) -> Void = { _ in }, _ invocation: @autoclosure @escaping () -> OUT) {
    do {
        try ObjectiveCatcher.catchException {
            _ = invocation()
        }
        XCTFail(message, file: file, line: line)
    } catch {
        errorHandler(error)
    }
}
