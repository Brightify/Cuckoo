//
//  ContinuationWithTimeout.swift
//  Cuckoo
//
//  Created by Shoto Kobayashi on 03/09/2022.
//

import Foundation

public class ContinuationWithTimeout: NSObject, ContinuationWrapper {
    public let wrappedContinuation: ContinuationOverTime

    public init(timeoutDuration: TimeInterval, waitingDuration: TimeInterval) {
        wrappedContinuation = ContinuationOverTime(duration: timeoutDuration, waitingDuration: waitingDuration, exitOnSuccess: true)
    }
}
