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
