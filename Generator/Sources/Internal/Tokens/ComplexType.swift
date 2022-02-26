import SwiftSyntax
import SwiftParser

enum ComplexType {
    indirect case attributed(attributes: [String], baseType: ComplexType)
    indirect case optional(wrappedType: ComplexType, isImplicit: Bool)
    case closure(Closure)
    case type(String)

    init(syntax: TypeSyntax) {
        self = if let implicitOptionalType = syntax.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
            .optional(wrappedType: ComplexType(syntax: implicitOptionalType.wrappedType), isImplicit: true)
        } else if let optionalType = syntax.as(OptionalTypeSyntax.self) {
            .optional(wrappedType: ComplexType(syntax: optionalType.wrappedType), isImplicit: false)
        } else if let attributedType = syntax.as(AttributedTypeSyntax.self) {
            .attributed(
                attributes: [
                    attributedType.attributes.map { $0.trimmedDescription },
                    attributedType.specifier.map { [$0.trimmedDescription] } ?? [],
                ].flatMap { $0 },
                baseType: ComplexType(syntax: attributedType.baseType)
            )
        } else if let functionType = syntax.as(FunctionTypeSyntax.self) {
            .closure(
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
        } else {
            .type(syntax.trimmedDescription)
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
        case (.optional(let lhsWrappedType), .optional(let rhsWrappedType)):
            lhsWrappedType == rhsWrappedType
        case (.closure(let lhsClosure), .closure(let rhsClosure)):
            lhsClosure == rhsClosure
        case (.type(let lhsIdentifier), .type(let rhsIdentifier)):
            lhsIdentifier.components(separatedBy: .whitespacesAndNewlines).joined() == rhsIdentifier.components(separatedBy: .whitespacesAndNewlines).joined()
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
        case .closure, .type:
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
        case .closure(let closure):
            closure
        case .optional(let wrappedType, _):
            wrappedType.findClosure()
        case .type:
            nil
        }
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
        if effectSpecifiers.throwsSpecifier?.isPresent == true {
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
        case .closure(let closure):
            return closure.description
        case .type(let type):
            return type
        }
    }
}
