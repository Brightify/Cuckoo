//
//  MethodParameter.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct MethodParameter: Token, Equatable {
    public var label: String?
    public var name: String
    public var type: WrappableType
    public var range: CountableRange<Int>
    public var nameRange: CountableRange<Int>?
    public var isInout: Bool

    public var labelAndName: String {
        if let label = label {
            return label != name ? "\(label) \(name)" : name
        } else {
            return "_ \(name)"
        }
    }

    public var typeWithoutAttributes: String {
        return type.withoutAttributes.sugarized.trimmed
    }

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? MethodParameter else { return false }
        return label == other.label && type == other.type
    }

    public var isClosure: Bool {
        return typeWithoutAttributes.hasPrefix("(") && typeWithoutAttributes.range(of: "->") != nil
    }

    public var isOptional: Bool {
        return type.isOptional
    }

    public var closureParamCount: Int {
        // make sure that the parameter is a closure and that it's not just an empty `() -> ...` closure
        guard isClosure && !"^\\s*\\(\\s*\\)".regexMatches(typeWithoutAttributes) else { return 0 }

        var parenLevel = 0
        var parameterCount = 1
        for character in typeWithoutAttributes {
            switch character {
            case "(", "<":
                parenLevel += 1
            case ")", ">":
                parenLevel -= 1
            case ",":
                parameterCount += parenLevel == 1 ? 1 : 0
            default:
                break
            }
            if parenLevel == 0 {
                break
            }
        }

        return parameterCount
    }

    public var isEscaping: Bool {
        return isClosure && (type.containsAttribute(named: "@escaping") || type.isOptional)
    }

    public func serialize() -> [String : Any] {
        return [
            "label": label ?? "",
            "name": name,
            "type": type,
            "labelAndName": labelAndName,
            "typeWithoutAttributes": typeWithoutAttributes,
            "isClosure": isClosure,
            "isOptional": isOptional,
            "isEscaping": isEscaping
        ]
    }
}

public func ==(lhs: MethodParameter, rhs: MethodParameter) -> Bool {
    return lhs.isEqual(to: rhs)
}
