//
//  FileHeaderHandler.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import FileKit

public struct FileHeaderHandler {

    public static func getHeader(of file: FileRepresentation, includeTimestamp: Bool) -> String {
        let path: String
        if let absolutePath = file.sourceFile.path {
            path = getRelativePath(from: absolutePath)
        } else {
            path = "unknown"
        }
        let generationInfo = "// MARK: - Mocks generated from file: \(path)" + (includeTimestamp ? " at \(Date())\n" : "")
        let header = getHeader(of: file)
        return generationInfo + "\n" + header + "\n"
    }

    public static func getImports(of file: FileRepresentation, testableFrameworks: [String]) -> String {
        var imports = Array(Set(file.declarations.only(Import.self).map { "import " + $0.library + "\n" })).sorted().joined(separator: "")
        if imports.isEmpty == false {
            imports = "\n" + imports
        }
        return "import Cuckoo\n" + getTestableImports(testableFrameworks: testableFrameworks) + imports
    }

    private static func getRelativePath(from absolutePath: String) -> String {
        let path = Path(absolutePath)
        let base = path.commonAncestor(Path.current)
        let components = path.components.suffix(from: base.components.endIndex)
        let result = components.map { $0.rawValue }.joined(separator: Path.separator)
        let difference = Path.current.components.endIndex - base.components.endIndex
        return (0..<difference).reduce(result) { acc, _ in ".." + Path.separator + acc }
    }

    private static func getHeader(of file: FileRepresentation) -> String {
        let possibleHeaderEnd = getPossibleHeaderEnd(current: file.sourceFile.contents.unicodeScalars.count, declarations: file.declarations)
        let possibleHeader = String(file.sourceFile.contents.utf8.prefix(possibleHeaderEnd)) ?? ""
        let singleLine = getPrefixToLastSingleLineComment(text: possibleHeader)
        let multiLine = getPrefixToLastMultiLineComment(text: possibleHeader)
        return singleLine.characters.count > multiLine.characters.count ? singleLine : multiLine
    }

    private static func getPossibleHeaderEnd(current: Int, declarations: [Token]) -> Int {
        return declarations.reduce(current) { minimum, declaration in
            let declarationMinimum: Int
            switch declaration {
            case let containerToken as ContainerToken:
                declarationMinimum = containerToken.range.lowerBound
            case let method as Method:
                declarationMinimum = method.range.lowerBound
            case let importToken as Import:
                declarationMinimum = importToken.range.lowerBound
            default:
                declarationMinimum = minimum
            }
            return min(declarationMinimum, minimum)
        }
    }

    private static func getPrefixToLastSingleLineComment(text: String) -> String {
        if let range = text.range(of: "//", options: .backwards) {
            let lastLine = text.lineRange(for: range)
            return text.substring(to: lastLine.upperBound)
        } else {
            return ""
        }
    }

    private static func getPrefixToLastMultiLineComment(text: String) -> String {
        if let range = text.range(of: "*/", options: .backwards) {
            return text.substring(to: range.upperBound) + "\n"
        } else {
            return ""
        }
    }

    private static func getTestableImports(testableFrameworks: [String]) -> String {
        func replaceIllegalCharacters(_ char: UnicodeScalar) -> Character {
            if CharacterSet.letters.contains(UnicodeScalar(char.value)!) || CharacterSet.decimalDigits.contains(UnicodeScalar(char.value)!) {
                return Character(char)
            } else {
                return "_"
            }
        }
        return testableFrameworks.map { String($0.unicodeScalars.map(replaceIllegalCharacters)) }.map { "@testable import \($0)\n" }.joined(separator: "")
    }
}
