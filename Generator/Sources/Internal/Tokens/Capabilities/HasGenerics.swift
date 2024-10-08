protocol HasGenerics: Token {
    var genericParameters: [GenericParameter] { get }
    var genericRequirements: [String] { get }
}

extension HasGenerics {
    var genericParametersString: String {
        guard !genericParameters.isEmpty else { return "" }
        let parameters = genericParameters.map { $0.description }.joined(separator: ", ")
        return "<\(parameters)>"
    }

    var genericArgumentsString: String {
        guard !genericParameters.isEmpty else { return "" }
        let arguments = genericParameters.map { $0.name }.joined(separator: ", ")
        return "<\(arguments)>"
    }

    var isGeneric: Bool {
        !genericParameters.isEmpty
    }

    func genericsSerialize() -> GeneratorContext {
        let genericProtocolIdentity = isProtocol ? genericParameters.map { "\(Templates.staticGenericParameter).\($0.name) == \($0.name)" }.joined(separator: ", ") : nil

        return [
            "isGeneric": isGeneric,
            "genericParameters": genericParametersString,
            "genericArguments": genericArgumentsString,
            "genericProtocolIdentity": genericProtocolIdentity,
        ]
        .compactMapValues { $0 }
    }
}
