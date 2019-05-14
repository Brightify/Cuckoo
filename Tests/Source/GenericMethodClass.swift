//
//  GenericMethodClass.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 14/05/2019.
//

import Foundation

// there was a bug with "where" clauses incorrectly matching, this class is used to test it
class wViewyContwollew {}

class GenericMethodClass<T: CustomStringConvertible> {
    func senpai<OwO>(param: OwO) throws -> OwO where OwO: CustomStringConvertible {
        return param
    }

    func noticeMe<UwU>(param: @escaping () throws -> UwU) rethrows -> (T) -> (UwU) {
        let result = try param()
        return { something in
            return result
        }
    }

    func whereBug<T>(here: T) -> wViewyContwollew where T: wViewyContwollew {
        return here
    }

    func normal<W>() throws -> (Optional<W>) -> W where W: CustomStringConvertible {
        return { $0! }
    }

    func method<T>(param: T) where T: CustomStringConvertible {

    }

    func someRethrowing<UwU>(param: @escaping () throws -> UwU) rethrows {
        _ = try param()
    }

    func moreRethrowing<UwU>(param: @escaping () throws -> UwU) rethrows -> UwU {
        return try param()
    }
}
