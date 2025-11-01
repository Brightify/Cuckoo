struct MethodParameter: Token {
    var parent: Reference<Token>?

    var name: String
    // FIXME: Is this needed?
    var innerName: String?
    var type: ComplexType
    
    var isInout: Bool {
        type.containsAttribute(named: "inout")
    }

    var nameAndInnerName: String {
        [name, innerName].compactMap { $0 }.joined(separator: " ")
    }

    var usableName: String {
        innerName ?? name
    }

    var description: String {
        "\(nameAndInnerName): \(type)"
    }

    var isEscaping: Bool {
        type.isClosure && (type.containsAttribute(named: "@escaping") || type.isOptional)
    }
    
    var call: String {
        let escapedName = escapeReservedKeywords(for: usableName)
        let value = "\(isInout ? "&" : "")\(escapedName)\(type.containsAttribute(named: "@autoclosure") ? "()" : "")"
        if name == "_" {
            return value
        } else {
            return "\(name): \(value)"
        }
    }
    
    func callAndCastTypes(named typeNames: [String], as replacement: (String) -> String) -> String {
        let replaced = type.replaceTypes(named: typeNames, with: replacement)
        
        let callToCast = call
        if let replaced {
            return callToCast.forceCast(as: replaced)
        } else {
            return callToCast
        }
    }

    func serialize() -> [String: Any] {
        return [
            "name": name,
            "innerName": innerName ?? "",
            "type": type,
            "nameAndInnerName": nameAndInnerName,
            "typeWithoutAttributes": type.withoutAttributes(),
            "isClosure": type.isClosure,
            "isOptional": type.isOptional,
            "isEscaping": isEscaping
        ]
    }
}
