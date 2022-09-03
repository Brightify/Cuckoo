//
//  ContinuationAfterDelay.swift
//  Cuckoo
//
//  Created by Shoto Kobayashi on 03/09/2022.
//


import Foundation

public class ContinueationAfterDelay: NSObject, ContinuationWrapper {
    public let wrappedContinuation: ContinuationOverTime

    public init(delayDuration: TimeInterval, waitingDuration: TimeInterval) {
        wrappedContinuation = ContinuationOverTime(duration: delayDuration, waitingDuration: waitingDuration, exitOnSuccess: false)
    }
}
