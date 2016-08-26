//
//  Accessibility.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum Accessibility: String {
    case Public = "source.lang.swift.accessibility.public"
    case Internal = "source.lang.swift.accessibility.internal"
    case Private = "source.lang.swift.accessibility.private"
    
    public var sourceName: String {
        switch self {
        case .Public:
            return "public "
        case .Internal:
            return ""
        case .Private:
            return "private "
        }
    }
}
