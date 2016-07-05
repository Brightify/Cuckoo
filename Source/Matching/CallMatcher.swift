//
//  CallMatcher.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// CallMatcher is used in verification to assert how many times was the call made. It can also be used to do different asserts on stub calls matched with parameter matchers.
public struct CallMatcher {
    private let matchesFunction: [StubCall] throws -> Bool
    
    public init(matchesFunction: [StubCall] -> Bool = { _ in true }) {
        self.matchesFunction = matchesFunction
    }
    
    public init(numberOfExpectedCalls: Int, compareCallsFunction: (expected: Int, actual: Int) -> Bool) {
        self.matchesFunction = {
            return compareCallsFunction(expected: numberOfExpectedCalls, actual: $0.count)
        }
    }

    public func matches(calls: [StubCall]) -> Bool {
        do {
            return try matchesFunction(calls)
        } catch {
            return false
        }
    }
    
    public func or(otherMatcher: CallMatcher) -> CallMatcher {
        return CallMatcher {
            return self.matches($0) || otherMatcher.matches($0)
        }
    }
    
    public func and(otherMatcher: CallMatcher) -> CallMatcher {
        return CallMatcher {
            return self.matches($0) && otherMatcher.matches($0)
        }
    }
}