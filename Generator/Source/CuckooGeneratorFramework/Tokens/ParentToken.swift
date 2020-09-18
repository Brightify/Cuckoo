//
//  ParentToken.swift
//  CuckooGeneratorFramework
//
//  Created by Tyler Thompson on 9/18/20.
//

import Foundation

public protocol ParentToken: Token, HasAccessibility, HasAttributes {
    var name: String { get }
    var range: CountableRange<Int> { get }
    var nameRange: CountableRange<Int> { get }
    var bodyRange: CountableRange<Int> { get }
    var children: [Token] { get }
}

extension ParentToken {
    
    var fullyQualifiedName: String {
        var names = [name]
        var parent: ParentToken? = (self as? ChildToken)?.parent?.value
        while let p = parent {
            names.insert(p.name, at: 0)
            parent = (p as? ChildToken)?.parent?.value
        }
        return names.joined(separator: ".")
    }
    
    var areAllHierarchiesAccessible: Bool {
        guard accessibility.isAccessible else { return false }
        var parent: ParentToken? = (self as? ChildToken)?.parent?.value
        while let p = parent {
            guard p.accessibility.isAccessible else { return false }
            parent = (p as? ChildToken)?.parent?.value
        }
        return true
    }
    
    func adoptAllYoungerGenerations() -> [ParentToken] {
        let parentReference: Reference<ParentToken> = Reference(value: self)
        return children
            .compactMap { child -> ParentToken? in
                guard var c = child as? ContainerToken else { return nil }
                c.parent = parentReference
                return c
            }
            .flatMap { [$0] + $0.adoptAllYoungerGenerations() }
    }
}
