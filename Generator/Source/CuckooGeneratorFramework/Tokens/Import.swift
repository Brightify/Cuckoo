//
//  Import.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 17.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct Import: Token {
    public enum Importee: CustomStringConvertible {
        case library(name: String)
        case component(componentType: String, library: String, name: String)

        var description: {
            switch self {
            case .library(let name):
                return name
            case .component(let componentType, let library, let name):
                return "\(componentType) \(library).\(name)"
            }
        }
    }

    public let range: CountableRange<Int>
    public let importee: Importee

    public func isEqual(to other: Token) -> Bool {
        guard let other = other as? Import, self.range == other.range else { return false }
        switch (self, other) {
        case (.library(let lhsName), .library(let rhsName)):
            return lhsName == rhsName
        case (.component(let lhsImportType, let lhsLibrary, let lhsName), .component(let rhsImportType, let rhsLibrary, let rhsName)):
            return lhsImportType == rhsImportType && lhsLibrary == rhsLibrary && lhsName == rhsName
        default:
            return false
        }
    }
}
