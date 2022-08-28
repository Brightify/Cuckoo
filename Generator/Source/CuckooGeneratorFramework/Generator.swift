//
//  Generator.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import Stencil

public struct Generator {
    
    private static let reservedKeywordsNotAllowedAsMethodName: Set = [
        // Keywords used in declarations:
        "associatedtype", "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let", "operator", "private", "precedencegroup", "protocol", "public", "rethrows", "static", "struct", "subscript", "typealias", "var",
        // Keywords used in statements:
        "break", "case", "catch", "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "return", "throw", "switch", "where", "while",
        // Keywords used in expressions and types:
        "Any", "as", "catch", "false", "is", "nil", "rethrows", "self", "super", "throw", "throws", "true", "try",
        // Keywords used in patterns:
        "_",
    ]

    private let declarations: [Token]
    private let code = CodeBuilder()

    public init(file: FileRepresentation) {
        declarations = file.declarations
    }

    public func generate(debug: Bool = false) throws -> String {
        code.clear()

        let ext = Extension()
        ext.registerFilter("genericSafe") { (value: Any?) in
            guard let string = value as? String else { return value }
            return self.genericSafeType(from: string)
        }

        ext.registerFilter("matchableGenericNames") { (value: Any?) in
            guard let method = value as? Method else { return value }
            return self.matchableGenericTypes(from: method)
        }

        ext.registerFilter("matchableGenericWhereClause") { (value: Any?) in
            guard let method = value as? Method else { return value }
            return self.matchableGenericsWhereClause(from: method)
        }

        ext.registerFilter("matchableParameterSignature") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return self.matchableParameterSignature(with: parameters)
        }

        ext.registerFilter("parameterMatchers") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return self.parameterMatchers(for: parameters)
        }

        ext.registerFilter("openNestedClosure") { (value: Any?) in
            guard let method = value as? Method else { return value }
            return self.openNestedClosure(for: method)
        }

        ext.registerFilter("closeNestedClosure") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return self.closeNestedClosure(for: parameters)
        }
        
        ext.registerFilter("escapeReservedKeywords") { (value: Any?) in
            guard let name = value as? String else { return value }
            return self.escapeReservedKeywords(for: name)
        }

        ext.registerFilter("removeClosureArgumentNames") { (value: Any?) in
            guard let type = value as? String else { return value }
            return self.removeClosureArgumentNames(for: type)
        }

        let environment = Environment(extensions: [ext])

        let containers = declarations.compactMap { $0 as? ContainerToken }
            .filter {
                $0.parent?.areAllHierarchiesAccessible ?? true && $0.accessibility.isAccessible
            }
            .map { $0.serializeWithType() }

        return try environment.renderTemplate(string: Templates.mock, context: ["containers": containers, "debug": debug])
    }

    private func matchableGenericTypes(from method: Method) -> String {
        guard !method.parameters.isEmpty || !method.genericParameters.isEmpty else { return "" }

        let matchableGenericParameters = method.parameters.enumerated().map { index, parameter -> String in
            let type = parameter.isOptional ? "OptionalMatchable" : "Matchable"
            return "M\(index + 1): Cuckoo.\(type)"
        }
        let methodGenericParameters = method.genericParameters.map { $0.description }
        return "<\((matchableGenericParameters + methodGenericParameters).joined(separator: ", "))>"
    }

    private func matchableGenericsWhereClause(from method: Method) -> String {
        guard method.parameters.isEmpty == false else { return "" }

        let matchableWhereConstraints = method.parameters.enumerated().map { index, parameter -> String in
            let type = parameter.isOptional ? "OptionalMatchedType" : "MatchedType"
            return "M\(index + 1).\(type) == \(genericSafeType(from: parameter.type.withoutAttributes.unoptionaled.sugarized))"
        }
        let methodWhereConstraints = method.returnSignature.whereConstraints
        return " where \((matchableWhereConstraints + methodWhereConstraints).joined(separator: ", "))"
    }

    private func matchableParameterSignature(with parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }

        return parameters.enumerated().map { "\($1.labelAndName): M\($0 + 1)" }.joined(separator: ", ")
    }

    private func parameterMatchers(for parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "let matchers: [Cuckoo.ParameterMatcher<Void>] = []" }

        let tupleType = parameters.map { $0.typeWithoutAttributes }.joined(separator: ", ")
        let matchers = parameters.enumerated().map { "wrap(matchable: \($1.name)) { $0\(parameters.count > 1 ? ".\($0)" : "") }" }.joined(separator: ", ")
        return "let matchers: [Cuckoo.ParameterMatcher<(\(genericSafeType(from: tupleType)))>] = [\(matchers)]"
    }

    private func genericSafeType(from type: String) -> String {
        return type.replacingOccurrences(of: "!", with: "?")
    }

    private func openNestedClosure(for method: Method) -> String {
        var fullString = ""
        for (index, parameter) in method.parameters.enumerated() {
            if parameter.isClosure && !parameter.isEscaping {
                let indents = String(repeating: "\t", count: index)
                let tries = method.isThrowing ? "try " : ""
                let awaits = method.isAsync ? "await " : ""

                let sugarizedReturnType = method.returnType.sugarized
                let returnSignature: String
                if sugarizedReturnType.isEmpty {
                    returnSignature = sugarizedReturnType
                } else {
                    returnSignature = " -> \(sugarizedReturnType)"
                }

                fullString += "\(indents)return \(tries)\(awaits)withoutActuallyEscaping(\(parameter.name), do: { (\(parameter.name): @escaping \(parameter.type))\(returnSignature) in\n"
            }
        }

        return fullString
    }

    private func closeNestedClosure(for parameters: [MethodParameter]) -> String {
        var fullString = ""
        for (index, parameter) in parameters.enumerated() {
            if parameter.isClosure && !parameter.isEscaping {
                let indents = String(repeating: "\t", count: index)
                fullString += "\(indents)})\n"
            }
        }
        return fullString
    }
    
    private func escapeReservedKeywords(for name: String) -> String {
        Self.reservedKeywordsNotAllowedAsMethodName.contains(name) ? "`\(name)`" : name
    }

    private func removeClosureArgumentNames(for type: String) -> String {
        type.replacingOccurrences(
            of: "_\\s+?[_a-zA-Z]\\w*?\\s*?:",
            with: "",
            options: .regularExpression
        )
    }
}
