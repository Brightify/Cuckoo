//
//  GenericParameter.swift
//  CuckooGeneratorFramework
//
//  Created by Matyáš Kříž on 19/11/2018.
//

import Foundation

public struct GenericParameter: Token {
    public let name: String
    public let range: CountableRange<Int>
    public let inheritedType: InheritanceDeclaration?

    public var description: String {
        let hasInheritedType = inheritedType != nil
        return "\(name)\(hasInheritedType ? ": " : "")\(inheritedType?.name ?? "")"
    }

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? GenericParameter else { return false }
        return self.name == other.name && self.range == other.range && self.inheritedType?.name == other.inheritedType?.name
    }

    public func serialize() -> [String : Any] {
        return [
            "name": name,
            "inheritedType": inheritedType,
        ]
    }
}
