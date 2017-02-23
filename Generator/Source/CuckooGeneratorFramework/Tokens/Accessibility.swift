//
//  Accessibility.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum Accessibility: String {
    case Open = "source.lang.swift.accessibility.open"
    case Public = "source.lang.swift.accessibility.public"
    case Internal = "source.lang.swift.accessibility.internal"
    case Private = "source.lang.swift.accessibility.private"
    case FilePrivate = "source.lang.swift.accessibility.fileprivate"

    public var sourceName: String {
        switch self {
        case .Open:
            fallthrough
        case .Public:
            return "public"
        case .Internal:
            return ""
        case .Private:
            return "private"
        case .FilePrivate:
            return "fileprivate"
        }
    }

    public var isAccessible: Bool {
        return self != .Private && self != .FilePrivate
    }
}
