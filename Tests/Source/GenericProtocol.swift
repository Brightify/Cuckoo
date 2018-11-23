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

    func compute(classy: C, proto: P) -> C
}
