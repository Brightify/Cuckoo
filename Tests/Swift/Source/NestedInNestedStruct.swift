//
//  NestedInNestedStruct.swift
//  Cuckoo
//
//  Created by Tyler Thompson on 9/18/20.
//

import Foundation

struct NestedStruct {
    class NestedTestedSubclass: TestedClass { }
}

extension NestedStruct {
    class NestedExtensionTestedClass: TestedClass { }
}
