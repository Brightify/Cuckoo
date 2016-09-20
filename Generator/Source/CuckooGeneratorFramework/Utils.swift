//
//  String+Utility.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func takeUntil(occurence: String) -> String? {
        return self.components(separatedBy: occurence).first
    }
    
    subscript(range: Range<Int>) -> String {
        let stringRange = characters.index(startIndex, offsetBy: range.lowerBound)..<characters.index(startIndex, offsetBy: range.upperBound)
        return self[stringRange]
    }
}

extension Sequence {
    
    func only<T>(_ type: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
    
    func noneOf<T>(_ type: T.Type) -> [Iterator.Element] {
        return filter { !($0 is T) }
    }
}

internal func extractRange(_ dictionary: [String: SourceKitRepresentable], offsetKey: Key, lengthKey: Key) -> CountableRange<Int>? {
    guard let
        offset = (dictionary[offsetKey.rawValue] as? Int64).map({ Int($0) }),
        let length = (dictionary[lengthKey.rawValue] as? Int64).map({ Int($0) })
        else { return nil }
    
    return offset..<offset.advanced(by: length)
}
