//
//  Token.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Token {
    func isEqual(to other: Token) -> Bool

    func serialize() -> [String: Any]
}

public func ==(rhs: Token, lhs: Token) -> Bool  {
    return rhs.isEqual(to: lhs)
}

public extension Token {
    func serialize() -> [String: Any] {
        return [:]
    }

    func serializeWithType() -> [String: Any] {
        var serialized = serialize()
        serialized["@type"] = "\(type(of: self))"
        return serialized
    }

    public var isClassOrProtocolDefinition: Bool {
        switch self {
        case _ as ProtocolDeclaration:
            fallthrough
        case _ as ClassDeclaration:
            return true
        default:
            return false
        }
    }

    public var isInheritanceDefinition: Bool {
        switch self {
        case _ as InheritanceDeclaration:
            return true
        default:
            return false
        }
    }
}
