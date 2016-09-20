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
}
