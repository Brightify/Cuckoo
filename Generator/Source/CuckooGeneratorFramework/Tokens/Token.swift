//
//  Token.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Token {
    func isEqual(to other: Token) -> Bool
}

public func ==(rhs: Token, lhs: Token) -> Bool  {
    return rhs.isEqual(to: lhs)
}

public extension Token {
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
