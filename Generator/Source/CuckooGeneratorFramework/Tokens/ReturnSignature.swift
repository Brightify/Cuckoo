//
//  ReturnSignature.swift
//  CuckooGeneratorFramework
//
//  Created by Matyáš Kříž on 25/03/2019.
//

import Foundation

public struct ReturnSignature {
    public var isAsync: Bool
    public var throwType: ThrowType?
    public var returnType: WrappableType
    public var whereConstraints: [String]

    public init(isAsync: Bool, throwString: String?, returnType: WrappableType, whereConstraints: [String]) {
        self.isAsync = isAsync
        if let throwString = throwString {
            throwType = ThrowType(string: throwString)
        } else {
            throwType = nil
        }
        self.returnType = returnType
        self.whereConstraints = whereConstraints
    }
}

extension ReturnSignature: CustomStringConvertible {
    public var description: String {
        let asyncString = isAsync ? "async" : nil
        let trimmedReturnType = returnType.explicitOptionalOnly.sugarized.trimmed
        let returnString = trimmedReturnType.isEmpty || trimmedReturnType == "Void" ? nil : "-> \(returnType)"
        let whereString = whereConstraints.isEmpty ? nil : "where \(whereConstraints.joined(separator: ", "))"
        return [asyncString, throwType?.description, returnString, whereString].compactMap { $0 }.joined(separator: " ")
    }
}
