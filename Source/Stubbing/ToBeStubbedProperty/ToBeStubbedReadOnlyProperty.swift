//
//  ToBeStubbedReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedReadOnlyProperty<T> {
    private let manager: MockManager
    private let name: String
    
    public var get: StubFunction<Void, T> {
        return StubFunction(stub: manager.createStub(getterName(name), parameterMatchers: []))
    }
    
    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}
