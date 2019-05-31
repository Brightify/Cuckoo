//
//  TypeGuesser.swift
//  CuckooGeneratorFramework
//
//  Created by Matyáš Kříž on 31/05/2019.
//

import Foundation

struct TypeGuesser {
    static func guessType(from value: String) -> String? {
        let value = value.trimmed
        let casting = checkCasting(from: value)
        guard casting == nil else { return casting }

        let character = value[value.startIndex]
        switch character {
        case "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            return guessNumberType(from: value)
        case "_":
            return guessIdentifier(from: value)
        case "\"":
            return "String"
        default:
            let identifier = guessIdentifier(from: value)
            return identifier == "true" || identifier == "false" ? "Bool" : identifier
        }
    }

    private static func guessNumberType(from value: String) -> String {
        var iterator = value.makeIterator()
        while let character = iterator.next() {
            if character == "." || character == "e" {
                return "Double"
            }
        }
        return "Int"
    }

    private static func guessIdentifier(from value: String) -> String? {
        var identifier = ""
        var iterator = value.makeIterator()
        while let character = iterator.next() {
            guard character != "(" else { break }
            identifier.append(character)
        }
        return identifier
    }

    private static func checkCasting(from value: String) -> String? {
        let regex = try! NSRegularExpression(pattern: " as (.*)$")
        let range = NSRange(location: 0, length: value.count)
        guard let casting = regex.firstMatch(in: value, range: range) else { return nil }
        let foundRange = casting.range(at: 1)
        guard foundRange.location != NSNotFound else { return nil }
        return value[foundRange]
    }
}
