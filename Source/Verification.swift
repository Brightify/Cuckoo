//
//  Verification.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol VerificationProxy {
    init(handler: VerificationHandler)
}

public struct VerificationHandler {
    let matcher: AnyMatcher<[StubCall]>
    let verifyCall: (method: String, file: String, line: UInt, callMatcher: AnyMatcher<StubCall>, verificationMatcher: AnyMatcher<[StubCall]>) -> ()

    public func verify<OUT>(method: String, file: String, line: UInt) -> __DoNotUse<OUT> {
        return verify(method, file: file, line: line, parameterMatchers: [] as [AnyMatcher<Void>])
    }

    public func verify<IN, OUT>(method: String, file: String, line: UInt, parameterMatchers: [AnyMatcher<IN>]) -> __DoNotUse<OUT> {
        return verify(method, file: file, line: line, callMatcher: callMatcher(method, parameterMatchers: parameterMatchers))
    }

    public func verify<OUT>(method: String, file: String, line: UInt, callMatcher: AnyMatcher<StubCall>) -> __DoNotUse<OUT> {
        verifyCall(method: method, file: file, line: line, callMatcher: callMatcher, verificationMatcher: matcher)
        return __DoNotUse()
    }
}

public struct __DoNotUse<T> { }

// parameterMatcher<IN, M: Matchable>(mapping: IN -> M) -> AnyMatcher<StubCall>

public func parameterMatcher<IN, PARAM, M: Matcher where M.MatchedType == PARAM>(matcher: M, mapping: IN -> PARAM) -> AnyMatcher<IN> {
    let function: IN -> Bool = {
        return matcher.matches(mapping($0))
    }
    let describeMismatch: (IN, Description) -> Void = {
        matcher.describeMismatch(mapping($0), to: $1)
    }

    return FunctionMatcher(function: function, describeMismatch: describeMismatch, describeTo: matcher.describeTo).typeErased()
}

internal func callMatcher<IN>(method: String, parameterMatchers: [AnyMatcher<IN>]) -> AnyMatcher<StubCall> {
    let typeErasedParameterMatchers: [AnyMatcher<Any>] = parameterMatchers.map(AnyMatcher.init)

    let function: StubCall -> Bool = { call in
        typeErasedParameterMatchers.reduce(call.method == method) {
            $0 && $1.matches(call.parameters)
        }
    }
    let description: Description -> Void = {
        if method != method {
            $0.appendText("method name").appendValue(method)
        }
        // FIXME Describe params
        //typedMatcher.describeTo($0)
    }

    return FunctionMatcher(function: function, describeTo: description).typeErased()
}
