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
            return "M\(index + 1).\(type) == \(genericSafeType(from: parameter.type.withoutAttributes(except: ["@Sendable"]).unoptionaled.description))"
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

        let tupleType = parameters.map { $0.type.withoutAttributes(except: ["@Sendable"]).description }.joined(separator: ", ")
        let matchers = parameters
            // Enumeration is done after filtering out parameters without usable names.
            .enumerated()
            .compactMap { index, parameter in
                let name = escapeReservedKeywords(for: parameter.usableName)
                return "wrap(matchable: \(name)) { $0\(parameters.count > 1 ? ".\(index)" : "") }"
            }
            .joined(separator: ", ")
        return "let matchers: [Cuckoo.ParameterMatcher<(\(genericSafeType(from: tupleType)))>] = [\(matchers)]"
    }

    private static func genericSafeType(from type: String) -> String {
        return type.replacingOccurrences(of: "!", with: "?")
    }

    private static func openNestedClosure(for method: Method) -> String {
        var fullString = ""
        for (index, parameter) in method.signature.parameters.enumerated() {
            if !parameter.type.containsAttribute(named: "@escaping"), let closure = parameter.type.findClosure() {
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
