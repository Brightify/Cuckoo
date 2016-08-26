//
//  FileHeaderHandler.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import FileKit

public struct FileHeaderHandler {
    
    public static func getHeader(file: FileRepresentation, withTimestamp timestamp: Bool) -> String {
        let path: String
        if let absolutePath = file.sourceFile.path {
            path = getRelativePath(absolutePath)
        } else {
            path = "unknown"
        }
        let generationInfo = "// MARK: - Mocks generated from file: \(path)" + (timestamp ? " at \(NSDate())\n" : "")
        let header = getHeader(file)
        return generationInfo + "\n" + header + "\n"
    }
    
    public static func getImports(file: FileRepresentation, testableFrameworks: [String]) -> String {
        var imports = Array(Set(file.declarations.only(Import).map { "import " + $0.library + "\n" })).sort().joinWithSeparator("")
        if imports.isEmpty == false {
            imports = "\n" + imports
        }
        return "import Cuckoo\n" + getTestableImports(testableFrameworks) + imports
    }
    
    private static func getRelativePath(absolutePath: String) -> String {
        let path = Path(absolutePath)
        let base = path.commonAncestor(Path.Current)
        let components = path.components.suffixFrom(base.components.endIndex)
        let result = components.map { $0.rawValue }.joinWithSeparator(Path.separator)
        let difference = Path.Current.components.endIndex - base.components.endIndex
        return (0..<difference).reduce(result) { acc, _ in ".." + Path.separator + acc }
    }
    
    private static func getHeader(file: FileRepresentation) -> String {
        let possibleHeaderEnd = getPossibleHeaderEnd(file.sourceFile.contents.unicodeScalars.count, declarations: file.declarations)
        let possibleHeader = String(file.sourceFile.contents.utf8.prefix(possibleHeaderEnd)) ?? ""
        let singleLine = getPrefixToLastSingleLineComment(possibleHeader)
        let multiLine = getPrefixToLastMultiLineComment(possibleHeader)
        return singleLine.characters.count > multiLine.characters.count ? singleLine : multiLine
    }
    
    private static func getPossibleHeaderEnd(currentValue: Int, declarations: [Token]) -> Int {
        return declarations.reduce(currentValue) { minimum, declaration in
            let declarationMinimum: Int
            switch declaration {
            case let containerToken as ContainerToken:
                declarationMinimum = containerToken.range.startIndex
            case let method as Method:
                declarationMinimum = method.range.startIndex
            case let importToken as Import:
                declarationMinimum = importToken.range.startIndex
            default:
                declarationMinimum = minimum
            }
            return min(declarationMinimum, minimum)
        }
    }
    
    private static func getPrefixToLastSingleLineComment(text: String) -> String {
        if let range = text.rangeOfString("//", options: .BackwardsSearch) {
            let lastLine = text.lineRangeForRange(range)
            return text.substringToIndex(lastLine.endIndex)
        } else {
            return ""
        }
    }
    
    private static func getPrefixToLastMultiLineComment(text: String) -> String {
        if let range = text.rangeOfString("*/", options: .BackwardsSearch) {
            return text.substringToIndex(range.endIndex) + "\n"
        } else {
            return ""
        }
    }
    
    private static func getTestableImports(testableFrameworks: [String]) -> String {
        func replaceIllegalCharacters(char: UnicodeScalar) -> Character {
            if NSCharacterSet.letterCharacterSet().longCharacterIsMember(char.value) || NSCharacterSet.decimalDigitCharacterSet().longCharacterIsMember(char.value) {
                return Character(char)
            } else {
                return "_"
            }
        }
        return testableFrameworks.map { String($0.unicodeScalars.map(replaceIllegalCharacters)) }.map { "@testable import \($0)\n" }.joinWithSeparator("")
    }
}
