import SwiftSyntax

enum Accessibility: String, Equatable {
    case `open`
    case `public`
    case `internal`
    case `private`
    case `fileprivate`

    var sourceName: String {
        switch self {
        case .open:
            fallthrough
        case .public:
            return "public"
        case .internal:
            return ""
        case .private:
            return "private"
        case .fileprivate:
            return "fileprivate"
        }
    }

    var isAccessible: Bool {
        self != .private && self != .fileprivate
    }
}

extension Accessibility {
    init?(tokenKind: TokenKind) {
        switch tokenKind {
        case .keyword(.public):
            self = .public
        case .keyword(.internal):
            self = .internal
        case .keyword(.private):
            self = .private
        case .keyword(.fileprivate):
            self = .fileprivate
        case .keyword(.open):
            self = .open
        default:
            return nil
        }
    }
}

extension Accessibility: Comparable {
    static func < (lhs: Accessibility, rhs: Accessibility) -> Bool {
        lhs.openness < rhs.openness
    }

    /// How open is this accessibility. The higher number the more accessible.
    private var openness: Int {
        switch self {
        case .open:
            return 4
        case .public:
            return 3
        case .internal:
            return 2
        case .fileprivate:
            return 1
        case .private:
            return 0
        }
    }
}
