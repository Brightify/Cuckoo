//
//  VerificationHandler.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest

public struct VerificationHandler {
    let callMatcher: CallMatcher
    let sourceLocation: SourceLocation
    let getStubCallsFor: (method: String, parameterMatchers: [AnyMatcher<Any>]) -> [StubCall]
    
    public func verify<IN, OUT>(method: String, parameterMatchers: [AnyMatcher<IN>]) -> __DoNotUse<OUT> {
        let calls = getStubCallsFor(method: method, parameterMatchers: parameterMatchers.map { AnyMatcher($0) })
        if callMatcher.matches(calls) == false {
            let description = Description()
            description
                .append(text: "Expected ")
                .append(descriptionOf: callMatcher)
                .append(text: ", but ")
            callMatcher.describeMismatch(calls, to: description)
            
            XCTFail(description.description, file: sourceLocation.file, line: sourceLocation.line)
        }
        return __DoNotUse()
    }
}