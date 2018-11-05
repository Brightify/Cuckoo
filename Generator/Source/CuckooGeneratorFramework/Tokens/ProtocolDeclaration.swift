//
//  ProtocolDeclaration.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ProtocolDeclaration: ContainerToken {
    public let name: String
    public let accessibility: Accessibility
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    public let bodyRange: CountableRange<Int>
    public let initializers: [Initializer]
    public let children: [Token]
    public let implementation: Bool = false
    public let inheritedTypes: [InheritanceDeclaration]
    public let attributes: [Attribute] = []

    public func replace(children tokens: [Token]) -> ProtocolDeclaration {
        return ProtocolDeclaration(
            name: self.name,
            accessibility: self.accessibility,
            range: self.range,
            nameRange: self.nameRange,
            bodyRange: self.bodyRange,
            initializers: self.initializers,
            children: tokens,
            implementation: self.implementation
            inheritedTypes: self.inheritedTypes,
            attributes: self.attributes)
    }

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? ProtocolDeclaration else { return false }
        return self.name == other.name
    }
}
