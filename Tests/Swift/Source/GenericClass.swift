//
//  GenericClass.swift
//  Cuckoo-iOS
//
//  Created by Matyáš Kříž on 19/11/2018.
//

import Foundation

class GenericClass<T: CustomStringConvertible, U: Codable & CustomStringConvertible, V: Hashable & Equatable> {
    let constant = 10.0

    var readWritePropertyT: T
    var readWritePropertyU: U
    var readWritePropertyV: V

    var optionalProperty: U?

    init(theT: T, theU: U, theV: V) {
        readWritePropertyT = theT
        readWritePropertyU = theU
        readWritePropertyV = theV
    }

    func unequal(one: V, two: V) -> Bool {
        return one != two
    }

    func getThird(foo: T, bar: U, baz: V) -> V {
        return baz
    }

    func print(theT: T) {
        Swift.print(theT)
    }

    func encode(theU: U) -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(["root": theU])
    }

    func withClosure(_ closure: (T) -> Int) -> Int {
        return closure(readWritePropertyT)
    }

    func noReturn() {}
}
