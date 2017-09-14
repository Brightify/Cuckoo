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
        var msg: String?
        MockManager.fail = { (parameters) in
            let (message, _) = parameters
            msg = message
            
        }
        closure()
        MockManager.fail = fail
        return msg
    }
}
