//
//  ParameterMatcher.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// ParameterMatcher matches parameters of methods in stubbing and verification.
public struct ParameterMatcher<T>: Matchable {
    private let matchesFunction: (T) -> Bool
    
    public init(matchesFunction: @escaping (T) -> Bool = { _ in true }) {
        self.matchesFunction = matchesFunction
    }
    
    public var matcher: ParameterMatcher<T> {
        return self
    }
    
    public func matches(_ input: T) -> Bool {
        return matchesFunction(input)
    }
}
