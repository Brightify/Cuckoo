//
//  FileRepresentation.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework

public struct FileRepresentation {
    public let sourceFile: File
    public let declarations: [Token]
    
    public init(sourceFile: File, declarations: [Token]) {
        self.sourceFile = sourceFile
        self.declarations = declarations
    }
}

public extension FileRepresentation {
    public func mergeInheritance(with files: [FileRepresentation]) -> FileRepresentation {
        let tokens = self.declarations.reduce([Token]()) { list, token in
            let mergeToken = token.mergeInheritance(with: files)
            return list + [mergeToken]
        }

        return FileRepresentation(sourceFile: self.sourceFile, declarations: tokens)
    }
}

internal extension Token {
    internal func mergeInheritance(with files: [FileRepresentation]) -> Token {
        guard let typeToken = self as? ContainerToken else {
            return self
        }
        let inheritedRepresentations: [Token] = typeToken.inheritedTypes
                .compactMap { Self.findToken(forClassOrProtocol: $0.name, in: files) }
                .compactMap { $0.mergeInheritance(with: files) }

        // Merge super declarations
        let mergedTokens = inheritedRepresentations.filter { $0.isClassOrProtocolDefinition }
                .map { $0 as! ContainerToken }
                .flatMap { $0.children }
                .reduce(typeToken.children) { tokens, inheritedToken in
                    if (tokens.contains { $0 == inheritedToken }) {
                        return tokens
                    }
                    return tokens + [inheritedToken]
                }
        switch typeToken {
        case let classToken as ClassDeclaration:
            return classToken.replace(children: mergedTokens)
        case let protocolToken as ProtocolDeclaration:
            return protocolToken.replace(children: mergedTokens)
        default:
            return typeToken
        }
    }

    internal static func findToken(forClassOrProtocol name: String, in files: [FileRepresentation]) -> Token? {
        return files.flatMap { $0.declarations }
                .filter { $0.isClassOrProtocolDefinition }
                .map { $0 as! ContainerToken }
                .first { $0.name == name }
    }
}
