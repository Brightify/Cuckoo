//
//  ClassForStubTesting.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 21.09.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

class ClassForStubTesting {
    
    var intProperty: Int = 0
    
    var arrayProperty: [Int] = []
    
    var setProperty: Set<Int> = []
    
    var dictionaryProperty: [String: Int] = [:]
    
    var tuple1: (Int) = (1)
    
    var tuple2: (Int8, UInt8) = (1, 1)
    
    var tuple3: (Int16, UInt16, Bool) = (1, 1, true)
    
    var tuple4: (Int32, UInt32, Double, Int) = (1, 1, 1.1, 1)
    
    var tuple5: (Int64, UInt64, Float, Int, Int) = (1, 1, 1.1, 1, 1)
    
    var tuple6: (UInt, String, Int, Int, Int, Int) = (1, "A", 1, 1, 1, 1)

    func intFunction() -> Int {
        return intProperty
    }
    
    func arrayFunction() -> [Int] {
        return arrayProperty
    }
    
    func setFunction() -> Set<Int> {
        return setProperty
    }
    
    func dictionaryFunction() -> [String: Int] {
        return dictionaryProperty
    }
    
    func voidFunction() {
    }
}
