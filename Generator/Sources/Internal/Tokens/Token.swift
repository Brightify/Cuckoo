protocol Token: Serializable {
    var parent: Reference<Token>? { get set }
}

extension Token {
    func serialize() -> GeneratorContext {
        commonSerialize()
    }

    func commonSerialize() -> GeneratorContext {
        [
            [
                "@type": "\(type(of: self))",
                "isImplementation": isClass,
                "hasParent": parent != nil,
            ],
            (self as? ContainerToken)?.containerSerialize(),
            (self as? HasName)?.nameSerialize(),
            (parent?.value as? HasName).map { ["parentFullyQualifiedName": $0.fullyQualifiedName] },
            (self as? HasGenerics)?.genericsSerialize(),
            asProtocol.map { ["isNSObjectProtocol": $0.isNSObjectProtocol] },
            (self as? HasInheritance)?.inheritanceSerialize(),
        ]
        .compactMap { $0 }
        .merge()
    }

    var isMockable: Bool {
        [isClass, isProtocol, isVariable, isMethod].contains(true)
    }

    var isVariable: Bool {
        self is Variable
    }

    var isMethod: Bool {
        self is Method
    }

    var isClass: Bool {
        self is ClassDeclaration
    }

    var asClass: ClassDeclaration? {
        self as? ClassDeclaration
    }

    var isProtocol: Bool {
        self is ProtocolDeclaration
    }

    var asProtocol: ProtocolDeclaration? {
        self as? ProtocolDeclaration
    }
}

extension Token where Self: HasName {
    func nameSerialize() -> GeneratorContext {
        [
            "name": name,
            "mockName": mockName,
        ]
    }
}

extension Token where Self: HasGenerics {
    func genericsSerialize() -> GeneratorContext {
        let genericParametersString = genericParameters.map { $0.description }.joined(separator: ", ")
        let genericArgumentsString = genericParameters.map { $0.name }.joined(separator: ", ")
        let genericProtocolIdentity = isProtocol ? genericParameters.map { "\(Templates.staticGenericParameter).\($0.name) == \($0.name)" }.joined(separator: ", ") : nil
        let isGeneric = !genericParameters.isEmpty

        return [
            "isGeneric": isGeneric,
            "genericParameters": isGeneric ? "<\(genericParametersString)>" : "",
            "genericArguments": isGeneric ? "<\(genericArgumentsString)>" : "",
            "genericProtocolIdentity": genericProtocolIdentity,
        ]
        .compactMapValues { $0 }
    }
}

extension Token where Self: HasInheritance {
    func inheritanceSerialize() -> GeneratorContext {
        [
            "inheritedTypes": inheritedTypes,
        ]
    }
}

extension Token where Self: HasAttributes {
    func attributesSerialize() -> GeneratorContext {
        [
            "attributes": attributes,
        ]
    }
}
