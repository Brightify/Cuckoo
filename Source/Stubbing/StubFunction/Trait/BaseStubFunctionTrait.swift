//
//  BaseStubFunctionTrait.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 27.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol BaseStubFunctionTrait {
    associatedtype IN
    associatedtype OUT
    associatedtype SELF
    
    var stub: ConcreteStub<IN, OUT> { get }
    // It is not possible to write SELF: Base
    var this: SELF { get }
}
