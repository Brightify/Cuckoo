//
//  MethodParameter.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct MethodParameter: Token {
    public let label: String?
    public let name: String
    public let type: String
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    
    public var labelAndName: String {
        if let label = label {
            return label != name ? "\(label) \(name)" : name
        } else {
            return "_ \(name)"
        }
    }
    
    public var typeWithoutAttributes: String {
        return type.replacingOccurrences(of: "@escaping", with: "").replacingOccurrences(of: "@autoclosure", with: "").trimmed
    }

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? MethodParameter else { return false }
        return self.name == other.name
    }

    public func serialize() -> [String : Any] {
        return [
            "label": label,
            "name": name,
            "type": type,
            "labelAndName": labelAndName,
            "typeWithoutAttributes": typeWithoutAttributes
        ]
    }
}
