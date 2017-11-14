//
//  StubFunctionThenDoNothingTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenDoNothingTrait: BaseStubFunctionTrait {   
    /// Does nothing when invoked.
    func thenDoNothing() -> Self
}

public extension StubFunctionThenDoNothingTrait where OutputType == Void {
    @discardableResult
    func thenDoNothing() -> Self {
        stub.appendAction(.returnValue(Void()))
        return self
    }
}
