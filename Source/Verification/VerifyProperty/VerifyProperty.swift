//
//  VerifyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct VerifyProperty<T> {
    private let name: String
    private let handler: VerificationHandler
    
    public var get: __DoNotUse<T> {
        return handler.verify(getterName(name), parameterMatchers: [] as [AnyMatcher<Void>])
    }
    
    public func set<M: Matchable where M.MatchedType == T>(matcher: M) -> __DoNotUse<Void> {
        return handler.verify(setterName(name), parameterMatchers: [matcher.matcher])
    }
    
    public init(name: String, handler: VerificationHandler) {
        self.name = name
        self.handler = handler
    }
}
