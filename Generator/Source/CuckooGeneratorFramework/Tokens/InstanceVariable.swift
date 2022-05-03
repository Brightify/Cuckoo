//
//  InstanceVariable.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct InstanceVariable: Token, HasAccessibility, HasAttributes {
    public var name: String
    public var type: WrappableType
    public var accessibility: Accessibility
    public var setterAccessibility: Accessibility?
    public var range: CountableRange<Int>
    public var nameRange: CountableRange<Int>
    public var overriding: Bool
    public var attributes: [Attribute]

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
        let optionalString = type.isOptional && !readOnly ? "Optional" : ""

        return [
            "name": name,
            "type": type.sugarized,
            "nonOptionalType": type.unoptionaled.sugarized,
            "accessibility": accessibility.sourceName,
            "isReadOnly": readOnly,
            "stubType": (overriding ? "Class" : "Protocol") + "ToBeStubbed\(readOnlyString)\(optionalString)Property",
            "verifyType": "Verify\(readOnlyString)\(optionalString)Property",
            "attributes": attributes.filter { $0.isSupported },
            "hasUnavailablePlatforms": hasUnavailablePlatforms,
            "unavailablePlatformsCheck": unavailablePlatformsCheck,
        ]
    }
}
