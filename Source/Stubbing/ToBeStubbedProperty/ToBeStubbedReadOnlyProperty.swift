//
//  ToBeStubbedReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedReadOnlyProperty<T> {
    let handler: StubbingHandler
    
    let name: String
    
    public var get: ToBeStubbedFunction<Void, T> {
        return ToBeStubbedFunction(handler: handler, name: getterName(name), parameterMatchers: [])
    }
}