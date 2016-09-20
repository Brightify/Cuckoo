//
//  TestUtils.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

@testable import Cuckoo

struct TestUtils {
    
    static func catchCuckooFail(inClosure closure: () -> ()) -> String? {
        let fail = MockManager.fail
        var message: String?
        MockManager.fail = { message = $0.0 }
        closure()
        MockManager.fail = fail
        return message
    }
}
