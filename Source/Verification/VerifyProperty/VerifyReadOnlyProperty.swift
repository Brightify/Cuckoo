//
//  VerifyReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct VerifyReadOnlyProperty<T> {
    private let name: String
    private let handler: VerificationHandler
    
    public var get: __DoNotUse<T> {
        return handler.verify(getterName(name), parameterMatchers: [] as [AnyMatcher<Void>])
    }
    
    public init(name: String, handler: VerificationHandler) {
        self.name = name
        self.handler = handler
    }
}