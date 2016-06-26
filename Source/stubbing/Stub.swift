//
//  Stub.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Stub {
    var name: String { get }
}

public class ConcreteStub<IN, OUT>: Stub {
    public let name: String
    let parameterMatchers: [AnyMatcher<IN>]
    var actions: [StubAction<IN, OUT>] = []
    
    init(name: String, parameterMatchers: [AnyMatcher<IN>]) {
        self.name = name
        self.parameterMatchers = parameterMatchers
    }
}