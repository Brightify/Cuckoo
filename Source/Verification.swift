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
    let sourceLocation: SourceLocation
    let verifyCall: (method: String, sourceLocation: SourceLocation, callMatcher: AnyMatcher<StubCall>, verificationMatcher: AnyMatcher<[StubCall]>) -> ()

    public func verifyProperty<T>(property: String) -> VerifyProperty<T> {
        return VerifyProperty(name: property, handler: self)
    }
    
    public func verifyReadOnlyProperty<T>(property: String) -> VerifyReadOnlyProperty<T> {
        return VerifyReadOnlyProperty(name: property, handler: self)
    }
    
    public func verify<OUT>(method: String) -> __DoNotUse<OUT> {
        return verify(method, parameterMatchers: [] as [AnyMatcher<Void>])
    }

    public func verify<IN, OUT>(method: String, parameterMatchers: [AnyMatcher<IN>]) -> __DoNotUse<OUT> {
        return verify(method, callMatcher: callMatcher(method, parameterMatchers: parameterMatchers))
    }

    public func verify<OUT>(method: String, callMatcher: AnyMatcher<StubCall>) -> __DoNotUse<OUT> {
        verifyCall(method: method, sourceLocation: sourceLocation, callMatcher: callMatcher, verificationMatcher: matcher)
        return __DoNotUse()
    }
}

/// Marker struct for use as a return type in verification.
public struct __DoNotUse<T> { }

public struct VerifyReadOnlyProperty<T> {
    let name: String
    let handler: VerificationHandler
    
    public var get: __DoNotUse<T> {
        return handler.verify(getterName(name))
    }
}

public struct VerifyProperty<T> {
    let name: String
    let handler: VerificationHandler
    
    public var get: __DoNotUse<T> {
        return handler.verify(getterName(name))
    }
    
    public func set<M: Matchable where M.MatchedType == T>(matcher: M) -> __DoNotUse<Void> {
        return handler.verify(setterName(name), parameterMatchers: [matcher.matcher])
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
