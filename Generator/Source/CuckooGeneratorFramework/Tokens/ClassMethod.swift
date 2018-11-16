//
//  ClassMethod.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ClassMethod: Method {
    public let name: String
    public let accessibility: Accessibility
    public let returnSignature: String
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    public let parameters: [MethodParameter]
    public let bodyRange: CountableRange<Int>
    public let attributes: [Attribute]
    public var isOptional: Bool {
        return false
    }
    public var isOverriding: Bool {
        return true
    }
}
