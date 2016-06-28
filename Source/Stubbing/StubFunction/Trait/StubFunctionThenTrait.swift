//
//  StubFunctionThenTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenTrait: BaseStubFunctionTrait {
    /// Invoke `implementation` when invoked.
    func then(implementation: IN -> OUT) -> Self
}

public extension StubFunctionThenTrait {
    func then(implementation: IN -> OUT) -> Self {
        stub.actions.append(.CallImplementation(implementation))
        return self
    }
}