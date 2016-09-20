//
//  MethodParameter.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct MethodParameter: Token {
    public let label: String?
    public let name: String
    public let type: String
    public let range: CountableRange<Int>
    public let nameRange: CountableRange<Int>
    
    public var labelAndName: String {
        if let label = label {
            return label != name ? "\(label) \(name)" : name
        } else {
            return "_ \(name)"
        }
    }
    
    public var typeWithoutAttributes: String {
        return type.replacingOccurrences(of: "@escaping", with: "").replacingOccurrences(of: "@autoclosure", with: "").trimmed
    }
}
