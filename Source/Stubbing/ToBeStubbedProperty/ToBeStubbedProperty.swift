//
//  ToBeStubbedProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ToBeStubbedProperty<T> {
    let handler: StubbingHandler
    
    let name: String
    
    public var get: ToBeStubbedFunction<Void, T> {
        return ToBeStubbedFunction(handler: handler, name: getterName(name), parameterMatchers: [])
    }
    
    public func set<M: Matchable where M.MatchedType == T>(matcher: M) -> ToBeStubbedFunction<T, Void> {
        return ToBeStubbedFunction(handler: handler, name: setterName(name), parameterMatchers: [matcher.matcher])
    }
}