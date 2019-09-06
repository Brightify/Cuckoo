//
//  ObjectiveMatchers.swift
//  Cuckoo-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import Foundation

public func objcAny<T: NSObject>() -> T {
    return TrustMe<T>.onThis(OCMArg.any() as Any)
}

public func objcAny() -> String {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.any() as Any) as Any) as String
}

public func objcAnyClosure<IN1, OUT>() -> (IN1) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1) -> OUT).self).pointee
}

public func objcAnyClosure<IN1, IN2, OUT>() -> (IN1, IN2) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2) -> OUT).self).pointee
}

public func objcAnyClosure<IN1, IN2, IN3, OUT>() -> (IN1, IN2, IN3) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3) -> OUT).self).pointee
}

public func objcAnyClosure<IN1, IN2, IN3, IN4, OUT>() -> (IN1, IN2, IN3, IN4) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4) -> OUT).self).pointee
}

public func objcAnyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> (IN1, IN2, IN3, IN4, IN5) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5) -> OUT).self).pointee
}

public func objcAnyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> (IN1, IN2, IN3, IN4, IN5, IN6) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5, IN6) -> OUT).self).pointee
}

public func objcAnyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT).self).pointee
}

public func objcIsNil<T: NSObject>() -> T? {
    return TrustMe<T>.onThis(OCMArg.isNil() as Any)
}

public func objcIsNil() -> String? {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.isNil() as Any) as Any) as String
}

public func objcIsNotNil<T: NSObject>() -> T? {
    return TrustMe<T>.onThis(OCMArg.isNotNil() as Any)
}

public func objcIsNotNil() -> String? {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.isNotNil() as Any) as Any) as String
}

public func objcIsEqual<T: NSObject>(to object: T) -> T {
    return TrustMe<T>.onThis(OCMArg.isEqual(object) as Any)
}

public func objcIsEqual(to string: String) -> String {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.isEqual(string) as Any) as Any) as String
}

public func objcIsNotEqual<T: NSObject>(to object: T) -> T? {
    return TrustMe<T>.onThis(OCMArg.isNotEqual(object) as Any)
}

public func objcIsNotEqual(to string: String) -> String? {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.isNotEqual(string) as Any) as Any) as String
}
