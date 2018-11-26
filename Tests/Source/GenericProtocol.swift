//
//  GenericProtocol.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 19/11/2018.
//

import Foundation

protocol GenericProtocol {
    associatedtype C: TestedClass
    associatedtype P: TestedProtocol

    var readWritePropertyT: C { get }
    var readWritePropertyU: P { get set }

    init(theC: C, theP: P)

    func callSomeC(theC: C) -> Int
    func callSomeP(theP: P) -> Int
    func compute(classy: C, proto: P) -> C
}
