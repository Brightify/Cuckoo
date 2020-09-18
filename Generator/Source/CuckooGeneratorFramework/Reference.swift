//
//  Reference.swift
//  CuckooGeneratorFramework
//
//  Created by Tyler Thompson on 9/18/20.
//

import Foundation

@dynamicMemberLookup
public final class Reference<Value> {
    private(set) var value: Value
    
    public init(value: Value) {
        self.value = value
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
