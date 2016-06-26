//
//  StubFunction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StubFunction<IN, OUT> {
    let stub: ConcreteStub<IN, OUT>
    
    /// Invoke `implementation` when invoked.
    public func then(implementation: IN -> OUT) -> StubFunction {
        stub.actions.append(.CallImplementation(implementation))
        return self
    }
    
    /// Return `output` when invoked.
    public func thenReturn(output: OUT, _ outputs: OUT...) -> StubFunction {
        ([output] + outputs).forEach { output in
            stub.actions.append(.ReturnValue(output))
        }
        return self
    }
    
    /// Invoke real implementation when invoked.
    public func thenCallRealImplementation() -> StubFunction {
        stub.actions.append(.CallRealImplementation)
        return self
    }
}