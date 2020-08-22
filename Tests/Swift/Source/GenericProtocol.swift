//
//  GenericProtocol.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 19/11/2018.
//

import Foundation

protocol GenericProtocol {
    associatedtype C: AnyObject
    associatedtype V

    var readOnlyPropertyC: C { get }
    var readWritePropertyV: V { get set }

    var constant: Int { get }
    var optionalProperty: V? { get set }

    init<F>(theC: C, theV: V, f: F)

    func callSomeC(theC: C) -> Int
    func callSomeV(theV: V) -> Int
    func compute(classy: C, value: V) -> C
    func noReturn()
}
