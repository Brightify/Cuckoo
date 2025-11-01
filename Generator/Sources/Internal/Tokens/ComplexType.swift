import SwiftSyntax
import SwiftParser

enum ComplexType {
    indirect case attributed(attributes: [String], baseType: ComplexType)
    indirect case optional(wrappedType: ComplexType, isImplicit: Bool)
    indirect case array(elementType: ComplexType)
    indirect case dictionary(keyType: ComplexType, valueType: ComplexType)
    case closure(Closure)
    case type(String)

    init(syntax: TypeSyntax) {
        let normalizedSyntax = syntax.recursivelyNormalizingTrivia()

        if let implicitOptionalType = normalizedSyntax.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
            self = .optional(wrappedType: ComplexType(syntax: implicitOptionalType.wrappedType), isImplicit: true)
        } else if let optionalType = normalizedSyntax.as(OptionalTypeSyntax.self) {
            self = .optional(wrappedType: ComplexType(syntax: optionalType.wrappedType), isImplicit: false)
        } else if let attributedType = normalizedSyntax.as(AttributedTypeSyntax.self) {
            self = .attributed(
                attributes: [
                    attributedType.attributes.map { $0.trimmedDescription },
                    attributedType.specifier.map { [$0.trimmedDescription] } ?? [],
                ].flatMap { $0 },
                baseType: ComplexType(syntax: attributedType.baseType)
            )
        } else if let functionType = normalizedSyntax.as(FunctionTypeSyntax.self) {
            self = .closure(
                Closure(
                    parameters: functionType.parameters.map {
                        Closure.Parameter(
                            label: $0.secondName?.trimmedDescription,
                            type: ComplexType(syntax: $0.type)
                        )
                    },
                    effects: Closure.Effects(effectSpecifiers: functionType.effectSpecifiers),
                    returnType: ComplexType(syntax: functionType.returnClause.type)
                )
            )
        } else if let identifierType = normalizedSyntax.as(IdentifierTypeSyntax.self) {
            switch identifierType.trimmedDescription {
            case "Dictionary":
                let arguments = identifierType.genericArgumentClause?.arguments
                #if canImport(SwiftSyntax601)
                guard let keyArgument = arguments?.first?.argument, let valueArgument = arguments?.last?.argument else {
                    fatalError("Cuckoo error: Failed to get Dictionary type, please open an issue.")
                }
                switch (keyArgument, valueArgument) {
                case (.type(let keyType), .type(let valueType)):
                    self = .dictionary(
                        keyType: ComplexType(syntax: keyType),
                        valueType: ComplexType(syntax: valueType)
                    )
                default:
                    // the other enum value `.expr` requires an @spi(ExperimentalLanguageFeatures) import of SwiftSyntax
                    fatalError("Cuckoo error: Failed to get Dictionary type, please open an issue.")
                }
                #else
                guard let keyType = arguments?.first?.argument, let valueType = arguments?.last?.argument else {
                    fatalError("Cuckoo error: Failed to get Dictionary type, please open an issue.")
                }
                self = .dictionary(
                    keyType: ComplexType(syntax: keyType),
                    valueType: ComplexType(syntax: valueType)
                )
                #endif
            case "Array":
                let arguments = identifierType.genericArgumentClause?.arguments
                #if canImport(SwiftSyntax601)
                guard let elementArgument = arguments?.first?.argument else {
                    fatalError("Cuckoo error: Failed to get Array type, please open an issue.")
                }
                switch elementArgument {
                case .type(let elementType):
                    self = .array(elementType: ComplexType(syntax: elementType))
                default:
                    // the other enum value `.expr` requires an @spi(ExperimentalLanguageFeatures) import of SwiftSyntax
                    fatalError("Cuckoo error: Failed to get Array type, please open an issue.")
                }
                #else
                guard let elementType = arguments?.first?.argument else {
                    fatalError("Cuckoo error: Failed to get Array type, please open an issue.")
                }
                self = .array(elementType: ComplexType(syntax: elementType))
                #endif
            default:
                self = .type(normalizedSyntax.description)
            }
        } else {
            self = .type(normalizedSyntax.description)
        }
    }

    // Can't use value type here.
    final class Closure {
        let parameters: [Parameter]
        let effects: Effects
        let returnType: ComplexType

        var description: String {
            let parametersString = parameters.map { parameter in
                [
                    parameter.label.map { "_ \($0)" },
                    parameter.type.description,
                ]
                .compactMap { $0 }
                .joined(separator: ": ")
            }
            .joined(separator: ", ")

            return [
                "(\(parametersString))",
                effects.description,
                "-> \(returnType.description)",
            ]
            .compactMap { $0.trimmed.nilIfEmpty }
            .joined(separator: " ")
        }

        init(parameters: [Parameter], effects: Effects, returnType: ComplexType) {
            self.parameters = parameters
            self.effects = effects
            self.returnType = returnType
        }

        struct Parameter: Equatable {
            let label: String?
            let type: ComplexType
        }

        struct Effects: OptionSet, Equatable {
            let rawValue: Int

            static let `async` = Effects(rawValue: 1 << 0)
            static let `throws` = Effects(rawValue: 1 << 1)

            static let none: Effects = []

            var description: String {
                [
                    contains(.async) ? "async" : nil,
                    contains(.throws) ? "throws" : nil,
                ]
                .compactMap { $0 }
                .joined(separator: " ")
            }
        }
    }

    enum ComplexTypeError: Error {
        case parsingFailed
    }
}

