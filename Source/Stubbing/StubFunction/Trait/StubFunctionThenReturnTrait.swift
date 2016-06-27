//
//  StubFunctionThenReturnTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenReturnTrait: BaseStubFunctionTrait {
    /// Return `output` when invoked.
    func thenReturn(output: OUT, _ outputs: OUT...) -> SELF
}

public extension StubFunctionThenReturnTrait {
    func thenReturn(output: OUT, _ outputs: OUT...) -> SELF {
        ([output] + outputs).forEach { output in
            stub.actions.append(.ReturnValue(output))
        }
        return this
    }
}
