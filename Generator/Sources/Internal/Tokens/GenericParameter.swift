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

    func merged() -> [GenericParameter] {
        var seenNames: Set<String> = []
        var mergedParameters: [GenericParameter] = []
        for parameterName in self.map(\.name) where !seenNames.contains(parameterName) {
            seenNames.insert(parameterName)
            let mergedInheritedTypes = filter { $0.name == parameterName }.flatMap(\.inheritedTypes).uniquing()
            mergedParameters.append(
                GenericParameter(
                    name: parameterName,
                    inheritedTypes: mergedInheritedTypes
                )
            )
        }
        return mergedParameters
    }
}
