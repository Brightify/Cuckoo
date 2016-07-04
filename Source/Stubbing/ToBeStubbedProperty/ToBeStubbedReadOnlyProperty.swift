//
//  ToBeStubbedReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedReadOnlyProperty<T> {
    private let handler: StubbingHandler
    private let name: String
    
    public var get: StubFunction<Void, T> {
        return StubFunction(stub: handler.createStub(getterName(name), parameterMatchers: []))
    }
    
    public init(handler: StubbingHandler, name: String) {
        self.handler = handler
        self.name = name
    }
}