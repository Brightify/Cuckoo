//
//  ExtensionDeclaration.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 17.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ExtensionDeclaration: ParentToken {
    // TODO Implement support for extensions
    public let name: String
    public var accessibility: Accessibility
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    public let bodyRange: CountableRange<Int>
    public var attributes: [Attribute]
    public let children: [Token]
    
    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? ExtensionDeclaration else { return false }
        return self.range == other.range
    }
}
