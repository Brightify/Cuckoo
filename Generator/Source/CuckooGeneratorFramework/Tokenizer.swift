//
//  Tokenizer.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

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
        let imports = tokenizeImports(declarations)
        
        return FileRepresentation(sourceFile: file, declarations: declarations + imports)
    }
    
    private func tokenize(representables: [SourceKitRepresentable]) -> [Token] {
        return representables.flatMap(tokenize)
    }
    
    private func tokenize(representable: SourceKitRepresentable) -> Token? {
        guard let dictionary = representable as? [String: SourceKitRepresentable] else { return nil }
        
        // Common fields
        let name = dictionary[Key.Name.rawValue] as? String ?? "name not set"
        let kind = dictionary[Key.Kind.rawValue] as? String ?? dictionary[Key.Attribute.rawValue] as? String ?? "unknown type"
        
        // Optional fields
        let range = extractRange(dictionary, offsetKey: .Offset, lengthKey: .Length)
        let nameRange = extractRange(dictionary, offsetKey: .NameOffset, lengthKey: .NameLength)
        let bodyRange = extractRange(dictionary, offsetKey: .BodyOffset, lengthKey: .BodyLength)
        
        let accessibility = (dictionary[Key.Accessibility.rawValue] as? String).flatMap { Accessibility(rawValue: $0) }
        let type = dictionary[Key.TypeName.rawValue] as? String
        
        switch kind {
        case Kinds.ProtocolDeclaration.rawValue:
            let subtokens = tokenize(dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
            let initializers = subtokens.only(Initializer)
            let children = subtokens.noneOf(Initializer)
            
            return ProtocolDeclaration(
                name: name,
                accessibility: accessibility!,
                range: range!,
                nameRange: nameRange!,
                bodyRange: bodyRange!,
                initializers: initializers,
                children: children)
            
        case Kinds.ClassDeclaration.rawValue:
            let subtokens = tokenize(dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
            let initializers = subtokens.only(Initializer)
            let children = subtokens.noneOf(Initializer).map { child -> Token in
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
                children: children)
            
        case Kinds.ExtensionDeclaration.rawValue:
            return ExtensionDeclaration(range: range!)
            
        case Kinds.InstanceVariable.rawValue:
            let setterAccessibility = (dictionary[Key.SetterAccessibility.rawValue] as? String).flatMap(Accessibility.init)
            
            if String(source.utf8.dropFirst(range!.startIndex)).takeUntilStringOccurs(name)?.trimmed.hasPrefix("let") == true {
                return nil
            }
            
            return InstanceVariable(
                name: name,
                type: type!,
                accessibility: accessibility!,
                setterAccessibility: setterAccessibility,
                range: range!,
                nameRange: nameRange!,
                overriding: false)
            
        case Kinds.InstanceMethod.rawValue:
            let parameters = tokenizeMethodParameters(name, dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
            
            var returnSignature: String
            if let bodyRange = bodyRange {
                returnSignature = source[nameRange!.endIndex..<bodyRange.startIndex].takeUntilStringOccurs("{")?.trimmed ?? ""
            } else {
                returnSignature = source[nameRange!.endIndex..<range!.endIndex].trimmed
                if returnSignature.isEmpty {
                    let untilThrows = String(source.utf8.dropFirst(nameRange!.endIndex))?
                        .takeUntilStringOccurs("throws").map { $0 + "throws" }?
                        .trimmed
                    if let untilThrows = untilThrows where untilThrows == "throws" || untilThrows == "rethrows" {
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
                    range: range!,
                    nameRange: nameRange!,
                    parameters: parameters)
            }

        case Kinds.Mark.rawValue:
            // Do not log warning
            return nil
            
        default:
            fputs("Unknown kind: \(kind)", stderr)
            return nil
        }
    }
    
    private func tokenizeMethodParameters(methodName: String, _ representables: [SourceKitRepresentable]) -> [MethodParameter] {
        // Takes the string between `(` and `)`
        let parameters = methodName.componentsSeparatedByString("(").last?.characters.dropLast(1).map { "\($0)" }.joinWithSeparator("")
        let parameterLabels: [String?] = parameters?.componentsSeparatedByString(":").map { $0 != "_" ? $0 : nil } ?? []
        
        return zip(parameterLabels, representables).flatMap(tokenizeMethodParameter)
    }
    
    private func tokenizeMethodParameter(label: String?, _ representable: SourceKitRepresentable) -> MethodParameter? {
        guard let dictionary = representable as? [String: SourceKitRepresentable] else { return nil }
        
        let name = dictionary[Key.Name.rawValue] as? String ?? "name not set"
        let kind = dictionary[Key.Kind.rawValue] as? String ?? dictionary[Key.Attribute.rawValue] as? String ?? "unknown type"
        let range = extractRange(dictionary, offsetKey: .Offset, lengthKey: .Length)
        let nameRange = extractRange(dictionary, offsetKey: .NameOffset, lengthKey: .NameLength)
        let type = dictionary[Key.TypeName.rawValue] as? String
        
        switch kind {
        case Kinds.MethodParameter.rawValue:
            let attributes = tokenizeAttributes(dictionary[Key.Attributes.rawValue] as? [SourceKitRepresentable] ?? [])
            return MethodParameter(label: label, name: name, type: type!, range: range!, nameRange: nameRange!, attributes: attributes)
            
        default:
            fputs("Unknown method parameter kind: \(kind)", stderr)
            return nil
        }
    }
    
    private func tokenizeAttributes(representables: [SourceKitRepresentable]) -> Attributes {
        return representables.map(tokenizeAttribute).reduce(Attributes.none) { $0.union($1) }
    }
    
    private func tokenizeAttribute(representable: SourceKitRepresentable) -> Attributes {
        guard let dictionary = representable as? [String: SourceKitRepresentable] else { return Attributes.none }
        
        let kind = dictionary[Key.Kind.rawValue] as? String ?? dictionary[Key.Attribute.rawValue] as? String ?? "unknown type"
        let range = extractRange(dictionary, offsetKey: .Offset, lengthKey: .Length)
        
        switch kind {
        case Kinds.AutoclosureAttribute.rawValue:
            let autoclosure = "@autoclosure" + source[0..<range!.startIndex].componentsSeparatedByString("@autoclosure").last!
            let escaping = autoclosure.containsString("escaping")
            
            return escaping ? Attributes.escapingAutoclosure : Attributes.autoclosure
            
        case Kinds.NoescapeAttribute.rawValue:
            return Attributes.noescape
            
        default:
            fputs("Unknown attribute kind: \(kind)", stderr)
            return Attributes.none
        }
    }
    
    private func tokenizeImports(otherTokens: [Token]) -> [Token] {
        let rangesToIgnore: [Range<Int>] = otherTokens.flatMap { token in
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
            let results = regex.matchesInString(source, options: [], range: NSMakeRange(0, source.characters.count))
            return results.filter { result in
                    rangesToIgnore.filter { $0 ~= result.range.location }.isEmpty
                }.map {
                    // This NSRange is always a valid Range
                    let range = $0.range.toRange()!
                    let library = (source as NSString).substringWithRange($0.rangeAtIndex(1))
                    return Import(range: range, library: library)
                }
        } catch let error as NSError {
            fatalError("Invalid regex:" + error.description)
        }
    }
}
