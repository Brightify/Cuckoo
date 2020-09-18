//
//  ChildToken.swift
//  CuckooGeneratorFramework
//
//  Created by Tyler Thompson on 9/18/20.
//

import Foundation

public protocol ChildToken: Token {
    var parent: Reference<ParentToken>? { get set }
}
