//
//  ThrowType.swift
//  CuckooGeneratorFramework
//
//  Created by Matyáš Kříž on 14/05/2019.
//

public enum ThrowType: CustomStringConvertible {
    case throwing
    case rethrowing

    public init?(string: String) {
        if string.trimmed.hasPrefix("throws") {
            self = .throwing
        } else if string.trimmed.hasPrefix("rethrows") {
            self = .rethrowing
        } else {
            return nil
        }
    }

    public var isThrowing: Bool {
        return self == .throwing
    }

    public var isRethrowing: Bool {
        return self == .rethrowing
    }

    public var description: String {
        switch self {
        case .throwing:
            return "throws"
        case .rethrowing:
            return "rethrows"
        }
    }
}
