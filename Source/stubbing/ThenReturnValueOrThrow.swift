//
//  ThenReturnValueOrThrow.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ThenReturnValueOrThrow<IN, OUT> {
    let setOutput: (Any -> ReturnValueOrError) -> Void
    
    /// Invoke `implementation` when invoked.
    public func then(implementation: IN throws -> OUT) {
        setOutput {
            guard let parameters = $0 as? IN else { fatalError("Implementation called with wrong input type \($0.self). This is probably a bug in Cuckoo, please file a ticket.") }
            do {
                return try .ReturnValue(implementation(parameters))
            } catch let error {
                return .Error(error)
            }
        }
    }
    
    /// Return `output` when invoked.
    public func thenReturn(output: OUT) {
        setOutput { _ in .ReturnValue(output) }
    }
    
    /// Throw `error` when invoked.
    public func thenThrow(error: ErrorType) {
        setOutput { _ in .Error(error) }
    }
}
