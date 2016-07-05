//
//  StubFunctionThenReturnTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenReturnTrait: BaseStubFunctionTrait {
    /// Returns `output` when invoked.
    func thenReturn(output: OUT, _ outputs: OUT...) -> Self
}

public extension StubFunctionThenReturnTrait {
    func thenReturn(output: OUT, _ outputs: OUT...) -> Self {
        ([output] + outputs).forEach { output in
            stub.appendAction(.ReturnValue(output))
        }
        return self
    }
}
