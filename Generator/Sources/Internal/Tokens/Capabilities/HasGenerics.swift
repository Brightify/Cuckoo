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
    
    var hasPrimaryAssociatedTypes: Bool {
        guard let protocolDeclaration = asProtocol else { return false }
        return !protocolDeclaration.primaryAssociatedTypes.isEmpty
    }
    
    var hasOnlyPrimaryAssociatedTypes: Bool {
        guard let protocolDeclaration = asProtocol else { return false }
        return protocolDeclaration.primaryAssociatedTypes.count == protocolDeclaration.genericParameters.count
    }

    func genericsSerialize() -> GeneratorContext {
        let genericProtocolIdentity = isProtocol
            ? genericParameters
                .map { "\(Templates.staticGenericParameter).\($0.name) == \($0.name)" }
                .joined(separator: ", ")
            : nil
        let genericPrimaryAssociatedTypeArguments: String?
        if let protocolDeclaration = asProtocol, hasPrimaryAssociatedTypes {
            let arguments = protocolDeclaration.primaryAssociatedTypes.map { $0.name }.joined(separator: ", ")
            genericPrimaryAssociatedTypeArguments = "<\(arguments)>"
        } else {
            genericPrimaryAssociatedTypeArguments = nil
        }
        
        return [
            "isGeneric": isGeneric,
            "genericParameters": genericParametersString,
            "genericArguments": genericArgumentsString,
            "hasPrimaryAssociatedTypes": hasPrimaryAssociatedTypes,
            "hasOnlyPrimaryAssociatedTypes": hasOnlyPrimaryAssociatedTypes,
            "genericProtocolIdentity": genericProtocolIdentity,
            "genericPrimaryAssociatedTypeArguments": genericPrimaryAssociatedTypeArguments,
        ]
        .compactMapValues { $0 }
    }
}
