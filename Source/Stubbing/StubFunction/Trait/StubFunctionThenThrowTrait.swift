//
//  StubFunctionThenThrowTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenThrowTrait: BaseStubFunctionTrait {
    /// Throws `error` when invoked.
    func thenThrow(error: ErrorType, _ errors: ErrorType...) -> Self
}

public extension StubFunctionThenThrowTrait {
    func thenThrow(error: ErrorType, _ errors: ErrorType...) -> Self {
        ([error] + errors).forEach { error in
            stub.appendAction(.ThrowError(error))
        }
        return self
    }
}