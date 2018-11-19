//
//  GenericClass.swift
//  Cuckoo-iOS
//
//  Created by Matyáš Kříž on 19/11/2018.
//

import Foundation

class GenericClass<T: CustomStringConvertible, U, V> {
    func genericMethod(foo: T, bar: U, baz: V) -> U {
        return bar
    }
}
