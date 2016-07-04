//
//  Utils.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

internal func getterName(property: String) -> String {
    return property + "#get"
}

internal func setterName(property: String) -> String {
    return property + "#set"
}

public func markerFunction<IN, OUT>(input: IN.Type = IN.self, _ output: OUT.Type = OUT.self) -> IN -> OUT {
    return { _ in
        assert(false, "Marker function cannot be called. This may happen if @noescape closure is called in mocked function.")
        // Will never be called, but Swift cannot infer the type without it
        return OUT.self as! OUT
    }
}

public func parameterMatcher<IN, PARAM, M: Matcher where M.MatchedType == PARAM>(matcher: M, mapping: IN -> PARAM) -> AnyMatcher<IN> {
    let function: IN -> Bool = {
        return matcher.matches(mapping($0))
    }
    let describeMismatch: (IN, Description) -> Void = {
        matcher.describeMismatch(mapping($0), to: $1)
    }
    
    return FunctionMatcher(function: function, describeMismatch: describeMismatch, describeTo: matcher.describeTo).typeErased()
}

public typealias SourceLocation = (file: StaticString, line: UInt)