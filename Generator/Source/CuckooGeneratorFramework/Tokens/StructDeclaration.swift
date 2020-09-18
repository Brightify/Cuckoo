//
//  StructDeclaration.swift
//  CuckooGeneratorFramework
//
//  Created by Tyler Thompson on 9/18/20.
//

import Foundation

public struct StructDeclaration: ParentToken {
    // NOTE: Purely for supporting nested classes, could be any generic parent (like extensions)
    public let name: String
    public var accessibility: Accessibility
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    public let bodyRange: CountableRange<Int>
    public var attributes: [Attribute]
    public let children: [Token]
    
    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? StructDeclaration else { return false }
        return self.name == other.name
    }
}
