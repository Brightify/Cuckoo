import Foundation

struct Method: Token, HasAttributes, HasAccessibility, HasName {
    var parent: Reference<Token>?

    var documentation: [String]
    var attributes: [Attribute]
    var accessibility: Accessibility
    var name: String
    var signature: Signature
    var isOptional: Bool

    var fullSignature: String {
        [
            accessibility.sourceName,
            "\(name)\(signature.description)",
        ]
        .compactMap { $0.nilIfEmpty }
        .joined(separator: " ")
    }
}

extension Method: Inheritable {
    func isEqual(to other: Inheritable) -> Bool {
        guard let other = other as? Method else { return false }
        return name == other.name && signature.isApiEqual(to: other.signature)
    }
}

extension Method {
    var fullyQualifiedName: String {
        "\(name)\(signature.description.trimmed)"
    }
    
    var isAsync: Bool {
        signature.asyncType.map { $0.isAsync || $0.isReasync } ?? false
    }
    
    var isThrowing: Bool {
        signature.throwType.map { $0.isThrowing || $0.isRethrowing } ?? false
    }
    
    var throwsOnly: Bool {
        signature.throwType.map { $0.isThrowing } ?? false
    }

    var returnType: ComplexType? {
        signature.returnType
    }

    var hasClosureParams: Bool {
        signature.parameters.contains { $0.type.isClosure }
    }

    var hasOptionalParams: Bool {
        signature.parameters.contains { $0.type.isOptional }
    }

    func serialize() -> [String : Any] {
        let call = signature.parameters
            .map { parameter in
                let name = escapeReservedKeywords(for: parameter.usableName)
                let value = "\(parameter.isInout ? "&" : "")\(name)\(parameter.type.containsAttribute(named: "@autoclosure") ? "()" : "")"
                if parameter.name == "_" {
                    return value
                } else {
                    return "\(parameter.name): \(value)"
                }
            }
            .joined(separator: ", ")

        guard let parent else {
            fatalError("Failed to find parent of method \(fullSignature). Please file a bug.")
        }

        let stubFunctionPrefix = parent.isClass ? "Class" : "Protocol"
        let returnString = returnType?.isVoid == false ? "" : "NoReturn"
        let throwingString = isThrowing ? "Throwing" : ""
        let stubFunction = "Cuckoo.\(stubFunctionPrefix)Stub\(returnString)\(throwingString)Function"

        let escapingParameterNames = signature.parameters.map { parameter in
            if !parameter.type.containsAttribute(named: "@escaping"), let closure = parameter.type.findClosure() {
                let parameterCount = closure.parameters.count
                let parameterSignature = parameterCount > 0 ? (1...parameterCount).map { _ in "_" }.joined(separator: ", ") : "()"

                return "{ \(parameterSignature) in fatalError(\"This is a stub! It's not supposed to be called!\") }"
            } else {
                return parameter.usableName
            }
        }.joined(separator: ", ")

        return [
            "self": self,
            "documentation": documentation,
            "attributes": attributes,
            "isOverriding": parent.isClass,
            "name": name,
            "accessibility": accessibility.sourceName,
            "signature": signature.description,
            "parameters": signature.parameters,
            "parameterNames": signature.parameters.map { escapeReservedKeywords(for: $0.usableName) }.joined(separator: ", "),
            "escapingParameterNames": escapingParameterNames,
            "returnType": returnType?.description ?? "",
            "isAsync": isAsync,
            "isThrowing": isThrowing,
            "throwsOnly": throwsOnly,
            "throwType": signature.throwType?.keyword ?? "",
            "throwTypeError": signature.throwType?.type ?? "",
            "fullyQualifiedName": fullyQualifiedName,
            "call": call,
            "parameterSignature": signature.parameters.map { $0.description }.joined(separator: ", "),
            "parameterSignatureWithoutNames": signature.parameters.map { "\($0.name): \($0.type)" }.joined(separator: ", "),
            "argumentSignature": signature.parameters.map { $0.type.description }.joined(separator: ", "),
            "stubFunction": stubFunction,
            "inputTypes": signature.parameters.map { $0.type.withoutAttributes(except: ["@escaping", "@Sendable"]).description }.joined(separator: ", "),
            "genericInputTypes": signature.parameters.map { $0.type.withoutAttributes(except: ["@Sendable"]).description }.joined(separator: ", "),
            "isOptional": isOptional,
            "hasClosureParams": hasClosureParams,
            "hasOptionalParams": hasOptionalParams,
            "genericParameters": signature.genericParameters.sourceDescription,
            "hasUnavailablePlatforms": hasUnavailablePlatforms,
            "unavailablePlatformsCheck": unavailablePlatformsCheck,
        ]
    }
}
