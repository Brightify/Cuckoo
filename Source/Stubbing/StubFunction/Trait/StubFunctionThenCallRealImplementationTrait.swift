//
//  StubFunctionThenCallRealImplementationTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenCallRealImplementationTrait: BaseStubFunctionTrait {
    /// Invoke real implementation when invoked.
    func thenCallRealImplementation() -> Self
}

public extension StubFunctionThenCallRealImplementationTrait {
    public func thenCallRealImplementation() -> Self {
        stub.appendAction(.CallRealImplementation)
        return self
    }
}