//
//  .swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Method: Token {
    var name: String { get }
    var accessibility: Accessibility { get }
    var returnSignature: String { get }
    var range: Range<Int> { get }
    var nameRange: Range<Int> { get }
    var parameters: [MethodParameter] { get }
}

public extension Method {
    var rawName: String {
        return name.takeUntilStringOccurs("(") ?? ""
    }
    
    var isInit: Bool {
        return rawName == "init"
    }
    
    var fullyQualifiedName: String {
        let parameterTypes = parameters.map { $0.type }
        let nameParts = name.componentsSeparatedByString(":")
        let lastNamePart = nameParts.last ?? ""
        
        return zip(nameParts.dropLast(), parameterTypes)
            .map { $0 + ": " + $1 }
            .joinWithSeparator(", ") + lastNamePart + returnSignature
    }
    
    var isThrowing: Bool {
        return returnSignature.trimmed.hasPrefix("throws")
    }
    
    var returnType: String {
        if let range = returnSignature.rangeOfString("->") {
            return returnSignature.substringFromIndex(range.endIndex).trimmed
        } else {
            return "Void"
        }
    }
}