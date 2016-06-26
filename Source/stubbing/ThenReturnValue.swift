//
//  ThenReturnValue.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ThenReturnValue<IN, OUT> {
    let setOutput: (Any -> OnStubCall) -> Void
    
    /// Invoke `implementation` when invoked.
    public func then(implementation: IN -> OUT) {
        setOutput {
            guard let parameters = $0 as? IN else { fatalError("Implementation called with wrong input type \($0.self). This is probably a bug in Cuckoo, please file a ticket.") }
            return .ReturnValue(implementation(parameters))
        }
    }
    
    /// Return `output` when invoked.
    public func thenReturn(output: OUT) {
        setOutput { _ in .ReturnValue(output) }
    }
    
    /// Invoke real implementation when invoked.
    public func thenCallRealImplementation() {
        setOutput { _ in .CallRealImplementation }
    }
}