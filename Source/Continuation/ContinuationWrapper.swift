//
//  ContinuationWrapper.swift
//  Cuckoo
//
//  Created by Shoto Kobayashi on 03/09/2022.
//

import Foundation

public protocol ContinuationWrapper: Continuation {
    associatedtype WrappedContinuation: Continuation

    var wrappedContinuation: WrappedContinuation { get }
}

public extension ContinuationWrapper {
    var exitOnSuccess: Bool {
        wrappedContinuation.exitOnSuccess
    }

    func check() -> Bool {
        wrappedContinuation.check()
    }

    func wait() {
        wrappedContinuation.wait()
    }
}
