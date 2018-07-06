//
//  MockManager+preconfigured.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 7/6/18.
//

import Foundation

extension MockManager {
    internal static let preconfiguredManagerThreadLocal = ThreadLocal<MockManager>()

    public static var preconfiguredManager: MockManager? {
        return preconfiguredManagerThreadLocal.value
    }
}
