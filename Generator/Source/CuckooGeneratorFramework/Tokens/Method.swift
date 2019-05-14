//
//  Method.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Method: Token, HasAccessibility {
    var name: String { get }
    var returnSignature: ReturnSignature { get }
    var range: CountableRange<Int> { get }
    var nameRange: CountableRange<Int> { get }
    var parameters: [MethodParameter] { get }
    var isOptional: Bool { get }
    var isOverriding: Bool { get }
    var hasClosureParams: Bool { get }
    var hasOptionalParams: Bool { get }
    var attributes: [Attribute] { get }
    var genericParameters: [GenericParameter] { get }
}

public extension Method {
    var rawName: String {
        return name.takeUntil(occurence: "(") ?? ""
    }

    var isInit: Bool {
        return rawName == "init"
    }

    var isDeinit: Bool {
        return rawName == "deinit"
    }

    var fullyQualifiedName: String {
        let parameterTypes = parameters.map { ($0.isInout ? "inout " : "") + $0.type.sugarized }
        let nameParts = name.components(separatedBy: ":")
        let lastNamePart = nameParts.last ?? ""

        let returnSignatureDescription = returnSignature.description
        let returnSignatureString = returnSignatureDescription.isEmpty ? "" : " \(returnSignatureDescription)"

        return zip(nameParts.dropLast(), parameterTypes)
            .map { $0 + ": " + $1 }
            .joined(separator: ", ") + lastNamePart + returnSignatureString
    }

    var isThrowing: Bool {
        guard let throwType = returnSignature.throwType else { return false }
        return throwType.isThrowing || throwType.isRethrowing
    }

    var returnType: WrappableType {
        return returnSignature.returnType
    }

    var hasClosureParams: Bool {
        return parameters.contains { $0.isClosure }
    }

    var hasOptionalParams: Bool {
        return parameters.contains { $0.isOptional }
    }

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? Method else { return false }
        return self.name == other.name && self.parameters == other.parameters && self.returnType == other.returnType
    }

    public func serialize() -> [String : Any] {
        let call = parameters.map {
            let referencedName = "\($0.isInout ? "&" : "")\($0.name)"
            if let label = $0.label {
                return "\(label): \(referencedName)"
            } else {
                return referencedName
            }
        }.joined(separator: ", ")

        let stubFunctionPrefix = isOverriding ? "Class" : "Protocol"
        let stubFunction: String
        if isThrowing {
            if returnType.sugarized == "Void" {
                stubFunction = "Cuckoo.\(stubFunctionPrefix)StubNoReturnThrowingFunction"
            } else {
                stubFunction = "Cuckoo.\(stubFunctionPrefix)StubThrowingFunction"
            }
        } else {
            if returnType.sugarized == "Void" {
                stubFunction = "Cuckoo.\(stubFunctionPrefix)StubNoReturnFunction"
            } else {
                stubFunction = "Cuckoo.\(stubFunctionPrefix)StubFunction"
            }
        }

        let escapingParameterNames = parameters.map { parameter in
            if parameter.isClosure && !parameter.isEscaping {
                let parameterCount = parameter.closureParamCount
                let parameterSignature = parameterCount > 0 ? (1...parameterCount).map { _ in "_" }.joined(separator: ", ") : "()"
                return "{ \(parameterSignature) in fatalError(\"This is a stub! It's not supposed to be called!\") }"
            } else {
                return parameter.name
            }
        }.joined(separator: ", ")

        let genericParametersString = genericParameters.map { $0.description }.joined(separator: ", ")
        let isGeneric = !genericParameters.isEmpty

        return [
            "self": self,
            "name": rawName,
            "accessibility": accessibility.sourceName,
            "returnSignature": returnSignature.description,
            "parameters": parameters,
            "parameterNames": parameters.map { $0.name }.joined(separator: ", "),
            "escapingParameterNames": escapingParameterNames,
            "isInit": isInit,
            "returnType": returnType.sugarizedExplicitOnly,
            "isThrowing": isThrowing,
            "throwType": returnSignature.throwType?.description ?? "",
            "fullyQualifiedName": fullyQualifiedName,
            "call": call,
            "isOverriding": isOverriding,
            "parameterSignature": parameters.map { "\($0.labelAndName): \($0.isInout ? "inout " : "")\($0.type)" }.joined(separator: ", "),
            "parameterSignatureWithoutNames": parameters.map { "\($0.name): \($0.type)" }.joined(separator: ", "),
            "argumentSignature": parameters.map { $0.type.description }.joined(separator: ", "),
            "stubFunction": stubFunction,
            "inputTypes": parameters.map { $0.typeWithoutAttributes }.joined(separator: ", "),
            "isOptional": isOptional,
            "hasClosureParams": hasClosureParams,
            "hasOptionalParams": hasOptionalParams,
            "attributes": attributes.filter { $0.isSupported },
            "genericParameters": isGeneric ? "<\(genericParametersString)>" : "",
        ]
    }
}
