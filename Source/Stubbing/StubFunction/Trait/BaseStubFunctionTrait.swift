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

    var stub: ConcreteStub<IN, OUT> { get }
}
