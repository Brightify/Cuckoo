//
//  NestedInNestedStruct.swift
//  Cuckoo
//
//  Created by thompsty on 9/18/20.
//

import Foundation

struct NestedStruct {
    class NestedTestedSubclass: TestedClass { }
}

extension NestedStruct {
    class NestedExtensionTestedClass: TestedClass { }
}
