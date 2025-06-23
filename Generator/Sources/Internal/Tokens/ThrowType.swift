import SwiftSyntax

enum ThrowType: CustomStringConvertible, Equatable {
    case `throws`(String?)
    case `rethrows`

    init?(syntax: ThrowsClauseSyntax?) {
        guard let syntax else { return nil }
        let keyword = syntax.throwsSpecifier.text
        let type: String? = syntax.type?.as(IdentifierTypeSyntax.self)?.name.text
        if keyword.trimmed.hasPrefix("throws") {
            self = .throws(type)
        } else if keyword.trimmed.hasPrefix("rethrows") {
            self = .rethrows
        } else {
            return nil
        }
    }

    var isThrowing: Bool {
        if case .throws = self {
            return true
        } else {
            return false
        }
    }

    var isRethrowing: Bool {
        if case .rethrows = self {
            return true
        } else {
            return false
        }
    }

    var description: String {
        switch self {
        case .throws(let type):
            if let type {
                return "throws(\(type))"
            } else {
                return "throws"
            }
        case .rethrows:
            return "rethrows"
        }
    }
    
    var keyword: String {
        switch self {
        case .throws:
            return "throws"
        case .rethrows:
            return "rethrows"
        }
    }
    
    var type: String {
        switch self {
        case .throws(let type):
            return type ?? "Error"
        case .rethrows:
            return "Error"
        }
    }
}
