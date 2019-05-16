//
//  ToBeStubbedReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol ToBeStubbedReadOnlyProperty {
    associatedtype GetterType: StubFunction

    var get: GetterType { get }
}

public struct ProtocolToBeStubbedReadOnlyProperty<MOCK: ProtocolMock, T>: ToBeStubbedReadOnlyProperty {
    private let manager: MockManager
    private let name: String
    
    public var get: ProtocolStubFunction<Void, T> {
        return ProtocolStubFunction(stub:
            manager.createStub(for: MOCK.self, method: getterName(name), parameterMatchers: []))
    }
    
    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}

public struct ClassToBeStubbedReadOnlyProperty<MOCK: ClassMock, T>: ToBeStubbedReadOnlyProperty {
    private let manager: MockManager
    private let name: String

    public var get: ClassStubFunction<Void, T> {
        return ClassStubFunction(stub:
            manager.createStub(for: MOCK.self, method: getterName(name), parameterMatchers: []))
    }

    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}
