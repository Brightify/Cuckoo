//
//  CallMatcherFunctions.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Returns a matcher ensuring a call was made **`count`** times.
@warn_unused_result
public func times(count: Int) -> CallMatcher {
    return CallMatcher(numberOfExpectedCalls: count, compareCallsFunction: ==)
}

/// Returns a matcher ensuring no call was made.
@warn_unused_result
public func never() -> CallMatcher {
    return times(0)
}

/// Returns a matcher ensuring at least one call was made.
@warn_unused_result
public func atLeastOnce() -> CallMatcher {
    return atLeast(1)
}

/// Returns a matcher ensuring call was made at least `count` times.
@warn_unused_result
public func atLeast(count: Int) -> CallMatcher {
    return CallMatcher(numberOfExpectedCalls: count, compareCallsFunction: >=)
}

/// Returns a matcher ensuring call was made at most `count` times.
@warn_unused_result
public func atMost(count: Int) -> CallMatcher {
    return CallMatcher(numberOfExpectedCalls: count, compareCallsFunction: <=)
}
