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
        if let setterAccessibility = setterAccessibility {
            return !setterAccessibility.isAccessible
        } else {
            return true
        }
    }

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? InstanceVariable else { return false }
        return self.name == other.name
    }

    public func serialize() -> [String : Any] {
        return [
            "name": name,
            "type": type,
            "accesibility": accessibility.sourceName,
            "isReadOnly": readOnly,
        ]
    }
}
