//
//  StubThrowingFunction.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StubThrowingFunction<IN, OUT> {
    let stub: ConcreteStub<IN, OUT>
    
    /// Invoke `implementation` when invoked.
    public func then(implementation: IN throws -> OUT) -> StubThrowingFunction {
        stub.actions.append(.CallImplementation(implementation))
        return self
    }
    
    /// Return `output` when invoked.
    public func thenReturn(output: OUT, _ outputs: OUT...) -> StubThrowingFunction {
        ([output] + outputs).forEach { output in
            stub.actions.append(.ReturnValue(output))
        }
        return self
    }
    
    /// Throw `error` when invoked.
    public func thenThrow(error: ErrorType, _ errors: ErrorType...) -> StubThrowingFunction {
        ([error] + errors).forEach { error in
            stub.actions.append(.ThrowError(error))
        }
        return self
    }
    
    /// Invoke real implementation when invoked.
    public func thenCallRealImplementation() -> StubThrowingFunction {
        stub.actions.append(.CallRealImplementation)
        return self
    }
}
