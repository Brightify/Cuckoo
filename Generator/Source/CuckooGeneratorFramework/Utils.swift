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
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func takeUntilStringOccurs(occurence: String) -> String? {
        return self.componentsSeparatedByString(occurence).first
    }
    
    subscript(range: Range<Int>) -> String {
        let stringRange = startIndex.advancedBy(range.startIndex)..<startIndex.advancedBy(range.endIndex)
        return self[stringRange]
    }
}

extension SequenceType {
    
    func only<T>(type: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
    
    func noneOf<T>(type: T.Type) -> [Generator.Element] {
        return filter { !($0 is T) }
    }
}

internal func extractRange(dictionary: [String: SourceKitRepresentable], offsetKey: Key, lengthKey: Key) -> Range<Int>? {
    guard let
        offset = (dictionary[offsetKey.rawValue] as? Int64).map({ Int($0) }),
        length = (dictionary[lengthKey.rawValue] as? Int64).map({ Int($0) })
        else { return nil }
    
    return offset..<offset.advancedBy(length)
}