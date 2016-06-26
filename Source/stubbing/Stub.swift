//
//  Stub.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct Stub {
    let name: String
    let parameterMatchers: [AnyMatcher<Any>]
    let output: Any -> OnStubCall
}