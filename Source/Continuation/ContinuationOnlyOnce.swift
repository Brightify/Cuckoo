//
//  ContinuationOnlyOnce.swift
//  Cuckoo
//
//  Created by Shoto Kobayashi on 03/09/2022.
//

import Foundation

public class ContinuationOnlyOnce: NSObject, Continuation {
    public let exitOnSuccess = true

    private var isAlreadyChecked = false

    public override init() {
        super.init()
    }

    public func check() -> Bool {
        guard !isAlreadyChecked else {
            return false
        }
        isAlreadyChecked = true
        return true
    }

    public func wait() {
    }
}