extension ComplexType: Equatable {
    static func == (lhs: ComplexType, rhs: ComplexType) -> Bool {
        switch (lhs, rhs) {
        case (.attributed(let lhsAttributes, let lhsBaseType), .attributed(let rhsAttributes, let rhsBaseType)):
            lhsAttributes == rhsAttributes && lhsBaseType == rhsBaseType
        case (.optional(let lhsWrappedType, _), .optional(let rhsWrappedType, _)):
            lhsWrappedType == rhsWrappedType
        case (.array(let lhsElementType), .array(let rhsElementType)):
            lhsElementType == rhsElementType
        case (.dictionary(let lhsKeyType, let lhsValueType), .dictionary(let rhsKeyType, let rhsValueType)):
            lhsKeyType == rhsKeyType && lhsValueType == rhsValueType
        case (.closure(let lhsClosure), .closure(let rhsClosure)):
            lhsClosure == rhsClosure
        case (.type(let lhsIdentifier), .type(let rhsIdentifier)):
            lhsIdentifier.filter { !$0.isWhitespace } == rhsIdentifier.filter { !$0.isWhitespace }
        default:
            false
        }
    }
}

extension ComplexType.Closure: Equatable {
    static func == (lhs: ComplexType.Closure, rhs: ComplexType.Closure) -> Bool {
        lhs.parameters == rhs.parameters
        && lhs.effects == rhs.effects
        && lhs.returnType == rhs.returnType
    }
}

extension ComplexType {
    var isVoid: Bool {
        if case .type("Void") = self {
            true
        } else {
            false
        }
    }

    var isOptional: Bool {
        switch self {
        case .optional:
            true
        case .attributed(_, let baseType):
            baseType.isOptional
        case .array, .dictionary, .closure, .type:
            false
        }
    }

    var isClosure: Bool {
        findClosure() != nil
    }

    var unoptionaled: ComplexType {
        if case .optional(let wrappedType, _) = self {
            wrappedType
        } else {
            self
        }
    }

    func withoutAttributes(except whitelist: [String] = []) -> ComplexType {
        if case .attributed(let attributes, let baseType) = self {
            return .attributed(attributes: attributes.filter { whitelist.contains($0) }, baseType: baseType)
        } else {
            return self
        }
    }

    func containsAttribute(named name: String) -> Bool {
        if case .attributed(let attributes, _) = self {
            attributes.contains(name)
        } else {
            false
        }
    }

    func findClosure() -> Closure? {
        switch self {
        case .attributed(_, let baseType):
            baseType.findClosure()
        case .optional(let wrappedType, _):
            wrappedType.findClosure()
        case .closure(let closure):
            closure
        case .type, .array, .dictionary:
            nil
        }
    }
    
