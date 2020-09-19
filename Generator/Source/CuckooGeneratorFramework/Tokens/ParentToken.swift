//
//  ParentToken.swift
//  CuckooGeneratorFramework
//
//  Created by thompsty on 9/18/20.
//

import Foundation

public protocol ParentToken: Token, HasAccessibility {
    var name: String { get }
    var range: CountableRange<Int> { get }
    var nameRange: CountableRange<Int> { get }
    var bodyRange: CountableRange<Int> { get }
    var children: [Token] { get }
}
