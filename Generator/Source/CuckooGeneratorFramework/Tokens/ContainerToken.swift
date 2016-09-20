//
//  ContainerToken.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol ContainerToken: Token {
    var name: String { get }
    var accessibility: Accessibility { get }
    var range: CountableRange<Int> { get }
    var nameRange: CountableRange<Int> { get }
    var bodyRange: CountableRange<Int> { get }
    var initializers: [Initializer] { get }
    var children: [Token] { get }
    var implementation: Bool { get }
}
