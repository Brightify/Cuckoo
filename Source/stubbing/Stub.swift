//
//  Stub.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public class Stub {
    let name: String
    let parameterMatchers: [AnyMatcher<Any>]
    var outputs: [Any -> ReturnValueOrError] = []
    
    init(name: String, parameterMatchers: [AnyMatcher<Any>]) {
        self.name = name
        self.parameterMatchers = parameterMatchers
    }
}