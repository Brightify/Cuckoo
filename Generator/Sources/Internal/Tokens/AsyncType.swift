enum AsyncType: String, CustomStringConvertible, Equatable {
    case `async`
    case `reasync`

    var isAsync: Bool {
        self == .async
    }

    var isReasync: Bool {
        self == .reasync
    }

    var description: String {
        rawValue
    }
}
