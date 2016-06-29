//
//  ArgumentCaptor.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

// Can be used to capture arguments. It is recommended to use it only in verification and not stubbing.
public class ArgumentCaptor<T> {
    
    // Last captured argument if any.
    public var value: T? {
        return allValues.last
    }
    
    // All captured arguments.
    public private(set) var allValues: [T] = []
    
    public init() {

    }
    
    // Return matcher which capture the argument.
    public func capture() -> AnyMatcher<T> {
        return FunctionMatcher(function: {
            self.allValues.append($0)
            return true
        }) { _ in }.typeErased()
    }
}