//
//  VerifyReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct VerifyReadOnlyProperty<T> {
    let name: String
    let handler: VerificationHandler
    
    public var get: __DoNotUse<T> {
        return handler.verify(getterName(name))
    }
}