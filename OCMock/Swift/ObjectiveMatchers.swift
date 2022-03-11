//
//  ObjectiveMatchers.swift
//  Cuckoo-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import Foundation

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAny<T: NSObject>() -> T {
    return TrustMe<T>.onThis(OCMArg.any() as Any)
}

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAny() -> String {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.any() as Any) as Any) as String
}

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAnyClosure<IN1, OUT>() -> (IN1) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1) -> OUT).self).pointee
}

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAnyClosure<IN1, IN2, OUT>() -> (IN1, IN2) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2) -> OUT).self).pointee
}

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAnyClosure<IN1, IN2, IN3, OUT>() -> (IN1, IN2, IN3) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3) -> OUT).self).pointee
}

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAnyClosure<IN1, IN2, IN3, IN4, OUT>() -> (IN1, IN2, IN3, IN4) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4) -> OUT).self).pointee
}

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAnyClosure<IN1, IN2, IN3, IN4, IN5, OUT>() -> (IN1, IN2, IN3, IN4, IN5) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5) -> OUT).self).pointee
}

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAnyClosure<IN1, IN2, IN3, IN4, IN5, IN6, OUT>() -> (IN1, IN2, IN3, IN4, IN5, IN6) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5, IN6) -> OUT).self).pointee
}

/// Used as an Objective-C matcher matching any Objective-C closure.
public func objcAnyClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>() -> (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT {
    let closure = TrustHim.onThis(OCMArg.check { a in return true } as Any)
    return closure.assumingMemoryBound(to: ((IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT).self).pointee
}

/// Used as an Objective-C matcher matching any nil value.
public func objcIsNil<T: NSObject>() -> T? {
    return TrustMe<T>.onThis(OCMArg.isNil() as Any)
}

/// Used as an Objective-C matcher matching any nil value.
public func objcIsNil() -> String? {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.isNil() as Any) as Any) as String
}

/// Used as an Objective-C matcher matching any non-nil value.
public func objcIsNotNil<T: NSObject>() -> T? {
    return TrustMe<T>.onThis(OCMArg.isNotNil() as Any)
}

/// Used as an Objective-C matcher matching any non-nil value.
public func objcIsNotNil() -> String? {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.isNotNil() as Any) as Any) as String
}

/// Used as an Objective-C equality matcher.
public func objcIsEqual<T: NSObject>(to object: T) -> T {
    return TrustMe<T>.onThis(OCMArg.isEqual(object) as Any)
}

/// Used as an Objective-C equality matcher.
public func objcIsEqual(to string: String) -> String {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.isEqual(string) as Any) as Any) as String
}

/// Used as an Objective-C inequality matcher.
public func objcIsNotEqual<T: NSObject>(to object: T) -> T? {
    return TrustMe<T>.onThis(OCMArg.isNotEqual(object) as Any)
}

/// Used as an Objective-C inequality matcher.
public func objcIsNotEqual(to string: String) -> String? {
    return TrustMe<NSString>.onThis(StringProxy(constraint: OCMArg.isNotEqual(string) as Any) as Any) as String
}
