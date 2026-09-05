import Foundation
import Stencil

@globalActor
actor StaticActor {
    static let shared = StaticActor()
}

struct GeneratorHelper {
    @StaticActor
    private static let extensions = createExtensions()

    @StaticActor
    static func generate(tokens: [Token], debug: Bool = false) throws -> String {
        let containers = tokens.map { $0.serialize() }

        let environment = Environment(
            extensions: extensions,
            trimBehaviour: .smart
        )
        return try environment.renderTemplate(
            string: Templates.mock,
            context: ["containers": containers, "debug": debug]
        )
    }

    private static func matchableGenericTypes(from method: Method) -> String {
        guard !method.signature.parameters.isEmpty || !method.signature.genericParameters.isEmpty else { return "" }

        let matchableGenericParameters = method.signature.parameters.enumerated().map { index, parameter -> String in
            let type = parameter.type.isOptional ? "OptionalMatchable" : "Matchable"
            return "M\(index + 1): Cuckoo.\(type)"
        }
        let methodGenericParameters = method.signature.genericParameters.map { $0.description }
        return "<\((matchableGenericParameters + methodGenericParameters).joined(separator: ", "))>"
    }

    private static func matchableGenericsWhereClause(from method: Method) -> String {
        guard method.signature.parameters.isEmpty == false else { return "" }

        let matchableWhereConstraints = method.signature.parameters.enumerated().map { index, parameter -> String in
            let type = parameter.type.isOptional ? "OptionalMatchedType" : "MatchedType"
            return "M\(index + 1).\(type) == \(genericSafeType(from: parameter.type.withoutAttributes(except: ["@MainActor", "@Sendable"]).unoptionaled.description))"
        }
        let methodWhereConstraints = method.signature.whereConstraints
        return " where \((matchableWhereConstraints + methodWhereConstraints).joined(separator: ", "))"
    }

    private static func matchableParameterSignature(with parameters: [MethodParameter]) -> String {
        guard !parameters.isEmpty else { return "" }

        return parameters.enumerated()
            .map { "\($1.nameAndInnerName): M\($0 + 1)" }
            .joined(separator: ", ")
    }

    private static func parameterMatchers(for parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "let matchers: [Cuckoo.ParameterMatcher<Void>] = []" }

        // `inout` parameters are boxed in `Cuckoo.InoutContainer` on the mock's `IN` type (see
        // MockTemplate/Method.genericInputTypes), so the matcher tuple type and the value each
        // matcher is applied against both need to unwrap `.value` for those positions. Matching
        // happens before the stub's action runs, so this always sees the initial (pre-mutation) value.
        let tupleType = parameters.map { parameter -> String in
            let typeDescription = genericSafeType(from: parameter.type.withoutAttributes(except: ["@MainActor", "@Sendable"]).description)
            return parameter.isInout ? "Cuckoo.InoutContainer<\(typeDescription.trimmed)>" : typeDescription
        }.joined(separator: ", ")
        let matchers = parameters
            // Enumeration is done after filtering out parameters without usable names.
            .enumerated()
            .compactMap { index, parameter in
                let name = escapeReservedKeywords(for: parameter.usableName)
                let indexAccessor = parameters.count > 1 ? ".\(index)" : ""
                let valueAccessor = parameter.isInout ? "\(indexAccessor).value" : indexAccessor
                return "wrap(matchable: \(name)) { $0\(valueAccessor) }"
            }
            .joined(separator: ", ")
        return "let matchers: [Cuckoo.ParameterMatcher<(\(tupleType))>] = [\(matchers)]"
    }

    private static func inoutBoxDeclarations(for parameters: [MethodParameter]) -> String {
        let declarations = parameters.filter(\.isInout).map { parameter -> String in
            let name = escapeReservedKeywords(for: parameter.usableName)
            return "let \(name)Box = Cuckoo.InoutContainer(\(name))"
        }
        guard !declarations.isEmpty else { return "" }
        return declarations.joined(separator: "\n\t\t") + "\n\t\t"
    }

    private static func inoutWriteBack(for parameters: [MethodParameter]) -> String {
        let assignments = parameters.filter(\.isInout).map { parameter -> String in
            let name = escapeReservedKeywords(for: parameter.usableName)
            return "\(name) = \(name)Box.value"
        }
        guard !assignments.isEmpty else { return "" }
        return "defer {\n" + assignments.map { "\t\t\t\($0)" }.joined(separator: "\n") + "\n\t\t}\n\t\t"
    }

    private static func genericSafeType(from type: String) -> String {
        return type.replacingOccurrences(of: "!", with: "?")
    }

    private static func openNestedClosure(for method: Method) -> String {
        var fullString = ""
        for (index, parameter) in method.signature.parameters.enumerated() {
            if !parameter.type.containsAttribute(named: "@escaping"), parameter.type.findClosure() != nil {
                if fullString.isEmpty {
                    fullString = "\n"
                }

                let indents = String(repeating: "\t", count: index + 2)
                let tries = method.isThrowing ? "try " : ""
                let awaits = method.isAsync ? "await " : ""

                let returnSignature: String
                if let returnType = method.returnType, !returnType.isVoid {
                    returnSignature = " -> \(returnType.description)"
                } else {
                    returnSignature = ""
                }

                fullString += "\(indents)return \(tries)\(awaits)withoutActuallyEscaping(\(parameter.usableName), do: { (\(parameter.usableName): @escaping \(parameter.type))\(returnSignature) in\n"
            }
        }
        return fullString
    }

    private static func closeNestedClosure(for parameters: [MethodParameter]) -> String {
        var fullString = ""
        for (index, parameter) in parameters.enumerated() {
            if !parameter.type.containsAttribute(named: "@escaping"), parameter.type.isClosure {
                if fullString.isEmpty {
                    fullString = "\n"
                }
                let indents = String(repeating: "\t", count: index + 2)
                fullString += "\(indents)})\n"
            }
        }
        return fullString
    }

    private static func removeClosureArgumentNames(for type: String) -> String {
        type.replacingOccurrences(
            of: "_\\s+?[_a-zA-Z]\\w*?\\s*?:",
            with: "",
            options: .regularExpression
        )
    }
}

