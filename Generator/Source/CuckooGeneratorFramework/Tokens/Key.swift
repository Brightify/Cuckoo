//
//  Key.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum Key: String {
    case substructure = "key.substructure"
    case kind = "key.kind"
    case accessibility = "key.accessibility"
    case setterAccessibility = "key.setter_accessibility"
    case name = "key.name"
    case typeName = "key.typename"
    case inheritedTypes = "key.inheritedtypes"
    case attributes = "key.attributes"
    case attribute = "key.attribute"

    case length = "key.length"
    case offset = "key.offset"
    
    case nameLength = "key.namelength"
    case nameOffset = "key.nameoffset"
    
    case bodyLength = "key.bodylength"
    case bodyOffset = "key.bodyoffset"
}
