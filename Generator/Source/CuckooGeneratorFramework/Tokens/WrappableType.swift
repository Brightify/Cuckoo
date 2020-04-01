//
//  WrappableType.swift
//  CuckooGeneratorFramework
//
//  Created by Matyáš Kříž on 13/03/2019.
//

public enum WrappableType {
    indirect case optional(WrappableType)
    indirect case implicitlyUnwrappedOptional(WrappableType)
    indirect case attributed(WrappableType, attributes: [String])
    case type(String)

    public var sugarized: String {
        switch self {
        case .optional(let wrapped):
            return "\(wrapped.sugarized)?"
        case .implicitlyUnwrappedOptional(let wrapped):
            return "\(wrapped.sugarized)!"
        case .attributed(let wrapped, let attributes):
            return "\(attributes.joined(separator: " ")) \(wrapped.sugarized)"
        case .type(let type):
            return type
        }
    }

    public var desugarized: String {
        switch self {
        case .optional(let wrapped), .implicitlyUnwrappedOptional(let wrapped):
            return "Optional<\(wrapped.desugarized)>"
        case .attributed(let wrapped, let attributes):
            return "\(attributes.joined(separator: " ")) \(wrapped.desugarized)"
        case .type(let type):
            return type
        }
    }

    public var explicitOptionalOnly: WrappableType {
        switch self {
        case .optional(let wrapped), .implicitlyUnwrappedOptional(let wrapped):
            return .optional(wrapped.explicitOptionalOnly)
        case .attributed(let wrapped, let attributes):
            return .attributed(wrapped.explicitOptionalOnly, attributes: attributes)
        case .type:
            return self
        }
    }

    public var unoptionaled: WrappableType {
        switch self {
        case .optional(let wrapped), .implicitlyUnwrappedOptional(let wrapped):
            return wrapped.unoptionaled
        case .attributed(let wrapped, let attributes):
            return .attributed(wrapped.unoptionaled, attributes: attributes)
        case .type:
            return self
        }
    }

    public var unwrapped: WrappableType {
        switch self {
        case .optional(let wrapped), .implicitlyUnwrappedOptional(let wrapped):
            return wrapped
        case .attributed(let wrapped, let attributes):
            return .attributed(wrapped.unwrapped, attributes: attributes)
        case .type:
            return self
        }
    }

    public var withoutAttributes: WrappableType {
        switch self {
        case .optional(let wrapped):
            return .optional(wrapped.withoutAttributes)
        case .implicitlyUnwrappedOptional(let wrapped):
            return .implicitlyUnwrappedOptional(wrapped.withoutAttributes)
        case .attributed(let wrapped, _):
            return wrapped
        case .type:
            return self
        }
    }

    public var isOptional: Bool {
        switch self {
        case .optional, .implicitlyUnwrappedOptional:
            return true
        case .attributed(let wrapped, _):
            return wrapped.isOptional
        case .type:
            return false
        }
    }

    public init(parsing value: String) {
        let trimmedValue = value.trimmed
        let optionalPrefix = "Optional<"
        if trimmedValue.hasPrefix("@") {
            let (attributes, resultString) = ["@autoclosure", "@escaping", "@noescape"]
                .reduce(([], trimmedValue)) { acc, next -> ([String], String) in
                    var (attributes, resultString) = acc
                    guard let range = resultString.range(of: next) else { return acc }
                    resultString.removeSubrange(range)
                    attributes.append(next)
                    return (attributes, resultString)
                }
            self = .attributed(WrappableType(parsing: resultString), attributes: attributes)
        } else if trimmedValue.hasSuffix("?") {
            if trimmedValue.contains("->") && !trimmedValue.hasSuffix(")?") {
                self = .type(trimmedValue)
            } else {
                self = .optional(WrappableType(parsing: String(trimmedValue.dropLast())))
            }
        } else if trimmedValue.hasPrefix(optionalPrefix) {
            self = .optional(WrappableType(parsing: String(trimmedValue.dropFirst(optionalPrefix.count).dropLast())))
        } else if trimmedValue.hasSuffix("!") {
            self = .implicitlyUnwrappedOptional(WrappableType(parsing: String(trimmedValue.dropLast())))
        } else {
            self = .type(trimmedValue)
        }
    }

    public func containsAttribute(named attribute: String) -> Bool {
        switch self {
        case .optional(let wrapped), .implicitlyUnwrappedOptional(let wrapped):
            return wrapped.containsAttribute(named: attribute)
        case .attributed(_, let attributes):
            return attributes.contains(attribute.trimmed)
        case .type:
            return false
        }
    }
}

extension WrappableType: CustomStringConvertible {
    public var description: String {
        return sugarized
    }
}

extension WrappableType: Equatable {
    public static func ==(lhs: WrappableType, rhs: WrappableType) -> Bool {
        switch (lhs, rhs) {
        case (.optional(let lhsWrapped), .optional(let rhsWrapped)),
             (.implicitlyUnwrappedOptional(let lhsWrapped), .implicitlyUnwrappedOptional(let rhsWrapped)):
            return lhsWrapped == rhsWrapped
        case (.attributed(let lhsWrapped, let lhsAttributes), .attributed(let rhsWrapped, let rhsAttributes)):
            return lhsWrapped == rhsWrapped && lhsAttributes == rhsAttributes
        case (.type(let lhsType), .type(let rhsType)):
            return lhsType.components(separatedBy: .whitespacesAndNewlines).joined() == rhsType.components(separatedBy: .whitespacesAndNewlines).joined()
        default:
            return false
        }
    }
}
