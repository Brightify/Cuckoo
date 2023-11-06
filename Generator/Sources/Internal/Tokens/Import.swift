enum Import: Hashable, CustomStringConvertible {
    case library(name: String)
    case component(kind: String, name: String)

    var description: String {
        switch self {
        case .library(let name):
            return name
        case .component(let kind, let name):
            return "\(kind) \(name)"
        }
    }
}
