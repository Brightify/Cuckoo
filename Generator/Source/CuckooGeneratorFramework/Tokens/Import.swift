//
//  Import.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 17.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct Import: Token {
    public let range: CountableRange<Int>
    public let library: String

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? Import else { return false }
        return self.range == other.range && self.library == other.library
    }
}
