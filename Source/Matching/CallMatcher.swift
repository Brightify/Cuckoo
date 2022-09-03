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
    
    private let matchesFunction: ([StubCall]) -> Bool
    private let canRecoverFromFailureFunction: ([StubCall]) -> Bool
    
    public init(name: String, matchesFunction: @escaping ([StubCall]) -> Bool, canRecoverFromFailureFunction: @escaping ([StubCall]) -> Bool) {
        self.name = name
        self.matchesFunction = matchesFunction
        self.canRecoverFromFailureFunction = canRecoverFromFailureFunction
    }

    public init(
        name: String,
        numberOfExpectedCalls: Int,
        compareCallsFunction: @escaping (_ expected: Int, _ actual: Int) -> Bool,
        canRecoverFromFailureFunction: @escaping (_ expected: Int, _ actual: Int) -> Bool
    ) {
        self.init(name: name, matchesFunction: { compareCallsFunction(numberOfExpectedCalls, $0.count) }) {
            canRecoverFromFailureFunction(numberOfExpectedCalls, $0.count)
        }
    }

    public func matches(_ calls: [StubCall]) -> Bool {
        return matchesFunction(calls)
    }

    public func canRecoverFromFailure(_ calls: [StubCall]) -> Bool {
        canRecoverFromFailureFunction(calls)
    }
    
    public func or(_ otherMatcher: CallMatcher) -> CallMatcher {
        let name = "either \(self.name) or \(otherMatcher.name)"
        return CallMatcher(name: name, matchesFunction: { self.matches($0) || otherMatcher.matches($0) }) {
            self.canRecoverFromFailure($0) || otherMatcher.canRecoverFromFailureFunction($0)
        }
    }
    
    public func and(_ otherMatcher: CallMatcher) -> CallMatcher {
        let name = "both \(self.name) and \(otherMatcher.name)"
        return CallMatcher(name: name, matchesFunction: { self.matches($0) && otherMatcher.matches($0) }) {
            self.canRecoverFromFailure($0) && otherMatcher.canRecoverFromFailureFunction($0)
        }
    }
}
