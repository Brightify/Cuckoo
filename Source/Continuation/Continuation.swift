//
//  Continuation.swift
//  Cuckoo
//
//  Created by Shoto Kobayashi on 03/09/2022.
//

import Foundation

public protocol Continuation {
    var exitOnSuccess: Bool { get }

    func check() -> Bool

    func wait()

    func times(_ count: Int) -> VerificationSpec

    func never() -> VerificationSpec

    func atLeastOnce() -> VerificationSpec

    func atLeast(_ count: Int) -> VerificationSpec

    func atMost(_ count: Int) -> VerificationSpec

    func with(_ callMatcher: CallMatcher) -> VerificationSpec
}

public extension Continuation {
    func times(_ count: Int) -> VerificationSpec {
        VerificationSpec(callMatcher: Cuckoo.times(count), continuation: self)
    }

    func never() -> VerificationSpec {
        VerificationSpec(callMatcher: Cuckoo.times(0), continuation: self)
    }

    func atLeastOnce() -> VerificationSpec {
        VerificationSpec(callMatcher: Cuckoo.atLeast(1), continuation: self)
    }

    func atLeast(_ count: Int) -> VerificationSpec {
        VerificationSpec(callMatcher: Cuckoo.atLeast(count), continuation: self)
    }

    func atMost(_ count: Int) -> VerificationSpec {
        VerificationSpec(callMatcher: Cuckoo.atMost(count), continuation: self)
    }

    func with(_ callMatcher: CallMatcher) -> VerificationSpec {
        VerificationSpec(callMatcher: callMatcher, continuation: self)
    }
}