extension GeneratorHelper {
    private static func createExtensions() -> [Extension] {
        let stencilExtension = Extension()

        stencilExtension.registerFilter("genericSafe") { (value: Any?) in
            guard let string = value as? String else { return value }
            return genericSafeType(from: string)
        }
        stencilExtension.registerFilter("matchableGenericNames") { (value: Any?) in
            guard let method = value as? Method else { return value }
            return matchableGenericTypes(from: method)
        }
        stencilExtension.registerFilter("matchableGenericWhereClause") { (value: Any?) in
            guard let method = value as? Method else { return value }
            return matchableGenericsWhereClause(from: method)
        }
        stencilExtension.registerFilter("matchableParameterSignature") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return matchableParameterSignature(with: parameters)
        }
        stencilExtension.registerFilter("parameterMatchers") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return parameterMatchers(for: parameters)
        }
        stencilExtension.registerFilter("openNestedClosure") { (value: Any?) in
            guard let method = value as? Method else { return value }
            return openNestedClosure(for: method)
        }
        stencilExtension.registerFilter("closeNestedClosure") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return closeNestedClosure(for: parameters)
        }
        stencilExtension.registerFilter("inoutBoxDeclarations") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return inoutBoxDeclarations(for: parameters)
        }
        stencilExtension.registerFilter("inoutWriteBack") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return inoutWriteBack(for: parameters)
        }
        stencilExtension.registerFilter("escapeReservedKeywords") { (value: Any?) in
            guard let name = value as? String else { return value }
            return escapeReservedKeywords(for: name)
        }
        stencilExtension.registerFilter("removeClosureArgumentNames") { (value: Any?) in
            guard let type = value as? String else { return value }
            return removeClosureArgumentNames(for: type)
        }
        stencilExtension.registerFilter("withSpace") { (value: Any?) in
            if let value = value as? String, !value.isEmpty {
                return "\(value) "
            } else {
                return ""
            }
        }

        return [stencilExtension]
    }
}

/// Reserved keywords that are not allowed as function names, function parameters, or local variables, etc.
fileprivate let reservedKeywords: Set = [
    // Keywords used in declarations:
    "associatedtype", "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout",
    "internal", "let", "operator", "private", "precedencegroup", "protocol", "public", "rethrows", "static",
    "struct", "subscript", "typealias", "var",
    // Keywords used in statements:
    "break", "case", "catch", "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in",
    "repeat", "return", "throw", "switch", "where", "while",
    // Keywords used in expressions and types:
    "Any", "as", "catch", "false", "is", "nil", "rethrows", "self", "super", "throw", "throws", "true", "try", "async",
    // Keywords used in patterns:
    "_",
]

/// Utility function for escaping reserved keywords for a symbol name.
func escapeReservedKeywords(for name: String) -> String {
    reservedKeywords.contains(name) ? "`\(name)`" : name
}
