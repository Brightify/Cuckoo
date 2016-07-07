//
//  CallMatcher.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// CallMatcher is used in verification to assert how many times was the call made. It can also be used to do different asserts on stub calls matched with parameter matchers.
public struct CallMatcher {
    public let name: String
    
    private let matchesFunction: [StubCall] -> Bool
    
    public init(name: String, matchesFunction: [StubCall] -> Bool) {
        self.name = name
        self.matchesFunction = matchesFunction
    }
    
    public init(name: String, numberOfExpectedCalls: Int, compareCallsFunction: (expected: Int, actual: Int) -> Bool) {
        self.init(name: name) {
            return compareCallsFunction(expected: numberOfExpectedCalls, actual: $0.count)
        }
    }

    public func matches(calls: [StubCall]) -> Bool {
        return matchesFunction(calls)
    }
    
    public func or(otherMatcher: CallMatcher) -> CallMatcher {
        let name = "either \(self.name) or \(otherMatcher.name)"
        return CallMatcher(name: name) {
            return self.matches($0) || otherMatcher.matches($0)
        }
    }
    
    public func and(otherMatcher: CallMatcher) -> CallMatcher {
        let name = "both \(self.name) and \(otherMatcher.name)"
        return CallMatcher(name: name) {
            return self.matches($0) && otherMatcher.matches($0)
        }
    }
}