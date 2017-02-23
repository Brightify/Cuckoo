//
//  ExtensionDeclaration.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 17.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ExtensionDeclaration: Token {
    // TODO Implement support for extensions
    public let range: CountableRange<Int>

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? ExtensionDeclaration else { return false }
        return self.range == other.range
    }
}
