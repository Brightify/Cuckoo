//
//  InstanceVariable.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct InstanceVariable: Token {
    public let name: String
    public let type: String
    public let accessibility: Accessibility
    public let setterAccessibility: Accessibility?
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    public var overriding: Bool
    public let attributes: [Attribute]

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
        let readOnlyString = readOnly ? "ReadOnly" : ""
        return [
            "name": name,
            "type": type,
            "accessibility": accessibility.sourceName,
            "isReadOnly": readOnly,
            "stubType": overriding ? "ClassToBeStubbed\(readOnlyString)Property" : "ProtocolToBeStubbed\(readOnlyString)Property",
            "attributes": attributes.filter { $0.isSupported },
        ]
    }
}
