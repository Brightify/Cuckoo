//
//  MethodParameter.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct MethodParameter: Token, Equatable {
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
        return self.name == other.name && self.type == other.type && self.label == other.label
    }
    
    public var isClosure: Bool {        
        return typeWithoutAttributes.hasPrefix("(") && typeWithoutAttributes.range(of: "->") != nil
    }
    
    public var isEscaping: Bool {
        return isClosure && (type.hasPrefix("@escaping") || type.hasSuffix(")?"))
    }
    
    public func serialize() -> [String : Any] {
        return [
            "label": label ?? "",
            "name": name,
            "type": type,
            "labelAndName": labelAndName,
            "typeWithoutAttributes": typeWithoutAttributes,
            "isClosure": isClosure,
            "isEscaping": isEscaping
        ]
    }
}

public func ==(lhs: MethodParameter, rhs: MethodParameter) -> Bool {
    return lhs.isEqual(to: rhs)
}
