//
//  Key.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum Key: String {
    case Substructure = "key.substructure"
    case Kind = "key.kind"
    case Accessibility = "key.accessibility"
    case SetterAccessibility = "key.setter_accessibility"
    case Name = "key.name"
    case TypeName = "key.typename"
    case InheritedTypes = "key.inheritedtypes"
    case Attributes = "key.attributes"
    case Attribute = "key.attribute"

    case Length = "key.length"
    case Offset = "key.offset"
    
    case NameLength = "key.namelength"
    case NameOffset = "key.nameoffset"
    
    case BodyLength = "key.bodylength"
    case BodyOffset = "key.bodyoffset"
}
