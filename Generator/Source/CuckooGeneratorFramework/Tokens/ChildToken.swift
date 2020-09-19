//
//  ChildToken.swift
//  CuckooGeneratorFramework
//
//  Created by thompsty on 9/18/20.
//

import Foundation

public protocol ChildToken: Token {
    var parent: Reference<ParentToken>? { get set }
}

extension ChildToken {
    var topMostParent:ParentToken? {
        var currentParent = parent?.value
        while let grandParent = (currentParent as? ChildToken)?.parent?.value {
            currentParent = grandParent
        }
        return currentParent
    }
}
