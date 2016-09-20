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
    
    // Return parameter matcher which capture the argument.
    public func capture() -> ParameterMatcher<T> {
        return ParameterMatcher {
            self.allValues.append($0)
            return true
        }
    }
}
