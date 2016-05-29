//
//  VerifyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

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
