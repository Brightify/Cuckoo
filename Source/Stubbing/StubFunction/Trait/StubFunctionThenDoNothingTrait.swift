//
//  StubFunctionThenDoNothingTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubFunctionThenDoNothingTrait: BaseStubFunctionTrait {   
    /// Do nothing when invoked.
    func thenDoNothing() -> SELF
}

public extension StubFunctionThenDoNothingTrait where OUT == Void {
    func thenDoNothing() -> SELF {
        stub.actions.append(.ReturnValue(Void()))
        return this
    }
}
