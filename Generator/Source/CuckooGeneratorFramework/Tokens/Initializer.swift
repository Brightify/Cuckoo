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
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let parameters: [MethodParameter]
    
    public let required: Bool
}