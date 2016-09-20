//
//  StubFunctionThenCallRealImplementationTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenCallRealImplementationTrait: BaseStubFunctionTrait {
    /// Invokes real implementation when invoked.
    func thenCallRealImplementation() -> Self
}

public extension StubFunctionThenCallRealImplementationTrait {
    @discardableResult
    func thenCallRealImplementation() -> Self {
        stub.appendAction(.callRealImplementation)
        return self
    }
}
