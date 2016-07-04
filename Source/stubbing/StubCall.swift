//
//  StubCall.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubCall {
    var method: String { get }
}

public struct ConcreteStubCall<IN>: StubCall {
    public let method: String
    let parameters: IN
    
    public init(method: String, parameters: IN) {
        self.method = method
        self.parameters = parameters
    }
}