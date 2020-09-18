import Foundation
import SourceKittenFramework

public struct Tokenizer {
    private let file: File
    private let source: String
    private let debugMode: Bool

    public init(sourceFile: File, debugMode: Bool) {
        self.file = sourceFile
        self.debugMode = debugMode

        source = sourceFile.contents
    }

    public func tokenize() -> FileRepresentation {
        do {
            let structure = try Structure(file: file)

            let declarations = tokenize(structure.dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
                .flatMap { declaration -> [Token] in
                    guard let parent = declaration as? ParentToken else { return [declaration] }
                    return [parent] + parent.adoptAllYoungerGenerations()
                }

            let imports = tokenize(imports: declarations)

            return FileRepresentation(sourceFile: file, declarations: declarations + imports)
        } catch {
            print("Error")
        }

        return FileRepresentation(sourceFile: file, declarations: [])
    }

    private func tokenize(_ representables: [SourceKitRepresentable]) -> [Token] {
        return representables.compactMap(tokenize)
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
        let tokenizedInheritedTypes = inheritedTypes.compactMap { type -> InheritanceDeclaration in
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

        // Attributes
        let attributes = (NSOrderedSet(array: (dictionary[Key.Attributes.rawValue] as? [SourceKitRepresentable] ?? [])
            .compactMap { attribute -> Attribute? in
                guard let attribute = attribute as? [String: SourceKitRepresentable],
                    let stringKind = attribute[Key.Attribute.rawValue] as? String,
                    let kind = Attribute.Kind(rawValue: stringKind),
                    let attributeRange = extractRange(from: attribute, offset: .Offset, length: .Length) else { return nil }
                let startIndex = source.utf8.index(source.utf8.startIndex, offsetBy: attributeRange.lowerBound)
                let endIndex = source.utf8.index(source.utf8.startIndex, offsetBy: attributeRange.upperBound)
                guard let text = String(source.utf8[startIndex..<endIndex]) else { return nil }
                return Attribute(kind: kind, text: text)
            }
        ).array as? [Attribute]) ?? []

        guard !attributes.map({ $0.kind }).contains(.final) else {
            if debugMode {
                fputs("Cuckoo: Ignoring mocking of '\(name)' because it's marked `final`.\n", stdout)
            }
            return nil
        }

        let accessibility = (dictionary[Key.Accessibility.rawValue] as? String).flatMap { Accessibility(rawValue: $0) } ?? .Internal
        let type: WrappableType?
        if let stringType = dictionary[Key.TypeName.rawValue] as? String {
            type = WrappableType(parsing: stringType)
        } else {
            type = nil
        }

        switch kind {
        case Kinds.ProtocolDeclaration.rawValue:
            let subtokens = tokenize(dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
            let initializers = subtokens.only(Initializer.self)
            let children = subtokens.noneOf(Initializer.self)
            let genericParameters = subtokens.only(GenericParameter.self)

            // FIXME: Remove when SourceKitten fixes the off-by-one error that includes the ending `>` in the last inherited type.
            let fixedGenericParameters = fixSourceKittenLastGenericParameterBug(genericParameters)

            return ProtocolDeclaration(
                name: name,
                accessibility: accessibility,
                range: range!,
                nameRange: nameRange!,
                bodyRange: bodyRange!,
                initializers: initializers,
                children: children,
                inheritedTypes: tokenizedInheritedTypes,
                attributes: attributes,
                genericParameters: fixedGenericParameters
            )

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
            let genericParameters = subtokens.only(GenericParameter.self)

            // FIXME: Remove when SourceKitten fixes the off-by-one error that includes the ending `>` in the last inherited type.
            let fixedGenericParameters = fixSourceKittenLastGenericParameterBug(genericParameters)

            return ClassDeclaration(
                name: name,
                accessibility: accessibility,
                range: range!,
                nameRange: nameRange!,
                bodyRange: bodyRange!,
                initializers: initializers,
                children: children,
                inheritedTypes: tokenizedInheritedTypes,
                attributes: attributes,
                genericParameters: fixedGenericParameters
            )

        case Kinds.StructDeclaration.rawValue:
            let subtokens = tokenize(dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
            let children = subtokens.only(ContainerToken.self)

            return StructDeclaration(
                name: name,
                accessibility: accessibility,
                range: range!,
                nameRange: nameRange!,
                bodyRange: bodyRange!,
                attributes: attributes,
                children: children
            )
            
        case Kinds.ExtensionDeclaration.rawValue:
            let subtokens = tokenize(dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])
            let children = subtokens.only(ContainerToken.self)

            return ExtensionDeclaration(
                name: name,
                accessibility: accessibility,
                range: range!,
                nameRange: nameRange!,
                bodyRange: bodyRange!,
                attributes: attributes,
                children: children
            )

        case Kinds.InstanceVariable.rawValue:
            let setterAccessibility = (dictionary[Key.SetterAccessibility.rawValue] as? String).flatMap(Accessibility.init)

            if String(source.utf8.dropFirst(range!.startIndex))?.takeUntil(occurence: name)?.trimmed.hasPrefix("let") == true {
                return nil
            }

            let guessedType: WrappableType?
            if type == nil {
                guessedType = TypeGuesser.guessType(from: String(source.utf8[range!.startIndex..<range!.endIndex].drop(while: { $0 != "=" }).dropFirst()).trimmed).map { .type($0) }
            } else {
                guessedType = type
            }

            return InstanceVariable(
                name: name,
                type: guessedType ?? .type("__UnknownType"),
                accessibility: accessibility,
                setterAccessibility: setterAccessibility,
                range: range!,
                nameRange: nameRange!,
                overriding: false,
                attributes: attributes
            )

        case Kinds.InstanceMethod.rawValue:
            let genericParameters = tokenize(dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? []).only(GenericParameter.self)
            let parameters = tokenize(methodName: name, parameters: dictionary[Key.Substructure.rawValue] as? [SourceKitRepresentable] ?? [])

            let returnSignature: ReturnSignature
            if let bodyRange = bodyRange {
                returnSignature = parseReturnSignature(source: source.utf8[nameRange!.endIndex..<bodyRange.startIndex].takeUntil(occurence: "{")?.trimmed ?? "")
            } else {
                returnSignature = parseReturnSignature(source: source.utf8[nameRange!.endIndex..<range!.endIndex].trimmed)
            }

            // methods can specify an empty public name of a parameter without any private name - `fun(_: String)`
            let namedParameters = parameters.enumerated().map { index, parameter -> MethodParameter in
                if parameter.name == Tokenizer.nameNotSet {
                    var mutableParameter = parameter
                    mutableParameter.name = "parameter\(index)"
                    return mutableParameter
                } else {
                    return parameter
                }
            }

            // FIXME: Remove when SourceKit fixes the off-by-one error that includes the ending `>` in the last inherited type.
            let fixedGenericParameters = fixSourceKittenLastGenericParameterBug(genericParameters)

            // When bodyRange != nil, we need to create `ClassMethod` instead of `ProtocolMethod`
            if let bodyRange = bodyRange {
                return ClassMethod(
                    name: name,
                    accessibility: accessibility,
                    returnSignature: returnSignature,
                    range: range!,
                    nameRange: nameRange!,
                    parameters: namedParameters,
                    bodyRange: bodyRange,
                    attributes: attributes,
                    genericParameters: fixedGenericParameters
                )
            } else {
                return ProtocolMethod(
                    name: name,
                    accessibility: accessibility,
                    returnSignature: returnSignature,
                    range: range!,
                    nameRange: nameRange!,
                    parameters: namedParameters,
                    attributes: attributes,
                    genericParameters: fixedGenericParameters
                )
            }

        case Kinds.GenericParameter.rawValue:
            return tokenize(parameterLabel: nil, parameter: representable)

        case Kinds.AssociatedType.rawValue:
            let regex = try! NSRegularExpression(pattern: "\\s*:\\s*([^\\s;\\/]+)")
            guard let range = range else { return nil }
            guard let inheritanceMatch = regex.firstMatch(
                in: source,
                range: NSMakeRange(range.startIndex, range.endIndex - range.startIndex)) else {
                return GenericParameter(name: name, range: range, inheritedType: nil)
            }
            let inheritanceRange = inheritanceMatch.range(at: 1)
            let fromIndex = source.index(source.startIndex, offsetBy: inheritanceRange.location)
            let toIndex = source.index(fromIndex, offsetBy: inheritanceRange.length)
            let inheritance = String(source[fromIndex..<toIndex])
            let fullRange = range.lowerBound..<(range.upperBound + inheritanceMatch.range.length)
            return GenericParameter(
                name: name,
                range: fullRange,
                inheritedType: InheritanceDeclaration(name: inheritance)
            )

        default:
            // Do not log anything, until the parser contains all known cases.
            // stderrPrint("Unknown kind. Dictionary: \(dictionary) \(file.path ?? "")")
            return nil
        }
    }

    private func tokenize(methodName: String, parameters: [SourceKitRepresentable]) -> [MethodParameter] {
        // Takes the string between `(` and `)`
        let parameterNames = methodName.components(separatedBy: "(").last?.dropLast(1).map { "\($0)" }.joined(separator: "")
        var parameterLabels: [String?] = parameterNames?.components(separatedBy: ":").map { $0 != "_" ? $0 : nil } ?? []

        // Last element is not type.
        parameterLabels = Array(parameterLabels.dropLast())

        // Substructure can contain some other information after the parameters.
        let filteredParameters = parameters.filter {
            let dictionary = $0 as? [String: SourceKitRepresentable]
            let kind = dictionary?[Key.Kind.rawValue] as? String ?? ""
            return kind == Kinds.MethodParameter.rawValue
        }

        return zip(parameterLabels, filteredParameters).compactMap { tokenize(parameterLabel: $0, parameter: $1) as? MethodParameter }
    }

    private func tokenize(parameterLabel: String?, parameter: SourceKitRepresentable) -> Token? {
        guard let dictionary = parameter as? [String: SourceKitRepresentable] else { return nil }

        let name = dictionary[Key.Name.rawValue] as? String ?? Tokenizer.nameNotSet
        let kind = dictionary[Key.Kind.rawValue] as? String ?? Tokenizer.unknownType
        let range = extractRange(from: dictionary, offset: .Offset, length: .Length)
        let nameRange = extractRange(from: dictionary, offset: .NameOffset, length: .NameLength)
        let type = dictionary[Key.TypeName.rawValue] as? String

        switch kind {
        case Kinds.MethodParameter.rawValue:
            // separate `inout` from the type and remember that the parameter is inout
            let type = type!

            // we want to remove `inout` and remember it, but we don't want to affect a potential `inout` closure parameter
            let inoutSeparatedType: String
            let isInout: Bool
            if let inoutRange = type.range(of: "inout ") {
                if let closureParenIndex = type.firstIndex(of: "("), closureParenIndex < inoutRange.upperBound {
                    inoutSeparatedType = type
                    isInout = false
                } else {
                    var mutableString = type
                    mutableString.removeSubrange(inoutRange)
                    inoutSeparatedType = mutableString
                    isInout = true
                }
            } else {
                inoutSeparatedType = type
                isInout = false
            }

            let wrappableType = WrappableType(parsing: inoutSeparatedType)

            return MethodParameter(label: parameterLabel, name: name, type: wrappableType, range: range!, nameRange: nameRange, isInout: isInout)

        case Kinds.GenericParameter.rawValue:
            let inheritedTypeElement = (dictionary[Key.InheritedTypes.rawValue] as? [SourceKitRepresentable] ?? []).first
            let inheritedType = (inheritedTypeElement as? [String: SourceKitRepresentable] ?? [:])[Key.Name.rawValue] as? String
            let inheritanceDeclaration: InheritanceDeclaration?

            if let inheritedType = inheritedType {
                inheritanceDeclaration = .init(name: inheritedType)
            } else {
                inheritanceDeclaration = nil
            }
            return GenericParameter(name: name, range: range!, inheritedType: inheritanceDeclaration)

        default:
            stderrPrint("Unknown method parameter. Dictionary: \(dictionary) \(file.path ?? "")")
            return nil
        }
    }

    private func tokenize(imports otherTokens: [Token]) -> [Token] {
        let rangesToIgnore: [CountableRange<Int>] = otherTokens.compactMap { token in
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
            let baseRegex = "(?:\\b|;)import(?:\\s|(?:\\/\\/.*\\n)|(?:\\/\\*.*\\*\\/))+"
            let identifierRegex = "[^\\s;\\/]+"
            let libraryImportRegex = baseRegex + "(\(identifierRegex))(?:\\n|(?:\\s)*;)"
            let componentImportRegex = baseRegex + "(\(identifierRegex))\\s+(\(identifierRegex))\\.(\(identifierRegex))"
            let libraryRegex = try NSRegularExpression(pattern: libraryImportRegex)
            let componentRegex = try NSRegularExpression(pattern: componentImportRegex)
            let librariesRange = NSRange(location: 0, length: source.count)
            let libraries = libraryRegex.matches(in: source, range: librariesRange)
                .filter { result in
                    rangesToIgnore.filter { $0 ~= result.range.location }.isEmpty
                }
                .map { result -> Import in
                    let range = result.range.location..<(result.range.location + result.range.length)
                    let library = source.stringMatch(from: result, at: 1)
                    return Import(range: range, importee: .library(name: library))
                }
            let components = componentRegex.matches(in: source, range: NSRange(location: 0, length: source.count))
                .filter { result in
                    rangesToIgnore.filter { $0 ~= result.range.location }.isEmpty
                }
                .map { result -> Import in
                    let componentRange = result.range(at: 1)
                    let componentType = componentRange.location == NSNotFound ? nil : source[componentRange]
                    let library = source[result.range(at: 2)]
                    let component = source[result.range(at: 3)]
                    let range = result.range.location..<(result.range.location + result.range.length)
                    return Import(range: range, importee: .component(componentType: componentType, library: library, name: component))
                }

            return libraries + components
        } catch let error as NSError {
            fatalError("Invalid regex:" + error.description)
        }
    }

    private func getReturnType(source: String, index: inout String.Index) -> String {
        var returnType = ""
        var afterArrow = true
        var parenLevel = 0

        while index != source.endIndex {
            let character = source[index]
            switch character {
            case "(", "<", "[":
                parenLevel += 1
                returnType.append(character)
                index = source.index(after: index)
            case ")", ">", "]":
                parenLevel -= 1
                returnType.append(character)
                index = source.index(after: index)
            case "-":
                index = source.index(after: index)
                // just a little sanity check
                guard source[index] == ">" else { fatalError("Uhh, what.") }
                index = source.index(after: index)
                returnType.append(" -> ")
                afterArrow = true
            case " ":
                index = source.index(after: index)
                returnType.append(character)
            case "w":
                let previousCharacter = source[source.index(before: index)]
                guard parenLevel == 0 && !afterArrow && previousCharacter == " " else {
                    returnType.append(character)
                    index = source.index(after: index)
                    continue
                }

                // we reached the "where" clause
                return returnType
            default:
                afterArrow = false
                returnType.append(character)
                index = source.index(after: index)
            }
        }

        return returnType
    }

    /// - returns: the where constraints parsed from the where clause
    private func parseWhereClause(source: String, index: inout String.Index) -> [String] {
        var whereConstraints = [] as [String]
        var currentConstraint = ""
        var parenLevel = 0
        while index != source.endIndex {
            let character = source[index]
            switch character {
            case "(", "<", "[":
                parenLevel += 1
                currentConstraint.append(character)
            case ")", ">", "]":
                parenLevel -= 1
                currentConstraint.append(character)
            case "," where parenLevel == 0:
                currentConstraint = currentConstraint.trimmed
                whereConstraints.append(currentConstraint)
                currentConstraint = ""
            default:
                currentConstraint.append(character)
            }

            index = source.index(after: index)
        }
        if !currentConstraint.isEmpty {
            currentConstraint = currentConstraint.trimmed
            whereConstraints.append(currentConstraint)
        }
        return whereConstraints
    }

    /// - parameter source: A trimmed string containing only the method return signature excluding the trailing brace
    /// - returns: ReturnSignature structure containing the parsed throwString, return type, and where constraints
    private func parseReturnSignature(source: String) -> ReturnSignature {
        var isAsync = false
        var throwString = nil as String?
        var returnType: WrappableType?
        var whereConstraints = [] as [String]

        var index = source.startIndex
        parseLoop: while index != source.endIndex {
            let character = source[index]
            switch character {
            case "a":
                isAsync = true
                let asyncString = "async"
                index = source.index(index, offsetBy: asyncString.count)
                continue
            case "r" where returnType == nil:
                throwString = "rethrows"
                index = source.index(index, offsetBy: throwString!.count)
                continue
            case "t" where returnType == nil:
                throwString = "throws"
                index = source.index(index, offsetBy: throwString!.count)
                continue
            case "w":
                index = source.index(index, offsetBy: "where".count)
                whereConstraints = parseWhereClause(source: source, index: &index)
                // the where clause is the last thing in method signature, so we'll just stop the parsing
                break parseLoop
            case "-":
                index = source.index(after: index)
                guard source[index] == ">" else { fatalError("Uhh, what.") }
                index = source.index(after: index)
                returnType = WrappableType(parsing: getReturnType(source: source, index: &index).trimmed)
                continue
            default:
                break
            }
            index = source.index(after: index)
        }

        return ReturnSignature(isAsync: isAsync, throwString: throwString, returnType: returnType ?? WrappableType.type("Void"), whereConstraints: whereConstraints)
    }

    // FIXME: Remove when SourceKitten fixes the off-by-one error that includes the ending `>` in the last inherited type.
    private func fixSourceKittenLastGenericParameterBug(_ genericParameters: [GenericParameter]) -> [GenericParameter] {
        let fixedGenericParameters: [GenericParameter]
        if let lastGenericParameter = genericParameters.last,
            let inheritedType = lastGenericParameter.inheritedType,
            inheritedType.name.hasSuffix(">>") == true {
            fixedGenericParameters = genericParameters.dropLast() + [
                GenericParameter(
                    name: lastGenericParameter.name,
                    range: lastGenericParameter.range.lowerBound..<lastGenericParameter.range.upperBound - 1,
                    inheritedType: InheritanceDeclaration(name: String(inheritedType.name.dropLast()))
                )
            ]
        } else {
            fixedGenericParameters = genericParameters
        }

        return fixedGenericParameters
    }
}

extension String {
    subscript(range: NSRange) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: range.location)
        let toIndex = self.index(fromIndex, offsetBy: range.length)
        return String(self[fromIndex..<toIndex])
    }
}

extension String {
    func stringMatch(from match: NSTextCheckingResult, at range: Int = 0) -> String {
        let matchRange = match.range(at: range)
        let fromIndex = index(startIndex, offsetBy: matchRange.location)
        let toIndex = index(fromIndex, offsetBy: matchRange.length)
        return String(self[fromIndex..<toIndex])
    }

    func removing(match: NSTextCheckingResult, at range: Int = 0) -> String {
        let matchRange = match.range(at: range)
        let fromIndex = index(startIndex, offsetBy: matchRange.location)
        let toIndex = index(fromIndex, offsetBy: matchRange.length)

        var mutableString = self
        mutableString.removeSubrange(fromIndex..<toIndex)
        return mutableString
    }
}
