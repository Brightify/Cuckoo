import Foundation

enum Attribute: Hashable, CustomStringConvertible {
    case available(arguments: [String])
    case objc
    case objcMembers

    var description: String {
        switch self {
        case .available(let arguments):
            "@available(\(arguments.joined(separator: ", ")))"
        case .objc:
            "@objc"
        case .objcMembers:
            "@objcMembers"
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
