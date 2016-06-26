//
//  ThenReturnValueOrThrow.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ThenReturnValueOrThrow<IN, OUT> {
    let stub: Stub
    
    /// Invoke `implementation` when invoked.
    public func then(implementation: IN throws -> OUT) -> ThenReturnValueOrThrow {
        stub.outputs.append {
            guard let parameters = $0 as? IN else { fatalError("Implementation called with wrong input type \($0.self). This is probably a bug in Cuckoo, please file a ticket.") }
            do {
                return try .ReturnValue(implementation(parameters))
            } catch let error {
                return .Error(error)
            }
        }
        return self
    }
    
    /// Return `output` when invoked.
    public func thenReturn(output: OUT, _ outputs: OUT...) -> ThenReturnValueOrThrow {
        ([output] + outputs).forEach { output in
            stub.outputs.append { _ in .ReturnValue(output) }
        }
        return self
    }
    
    /// Throw `error` when invoked.
    public func thenThrow(error: ErrorType, _ errors: ErrorType...) -> ThenReturnValueOrThrow {
        ([error] + errors).forEach { error in
            stub.outputs.append { _ in .Error(error) }
        }
        return self
    }
    
    /// Invoke real implementation when invoked.
    public func thenCallRealImplementation() -> ThenReturnValueOrThrow {
        stub.outputs.append { _ in .CallRealImplementation }
        return self
    }
}
