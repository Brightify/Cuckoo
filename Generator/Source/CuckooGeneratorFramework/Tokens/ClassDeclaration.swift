//
//  ClassDeclaration.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ClassDeclaration: ContainerToken {
    public let name: String
    public let accessibility: Accessibility
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    public let bodyRange: CountableRange<Int>
    public let initializers: [Initializer]
    public let children: [Token]
    public let implementation: Bool = true
    public let inheritedTypes: [InheritanceDeclaration]
    public let attributes: [Attribute] = []
    
    public var hasNoArgInit: Bool {
        return initializers.filter { $0.parameters.isEmpty }.isEmpty
    }

    public func replace(children tokens: [Token]) -> ClassDeclaration {
        return ClassDeclaration(
            name: self.name,
            accessibility: self.accessibility,
            range: self.range,
            nameRange: self.nameRange,
            bodyRange: self.bodyRange,
            initializers: self.initializers,
            children: tokens,
            implementation: self.implementation,
            inheritedTypes: self.inheritedTypes,
            attributes: self.attributes)
    }

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? ClassDeclaration else { return false }
        return self.name == other.name
    }
}
