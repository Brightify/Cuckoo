//
//  VerificationHandler.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

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