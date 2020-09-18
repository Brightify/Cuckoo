//
//  NestedInPrivateNestedClass.swift
//  Cuckoo
//
//  Created by Tyler Thompson on 9/18/20.
//

import Foundation

fileprivate class PrivateNestedClass {
    class ThisClassShouldNotBeMocked2 {
        var property: Int?
    }
}
