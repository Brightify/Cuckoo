//
//  CallMatcher.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct CallMatcher {
    private let matchesFunction: [StubCall] throws -> Bool
    
    public init(matchesFunction: [StubCall] -> Bool = { _ in true }) {
        self.matchesFunction = matchesFunction
    }
    
    public init(numberOfExpectedCalls: Int, compareCallsFunction: (Int, Int) -> Bool) {
        self.matchesFunction = {
            return compareCallsFunction(numberOfExpectedCalls, $0.count)
        }
    }
    
    public func matches(calls: [StubCall]) -> Bool {
        do {
            return try matchesFunction(calls)
        } catch {
            return false
        }
    }
}