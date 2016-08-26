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
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let attributes: Attributes
    
    public func labelAndNameAtPosition(position: Int) -> String {
        let isFirst = position == 0
        if let label = label {
            return label != name || isFirst ? "\(label) \(name)" : name
        } else {
            return isFirst ? name : "_ \(name)"
        }
    }
    
    public func labelOrNameAtPosition(position: Int) -> String {
        let isFirst = position == 0
        if let label = label {
            return label
        } else if isFirst {
            return ""
        } else {
            return name
        }
    }
}