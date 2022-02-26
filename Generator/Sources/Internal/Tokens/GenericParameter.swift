import Foundation

struct GenericParameter: Equatable {
    let name: String
    let inheritedTypes: [String]

    var description: String {
        if inheritedTypes.isEmpty {
            return name
        } else {
            return "\(name): \(inheritedTypes.joined(separator: " & "))"
        }
    }
}

extension Array where Element == GenericParameter {
    var sourceDescription: String {
        "<\(map { $0.description }.joined(separator: ", "))>"
    }
}
