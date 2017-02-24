//
//  ToBeStubbedReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedReadOnlyProperty<T> {
    private let cuckoo_manager: MockManager
    private let name: String
    
    public var get: StubFunction<Void, T> {
        return StubFunction(stub: cuckoo_manager.createStub(getterName(name), parameterMatchers: []))
    }
    
    public init(cuckoo_manager: MockManager, name: String) {
        self.cuckoo_manager = cuckoo_manager
        self.name = name
    }
}
