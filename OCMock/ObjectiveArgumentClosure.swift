//
//  ObjectiveArgumentClosure.swift
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import Foundation

// MARK: Closures without any return value
public func objectiveArgumentClosure<IN1>(from: Any) -> (IN1) -> Void {
    return { in1 in
        var arg = from
        let block = UnsafeRawPointer(&arg).assumingMemoryBound(to: (@convention(block) (NSObject) -> Void).self).pointee

        let nsIn1 = TrustMe<NSObject>.onThis(in1)

        block(nsIn1)
    }
}

public func objectiveArgumentClosure<IN1, IN2>(from: Any) -> (IN1, IN2) -> Void {
    return { in1, in2 in
        var arg = from
        let block = UnsafeRawPointer(&arg).assumingMemoryBound(to: (@convention(block) (NSObject, NSObject) -> Void).self).pointee

        let nsIn1 = TrustMe<NSObject>.onThis(in1)
        let nsIn2 = TrustMe<NSObject>.onThis(in2)

        block(nsIn1, nsIn2)
    }
}

public func objectiveArgumentClosure<IN1, IN2, IN3>(from: Any) -> (IN1, IN2, IN3) -> Void {
    return { in1, in2, in3 in
        var arg = from
        let block = UnsafeRawPointer(&arg).assumingMemoryBound(to: (@convention(block) (NSObject, NSObject, NSObject) -> Void).self).pointee

        let nsIn1 = TrustMe<NSObject>.onThis(in1)
        let nsIn2 = TrustMe<NSObject>.onThis(in2)
        let nsIn3 = TrustMe<NSObject>.onThis(in3)

        block(nsIn1, nsIn2, nsIn3)
    }
}

public func objectiveArgumentClosure<IN1, IN2, IN3, IN4>(from: Any) -> (IN1, IN2, IN3, IN4) -> Void {
    return { in1, in2, in3, in4 in
        var arg = from
        let block = UnsafeRawPointer(&arg).assumingMemoryBound(to: (@convention(block) (NSObject, NSObject, NSObject, NSObject) -> Void).self).pointee

        block(
            TrustMe<NSObject>.onThis(in1),
            TrustMe<NSObject>.onThis(in2),
            TrustMe<NSObject>.onThis(in3),
            TrustMe<NSObject>.onThis(in4))
    }
}

public func objectiveArgumentClosure<IN1, IN2, IN3, IN4, IN5>(from: Any) -> (IN1, IN2, IN3, IN4, IN5) -> Void {
    return { in1, in2, in3, in4, in5 in
        var arg = from
        let block = UnsafeRawPointer(&arg).assumingMemoryBound(to: (@convention(block) (NSObject, NSObject, NSObject, NSObject, NSObject) -> Void).self).pointee

        block(
            TrustMe<NSObject>.onThis(in1),
            TrustMe<NSObject>.onThis(in2),
            TrustMe<NSObject>.onThis(in3),
            TrustMe<NSObject>.onThis(in4),
            TrustMe<NSObject>.onThis(in5)
        )
    }
}

public func objectiveArgumentClosure<IN1, IN2, IN3, IN4, IN5, IN6>(from: Any) -> (IN1, IN2, IN3, IN4, IN5, IN6) -> Void {
    return { in1, in2, in3, in4, in5, in6 in
        var arg = from
        let block = UnsafeRawPointer(&arg).assumingMemoryBound(to: (@convention(block) (NSObject, NSObject, NSObject, NSObject, NSObject, NSObject) -> Void).self).pointee

        block(
            TrustMe<NSObject>.onThis(in1),
            TrustMe<NSObject>.onThis(in2),
            TrustMe<NSObject>.onThis(in3),
            TrustMe<NSObject>.onThis(in4),
            TrustMe<NSObject>.onThis(in5),
            TrustMe<NSObject>.onThis(in6)
        )
    }
}

public func objectiveArgumentClosure<IN1, IN2, IN3, IN4, IN5, IN6, IN7>(from: Any) -> (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> Void {
    return { in1, in2, in3, in4, in5, in6, in7 in
        var arg = from
        let block = UnsafeRawPointer(&arg).assumingMemoryBound(to: (@convention(block) (NSObject, NSObject, NSObject, NSObject, NSObject, NSObject, NSObject) -> Void).self).pointee

        block(
            TrustMe<NSObject>.onThis(in1),
            TrustMe<NSObject>.onThis(in2),
            TrustMe<NSObject>.onThis(in3),
            TrustMe<NSObject>.onThis(in4),
            TrustMe<NSObject>.onThis(in5),
            TrustMe<NSObject>.onThis(in6),
            TrustMe<NSObject>.onThis(in7)
        )
    }
}
