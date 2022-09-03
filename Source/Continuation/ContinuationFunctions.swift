//
//  ContinuationFunctions.swift
//  Cuckoo
//
//  Created by Shoto Kobayashi on 03/09/2022.
//

import Foundation

public func timeout(_ timeoutDuration: TimeInterval, waitingDuration: TimeInterval = 0.01) -> ContinuationWithTimeout {
    ContinuationWithTimeout(
        timeoutDuration: timeoutDuration,
        waitingDuration: waitingDuration
    )
}

public func after(_ delayDuration: TimeInterval, waitingDuration: TimeInterval = 0.01) -> ContinueationAfterDelay {
    ContinueationAfterDelay(
        delayDuration: delayDuration,
        waitingDuration: waitingDuration
    )
}
