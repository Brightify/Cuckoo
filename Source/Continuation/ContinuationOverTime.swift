//
//  ContinuationOverTime.swift
//  Cuckoo
//
//  Created by Shoto Kobayashi on 03/09/2022.
//

import Foundation

public class ContinuationOverTime: NSObject, Continuation {
    public let duration: TimeInterval
    public let waitingDuration: TimeInterval
    public let exitOnSuccess: Bool

    private var start: Date?

    public init(duration: TimeInterval, waitingDuration: TimeInterval, exitOnSuccess: Bool) {
        self.duration = duration
        self.waitingDuration = waitingDuration
        self.exitOnSuccess = exitOnSuccess
        super.init()
    }

    public func check() -> Bool {
        if start == nil {
            start = Date()
        }
        return -start!.timeIntervalSinceNow <= duration
    }

    public func wait() {
        Thread.sleep(forTimeInterval: waitingDuration)
    }

    public func times(_ count: Int) -> VerificationSpec {
        VerificationSpec(callMatcher: Cuckoo.times(count), continuation: self)
    }
}
