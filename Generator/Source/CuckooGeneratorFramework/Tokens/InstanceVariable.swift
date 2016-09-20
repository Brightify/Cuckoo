//
//  InstanceVariable.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct InstanceVariable: Token {
    public var name: String
    public var type: String
    public var accessibility: Accessibility
    public var setterAccessibility: Accessibility?
    public var range: CountableRange<Int>
    public var nameRange: CountableRange<Int>
    public var overriding: Bool
    
    public var readOnly: Bool {
        return setterAccessibility == nil
    }
}
