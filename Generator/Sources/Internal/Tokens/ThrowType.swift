enum ThrowType: String, CustomStringConvertible, Equatable {
    case `throws`
    case `rethrows`

    init?(string: String) {
        if string.trimmed.hasPrefix(ThrowType.throws.rawValue) {
            self = .throws
        } else if string.trimmed.hasPrefix(ThrowType.rethrows.rawValue) {
            self = .rethrows
        } else {
            return nil
        }
    }

    var isThrowing: Bool {
        self == .throws
    }

    var isRethrowing: Bool {
        self == .rethrows
    }

    var description: String {
        rawValue
    }
}
