//
//  VerificationFunctions.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

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
            $0.append("method name", method)
        }
        // FIXME Describe params
        //typedMatcher.describeTo($0)
    }
    
    return FunctionMatcher(function: function, describeTo: description).typeErased()
}
