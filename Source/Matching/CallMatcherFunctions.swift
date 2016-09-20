//
//  CallMatcherFunctions.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Returns a matcher ensuring a call was made **`count`** times.
public func times(_ count: Int) -> CallMatcher {
    let name = count == 0 ? "never" : "\(count) times"
    return CallMatcher(name: name, numberOfExpectedCalls: count, compareCallsFunction: ==)
}

/// Returns a matcher ensuring no call was made.
public func never() -> CallMatcher {
    return times(0)
}

/// Returns a matcher ensuring at least one call was made.
public func atLeastOnce() -> CallMatcher {
    return atLeast(1)
}

/// Returns a matcher ensuring call was made at least `count` times.
public func atLeast(_ count: Int) -> CallMatcher {
    return CallMatcher(name: "at least \(count) times", numberOfExpectedCalls: count, compareCallsFunction: <=)
}

/// Returns a matcher ensuring call was made at most `count` times.
public func atMost(_ count: Int) -> CallMatcher {
    return CallMatcher(name: "at most \(count) times",numberOfExpectedCalls: count, compareCallsFunction: >=)
}
