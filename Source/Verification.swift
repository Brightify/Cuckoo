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
    let matcher: AnyMatcher<Stub?>
    let verifyCall: (method: String, parameters: Any, matcher: AnyMatcher<Stub?>) -> ()
    
    public func verify(method: String) {
        return verify(method, parameters: Void())
    }
    
    public func verify<IN>(method: String, parameters: IN) {
        verifyCall(method: method, parameters: parameters, matcher: matcher)
    }
}
