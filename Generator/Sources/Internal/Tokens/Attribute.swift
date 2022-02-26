import Foundation

enum Attribute: Hashable, CustomStringConvertible {
    case available(arguments: [String])

    var description: String {
        switch self {
        case .available(let arguments):
            return "@available(\(arguments.joined(separator: ", ")))"
        }
    }

    var unavailablePlatform: String? {
        guard case .available(let arguments) = self,
              arguments.count == 2,
              arguments[1] == "unavailable" else {
            return nil
        }

        return String(arguments[0])
    }
}
