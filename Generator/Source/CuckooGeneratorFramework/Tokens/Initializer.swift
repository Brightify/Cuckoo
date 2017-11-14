//
//  Initializer.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct Initializer: Method {
    public let name: String
    public let accessibility: Accessibility
    public let returnSignature: String
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    public let parameters: [MethodParameter]
    public let isOverriding: Bool
    public let required: Bool

    public var isOptional: Bool {
        return false
    }


}
