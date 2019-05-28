//
//  ObjectiveMatchers.swift
//  Cuckoo-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import Foundation

public func objectiveAny<T: NSObject>() -> T {
    return TrustMe<T>.onThis(OCMArg.any() as Any)
}

public func objectiveAnyClosure<IN1, OUT>() -> (IN1) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1) -> OUT).self).pointee
}

public func objectiveAnyClosure<IN1, IN2, OUT>() -> (IN1, IN2) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2) -> OUT).self).pointee
}

public func objectiveAnyClosure<IN1, IN2, IN3, OUT>() -> (IN1, IN2, IN3) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3) -> OUT).self).pointee
}

public func objectiveAnyClosure<IN1, IN2, IN3, IN4, OUT>() -> (IN1, IN2, IN3, IN4) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4) -> OUT).self).pointee
}

public func objectiveAnyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> (IN1, IN2, IN3, IN4, IN5) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5) -> OUT).self).pointee
}

public func objectiveAnyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> (IN1, IN2, IN3, IN4, IN5, IN6) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5, IN6) -> OUT).self).pointee
}

public func objectiveAnyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT).self).pointee
}

public func objectiveIsNil<T: NSObject>() -> T? {
    return TrustMe<T>.onThis(OCMArg.isNil() as Any)
}

public func objectiveIsNotNil<T: NSObject>() -> T? {
    return TrustMe<T>.onThis(OCMArg.isNotNil() as Any)
}

public func objectiveIsEqual<T: NSObject>(to object: T) -> T {
    return TrustMe<T>.onThis(OCMArg.isEqual(object) as Any)
}

public func objectiveIsNotEqual<T: NSObject>(to object: T) -> T? {
    return TrustMe<T>.onThis(OCMArg.isNotEqual(object) as Any)
}
