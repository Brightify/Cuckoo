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
            guard let parameters = value as? [MethodParameter] else { return value }
            return self.matchableGenerics(with: parameters)
        }

        ext.registerFilter("matchableGenericWhere") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return self.matchableGenerics(where: parameters)
        }

        ext.registerFilter("matchableParameterSignature") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return self.matchableParameterSignature(with: parameters)
        }

        ext.registerFilter("parameterMatchers") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return self.parameterMatchers(for: parameters)
        }

        ext.registerFilter("openNestedClosure") { (value: Any?, arguments: [Any?]) in
            guard let parameters = value as? [MethodParameter] else { return value }

            let s = self.openNestedClosure(for: parameters, throwing: arguments.first as? Bool)
            return s
        }

        ext.registerFilter("closeNestedClosure") { (value: Any?) in
            guard let parameters = value as? [MethodParameter] else { return value }
            return self.closeNestedClosure(for: parameters)
        }

        let environment = Environment(extensions: [ext])

        let containers = declarations.compactMap { $0 as? ContainerToken }
            .filter { $0.accessibility.isAccessible }
            .map { $0.serializeWithType() }

        return try environment.renderTemplate(string: Templates.mock, context: ["containers": containers, "debug": debug])
    }

    private func matchableGenerics(with parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }

        let genericParameters = (1...parameters.count).map { "M\($0): Cuckoo.Matchable" }.joined(separator: ", ")
        return "<\(genericParameters)>"
    }

    private func matchableGenerics(where parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }

        let whereClause = parameters.enumerated().map { "M\($0 + 1).MatchedType == \(genericSafeType(from: $1.typeWithoutAttributes))" }.joined(separator: ", ")
        return " where \(whereClause)"
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

    private func openNestedClosure(for parameters: [MethodParameter], throwing: Bool? = false) -> String {
        var fullString = ""
        for (index, parameter) in parameters.enumerated() {
            if parameter.isClosure && !parameter.isEscaping {
                let indents = String(repeating: "\t", count: index + 1)
                let tries = (throwing ?? false) ? " try " : " "
                fullString += "\(indents)return\(tries)withoutActuallyEscaping(\(parameter.name), do: { (\(parameter.name)) in\n"
            }
        }
        return fullString
    }

    private func closeNestedClosure(for parameters: [MethodParameter]) -> String {
        var fullString = ""
        for (index, parameter) in parameters.enumerated() {
            if parameter.isClosure && !parameter.isEscaping {
                let indents = String(repeating: "\t", count: index + 1)
                fullString += "\(indents)})\n"
            }
        }
        return fullString
    }
}
