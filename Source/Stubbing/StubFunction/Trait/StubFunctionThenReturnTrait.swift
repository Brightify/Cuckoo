//
//  StubFunctionThenReturnTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenReturnTrait: BaseStubFunctionTrait {
    /// Returns `output` when invoked.
    func thenReturn(_ output: OutputType, _ outputs: OutputType...) -> Self
}

public extension StubFunctionThenReturnTrait {
    @discardableResult
    func thenReturn(_ output: OutputType, _ outputs: OutputType...) -> Self {
        ([output] + outputs).forEach { output in
            stub.appendAction(.returnValue(output))
        }
        return self
    }
}