    func replaceType(named typeName: String, with replacement: String) -> ComplexType? {
        switch self {
        case .attributed(attributes: let attributes, baseType: let baseType):
            return baseType.replaceType(named: typeName, with: replacement)
                .map { ComplexType.attributed(attributes: attributes, baseType: $0) }
        case .optional(wrappedType: let wrappedType, isImplicit: let isImplicit):
            return wrappedType.replaceType(named: typeName, with: replacement)
                .map { ComplexType.optional(wrappedType: $0, isImplicit: isImplicit) }
        case .array(elementType: let elementType):
            return elementType.replaceType(named: typeName, with: replacement)
                .map { ComplexType.array(elementType: $0) }
        case .dictionary(keyType: let keyType, valueType: let valueType):
            let newKey = keyType.replaceType(named: typeName, with: replacement)
            let newValue = valueType.replaceType(named: typeName, with: replacement)
            if newKey == nil && newValue == nil { return nil }
            return .dictionary(
                keyType: newKey ?? keyType,
                valueType: newValue ?? valueType
            )
        case .closure(let closure):
            var changed = false
            let newParams: [ComplexType.Closure.Parameter] = closure.parameters.map { param in
                if let newType = param.type.replaceType(named: typeName, with: replacement) {
                    changed = true
                    return ComplexType.Closure.Parameter(label: param.label, type: newType)
                } else {
                    return param
                }
            }
            let newReturn = closure.returnType.replaceType(named: typeName, with: replacement)
            if !changed && newReturn == nil { return nil }
            return .closure(.init(parameters: newParams, effects: closure.effects, returnType: newReturn ?? closure.returnType))
        case .type(let name):
            return name == typeName ? ComplexType.type(replacement) : nil
        }
    }
    
    func replaceTypes(named typeNames: [String], with replacement: (String) -> String) -> ComplexType? {
        var changed = false
        var type = self
        for typeName in typeNames {
            if let replaced = type.replaceType(named: typeName, with: replacement(typeName)) {
                changed = true
                type = replaced
            }
        }
        
        return changed ? type : nil
    }
    
    func containsType(named typeName: String) -> Bool {
        switch self {
        case .attributed(attributes: _, baseType: let baseType):
            baseType.containsType(named: typeName)
        case .optional(wrappedType: let wrappedType, isImplicit: _):
            wrappedType.containsType(named: typeName)
        case .array(elementType: let elementType):
            elementType.containsType(named: typeName)
        case .dictionary(keyType: let keyType, valueType: let valueType):
            keyType.containsType(named: typeName) || valueType.containsType(named: typeName)
        case .closure(let closure):
            (closure.parameters.map(\.type) + [closure.returnType]).contains(where: { $0.containsType(named: typeName)})
        case .type(let name):
            name == typeName
        }
    }
    
    func containsTypes(named typeNames: [String]) -> Bool {
        typeNames.contains(where: { containsType(named: $0) })
    }
}

extension String {
    func forceCast(as type: ComplexType) -> String {
        "\(self) as! \(type.withoutAttributes(except: ["@MainActor", "@Sendable"]).description)"
    }
}

extension ComplexType.Closure.Effects {
    init(effectSpecifiers: TypeEffectSpecifiersSyntax?) {
        guard let effectSpecifiers else {
            self = .none
            return
        }
        var effects: Self = []
        if effectSpecifiers.asyncSpecifier?.isPresent == true {
            effects.insert(.async)
        }
        if effectSpecifiers.throwsClause != nil {
            effects.insert(.throws)
        }
        self = effects
    }
}

extension ComplexType: CustomStringConvertible {
    var description: String {
        switch self {
        case .attributed(let attributes, let baseType):
            return "\(attributes.joined(separator: " ")) \(baseType.description)"
        case .optional(let wrappedType, let isImplicit):
            let suffix = isImplicit ? "!" : "?"
            if wrappedType.isClosure {
                return "(\(wrappedType.description))\(suffix)"
            } else {
                return "\(wrappedType.description)\(suffix)"
            }
        case .array(let elementType):
            return "[\(elementType)]"
        case .dictionary(let keyType, let valueType):
            return "[\(keyType): \(valueType)]"
        case .closure(let closure):
            return closure.description
        case .type(let type):
            return type
        }
    }
}

extension ComplexType: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .attributed(let attributes, let baseType):
            ".attributed(\(attributes.map(\.quoted)) \(baseType.debugDescription)"
        case .optional(let wrappedType, let isImplicit):
            ".optional(\(wrappedType.debugDescription), isImplicit: \(isImplicit)"
        case .array(let elementType):
            ".array(\(elementType.debugDescription))"
        case .dictionary(let keyType, let valueType):
            ".dictionary(\(keyType.debugDescription), \(valueType.debugDescription))"
        case .closure(let closure):
            ".closure(\(closure.description.quoted))"
        case .type(let type):
            type.quoted
        }
    }
}
