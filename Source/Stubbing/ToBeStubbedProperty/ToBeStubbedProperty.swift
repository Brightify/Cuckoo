//
//  ToBeStubbedProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedProperty<T> {
    private let cuckoo_manager: MockManager
    private let name: String
    
    public var get: StubFunction<Void, T> {
        return StubFunction(stub: cuckoo_manager.createStub(getterName(name), parameterMatchers: []))
    }
    
    public func set<M: Matchable>(_ matcher: M) -> StubNoReturnFunction<T> where M.MatchedType == T {
        return StubNoReturnFunction(stub: cuckoo_manager.createStub(setterName(name), parameterMatchers: [matcher.matcher]))
    }
    
    public init(cuckoo_manager: MockManager, name: String) {
        self.cuckoo_manager = cuckoo_manager
        self.name = name
    }
}
