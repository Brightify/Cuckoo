//
//  ThenReturnValue.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ThenReturnValue<IN, OUT> {
    let stub: Stub
    
    /// Invoke `implementation` when invoked.
    public func then(implementation: IN -> OUT) -> ThenReturnValue {
        stub.outputs.append {
            guard let parameters = $0 as? IN else { fatalError("Implementation called with wrong input type \($0.self). This is probably a bug in Cuckoo, please file a ticket.") }
            return .ReturnValue(implementation(parameters))
        }
        return self
    }
    
    /// Return `output` when invoked.
    public func thenReturn(output: OUT, _ outputs: OUT...) -> ThenReturnValue {
        ([output] + outputs).forEach { output in
            stub.outputs.append { _ in .ReturnValue(output) }
        }
        return self
    }
    
    /// Invoke real implementation when invoked.
    public func thenCallRealImplementation() -> ThenReturnValue {
        stub.outputs.append { _ in .CallRealImplementation }
        return self
    }
}