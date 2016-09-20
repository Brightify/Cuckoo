//
//  Attributes.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct Attributes: OptionSet {
    public static let none = Attributes(rawValue: 0)
    public static let noescape = Attributes(rawValue: 1 << 0)
    public static let autoclosure = Attributes(rawValue: 1 << 1)
    public static let escaping = Attributes(rawValue: 1 << 2)
    
    public static let escapingAutoclosure: Attributes = [autoclosure, escaping]
    
    public let rawValue : Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public var sourceRepresentation: String {
        return !self.isEmpty ? sourceRepresentations.joined(separator: " ") + " " : ""
    }
    
    public var sourceRepresentations: [String] {
        var mutableCopy = self
        var representation: [String] = []
        
        if let _ = mutableCopy.remove(Attributes.escapingAutoclosure) {
            representation.append("@autoclosure(escaping)")
        }
        
        if let _ = mutableCopy.remove(Attributes.autoclosure) {
            representation.append("@autoclosure")
        }
        
        if let _ = mutableCopy.remove(Attributes.noescape) {
            representation.append("@noescape")
        }
        
        if !mutableCopy.isEmpty {
            fputs("Unknown attributes: \(mutableCopy.rawValue)\n", stderr)
        }
        
        return representation
    }
}
