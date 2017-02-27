//
//  .swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Method: Token {
    var name: String { get }
    var accessibility: Accessibility { get }
    var returnSignature: String { get }
    var range: CountableRange<Int> { get }
    var nameRange: CountableRange<Int> { get }
    var parameters: [MethodParameter] { get }
    var isOptional: Bool { get }
    var isOverriding: Bool { get }
    var hasClosureParams: Bool { get }
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
        let parameterTypes = parameters.map { $0.type }
        let nameParts = name.components(separatedBy: ":")
        let lastNamePart = nameParts.last ?? ""
        
        return zip(nameParts.dropLast(), parameterTypes)
            .map { $0 + ": " + $1 }
            .joined(separator: ", ") + lastNamePart + returnSignature
    }
    
    var isThrowing: Bool {
        return returnSignature.trimmed.hasPrefix("throws")
    }
    
    var returnType: String {
        if let range = returnSignature.range(of: "->") {
            var type = String(returnSignature[range.upperBound...]).trimmed
            while type.hasSuffix("?") {
                type = "Optional<\(type[..<type.index(before: type.endIndex)])>"
            }
            return type
        } else {
            return "Void"
        }
    }
    
    var hasClosureParams: Bool {
        return parameters.filter { $0.isClosure }.count > 0
    }

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? Method else { return false }
        return self.name == other.name && self.parameters == other.parameters
    }

    public func serialize() -> [String : Any] {
        let call = parameters.map {
            if let label = $0.label {
                return "\(label): \($0.name)"
            } else {
                return $0.name
            }
        }.joined(separator: ", ")

        let stubFunctionPrefix = isOverriding ? "Class" : "Protocol"
        let stubFunction: String
        if isThrowing {
            if returnType == "Void" {
                stubFunction = "Cuckoo.\(stubFunctionPrefix)StubNoReturnThrowingFunction"
            } else {
                stubFunction = "Cuckoo.\(stubFunctionPrefix)StubThrowingFunction"
            }
        } else {
            if returnType == "Void" {
                stubFunction = "Cuckoo.\(stubFunctionPrefix)StubNoReturnFunction"
            } else {
                stubFunction = "Cuckoo.\(stubFunctionPrefix)StubFunction"
            }
        }

        return [
            "name": rawName,
            "accessibility": accessibility.sourceName,
            "returnSignature": returnSignature,
            "parameters": parameters,
            "parameterNames": parameters.map { $0.name }.joined(separator: ", "),
            "isInit": isInit,
            "returnType": returnType,
            "isThrowing": isThrowing,
            "fullyQualifiedName": fullyQualifiedName,
            "call": call,
            "isOverriding": isOverriding,
            "parameterSignature": parameters.map { "\($0.labelAndName): \($0.type)" }.joined(separator: ", "),
            "parameterSignatureWithoutNames": parameters.map { "\($0.name): \($0.type)" }.joined(separator: ", "),
            "stubFunction": stubFunction,
            "inputTypes": parameters.map { $0.typeWithoutAttributes }.joined(separator: ", "),
            "isOptional": isOptional,
            "hasClosureParams": hasClosureParams
        ]
    }
}
