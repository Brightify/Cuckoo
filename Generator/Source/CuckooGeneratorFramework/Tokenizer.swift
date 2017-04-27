//
//  Tokenizer.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import SourceKittenFramework

public struct Tokenizer {
    private let file: File
    private let source: String

    public init(sourceFile: File) {
        self.file = sourceFile

        source = sourceFile.contents
    }

    public func tokenize() -> FileRepresentation {
        let structure = Structure(file: file)

        let declarations = tokenize(structure.dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
        let imports = tokenize(imports: declarations)

        return FileRepresentation(sourceFile: file, declarations: declarations + imports)
    }

    private func tokenize(_ representables: [SourceKitRepresentable]) -> [Token] {
        return representables.flatMap(tokenize)
    }

    internal static let nameNotSet = "name not set"
    internal static let unknownType = "unknown type"
    private func tokenize(_ representable: SourceKitRepresentable) -> Token? {
        guard let dictionary = representable as? [String: SourceKitRepresentable] else { return nil }

        // Common fields
        let name = dictionary[Key.Name.rawValue] as? String ?? Tokenizer.nameNotSet
        let kind = dictionary[Key.Kind.rawValue] as? String ?? Tokenizer.unknownType

        // Inheritance
        let inheritedTypes = dictionary[Key.InheritedTypes.rawValue] as? [SourceKitRepresentable] ?? []
        let tokenizedInheritedTypes = inheritedTypes.flatMap { type -> InheritanceDeclaration in
            guard let typeDict = type as? [String: SourceKitRepresentable] else {
                return InheritanceDeclaration.empty
            }
            let name = typeDict[Key.Name.rawValue] as? String ?? Tokenizer.nameNotSet
            return InheritanceDeclaration(name: name)
        }

        // Optional fields
        let range = extractRange(from: dictionary, offset: .Offset, length: .Length)
        let nameRange = extractRange(from: dictionary, offset: .NameOffset, length: .NameLength)
        let bodyRange = extractRange(from: dictionary, offset: .BodyOffset, length: .BodyLength)

        let attributes = dictionary[Key.Attributes.rawValue]

        let attributeOptional = (dictionary[Key.Attributes.rawValue] as? [Any])?.first(where: {($0 as? [String : String])?[Key.Attribute.rawValue] == Kinds.Optional.rawValue}) != nil

        let accessibility = (dictionary[Key.Accessibility.rawValue] as? String).flatMap { Accessibility(rawValue: $0) }
        let type = dictionary[Key.TypeName.rawValue] as? String

        switch kind {
        case Kinds.ProtocolDeclaration.rawValue:
            let subtokens = tokenize(dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
            let initializers = subtokens.only(Initializer.self)
            let children = subtokens.noneOf(Initializer.self)

            return ProtocolDeclaration(
                name: name,
                accessibility: accessibility!,
                range: range!,
                nameRange: nameRange!,
                bodyRange: bodyRange!,
                initializers: initializers,
                children: children,
                inheritedTypes: tokenizedInheritedTypes)

        case Kinds.ClassDeclaration.rawValue:
            let subtokens = tokenize(dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
            let initializers = subtokens.only(Initializer.self)
            let children = subtokens.noneOf(Initializer.self).map { child -> Token in
                if var property = child as? InstanceVariable {
                    property.overriding = true
                    return property
                } else {
                    return child
                }
            }

            return ClassDeclaration(
                name: name,
                accessibility: accessibility!,
                range: range!,
                nameRange: nameRange!,
                bodyRange: bodyRange!,
                initializers: initializers,
                children: children,
                inheritedTypes: tokenizedInheritedTypes)

        case Kinds.ExtensionDeclaration.rawValue:
            return ExtensionDeclaration(range: range!)

        case Kinds.InstanceVariable.rawValue:
            let setterAccessibility = (dictionary[Key.SetterAccessibility.rawValue] as? String).flatMap(Accessibility.init)

            if String(describing: source.utf8.dropFirst(range!.startIndex)).takeUntil(occurence: name)?.trimmed.hasPrefix("let") == true {
                return nil
            }

            if type == nil {
                stderrPrint("Type of instance variable \(name) could not be inferred. Please specify it explicitly. (\(file.path ?? ""))")
            }

            return InstanceVariable(
                name: name,
                type: type ?? "__UnknownType",
                accessibility: accessibility!,
                setterAccessibility: setterAccessibility,
                range: range!,
                nameRange: nameRange!,
                overriding: false)

        case Kinds.InstanceMethod.rawValue:
            let parameters = tokenize(methodName: name, parameters: dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])

            var returnSignature: String
            if let bodyRange = bodyRange {
                returnSignature = source.utf8[nameRange!.endIndex..<bodyRange.startIndex].takeUntil(occurence: "{")?.trimmed ?? ""
            } else {
                returnSignature = source.utf8[nameRange!.endIndex..<range!.endIndex].trimmed
                if returnSignature.isEmpty {
                    let untilThrows = String(source.utf8.dropFirst(nameRange!.endIndex))?
                        .takeUntil(occurence: "throws").map { $0 + "throws" }?
                        .trimmed
                    if let untilThrows = untilThrows, untilThrows == "throws" || untilThrows == "rethrows" {
                        returnSignature = "\(untilThrows)"
                    }
                }
            }
            if returnSignature.isEmpty == false {
                returnSignature = " " + returnSignature
            }

            // When bodyRange != nil, we need to create .ClassMethod instead of .ProtocolMethod
            if let bodyRange = bodyRange {
                return ClassMethod(
                    name: name,
                    accessibility: accessibility!,
                    returnSignature: returnSignature,
                    range: range!,
                    nameRange: nameRange!,
                    parameters: parameters,
                    bodyRange: bodyRange)
            } else {
                return ProtocolMethod(
                    name: name,
                    accessibility: accessibility!,
                    returnSignature: returnSignature,
                    isOptional: attributeOptional,
                    range: range!,
                    nameRange: nameRange!,
                    parameters: parameters)
            }

        default:
            // Do not log anything, until the parser contains all known cases.
            // stderrPrint("Unknown kind. Dictionary: \(dictionary) \(file.path ?? "")")
            return nil
        }
    }

    private func tokenize(methodName: String, parameters: [SourceKitRepresentable]) -> [MethodParameter] {
        // Takes the string between `(` and `)`
        let parameterNames = methodName.components(separatedBy: "(").last?.characters.dropLast(1).map { "\($0)" }.joined(separator: "")
        var parameterLabels: [String?] = parameterNames?.components(separatedBy: ":").map { $0 != "_" ? $0 : nil } ?? []

        // Last element is not type.
        parameterLabels = Array(parameterLabels.dropLast())

        // Substructure can contain some other informations after the parameters.
        let filteredParameters = parameters.filter({
            let dictionary = $0 as? [String: SourceKitRepresentable]
            let kind = dictionary?[Key.Kind.rawValue] as? String ?? ""
            return kind == Kinds.MethodParameter.rawValue
        })

        return zip(parameterLabels, filteredParameters).flatMap(tokenize)
    }

    private func tokenize(parameterLabel: String?, parameter: SourceKitRepresentable) -> MethodParameter? {
        guard let dictionary = parameter as? [String: SourceKitRepresentable] else { return nil }
        
        let name = dictionary[Key.Name.rawValue] as? String ?? Tokenizer.nameNotSet
        let kind = dictionary[Key.Kind.rawValue] as? String ?? Tokenizer.unknownType
        let range = extractRange(from: dictionary, offset: .Offset, length: .Length)
        let nameRange = extractRange(from: dictionary, offset: .NameOffset, length: .NameLength)
        let type = dictionary[Key.TypeName.rawValue] as? String

        switch kind {
        case Kinds.MethodParameter.rawValue:
            return MethodParameter(label: parameterLabel, name: name, type: type!, range: range!, nameRange: nameRange!)

        default:
            stderrPrint("Unknown method parameter. Dictionary: \(dictionary) \(file.path ?? "")")
            return nil
        }
    }

    private func tokenize(imports otherTokens: [Token]) -> [Token] {
        let rangesToIgnore: [CountableRange<Int>] = otherTokens.flatMap { token in
            switch token {
            case let container as ContainerToken:
                return container.range
            case let extensionToken as ExtensionDeclaration:
                return extensionToken.range
            default:
                return nil
            }
        }
        do {
            let regex = try NSRegularExpression(pattern: "(?:\\b|;)import(?:\\s|(?:\\/\\/.*\\n)|(?:\\/\\*.*\\*\\/))+([^\\s;\\/]+)", options: [])
            let results = regex.matches(in: source, options: [], range: NSMakeRange(0, source.characters.count))
            return results.filter { result in
                    rangesToIgnore.filter { $0 ~= result.range.location }.isEmpty
                }.map {
                    let libraryRange = $0.rangeAt(1)
                    let fromIndex = source.index(source.startIndex, offsetBy: libraryRange.location)
                    let toIndex = source.index(fromIndex, offsetBy: libraryRange.length)
                    let library = source.substring(with: fromIndex..<toIndex)
                    let range = $0.range.location..<($0.range.location + $0.range.length)
                    return Import(range: range, library: library)
                }
        } catch let error as NSError {
            fatalError("Invalid regex:" + error.description)
        }
    }
}
