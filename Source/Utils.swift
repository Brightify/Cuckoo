//
//  Utils.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

internal func curry<A>(function: A -> ())(_ a: A)() {
    function(a)
}

internal func curry<A, B>(function: A -> B)(_ a: A) -> B {
    return function(a)
}

internal func curry<A, B, C>(function: (A, B) -> C)(_ a: A)(_ b: B) -> C {
    return function(a, b)
}

internal func curry<A, B, C, D>(function: (A, B, C) -> D)(_ a: A)(_ b: B)(_ c: C) -> D {
    return function(a, b, c)
}

internal func curry<A, B, C, D, E>(function: (A, B, C, D) -> E)(_ a: A)(_ b: B)(_ c: C)(_ d: D) -> E {
    return function(a, b, c, d)
}

internal func curry<A, B, C, D, E, F>(function: (A, B, C, D, E) -> F)(_ a: A)(_ b: B)(_ c: C)(_ d: D)(_ e: E) -> F {
    return function(a, b, c, d, e)
}

enum TypeStripingError: ErrorType {
    case CalledWithIncorrectType
}

internal func stripInputTypeInformation<IN_A, IN_B, OUT>(stripType: IN_A.Type, from function: (IN_A, IN_B) -> OUT)(_ inputA: Any, _ inputB: IN_B) throws -> OUT {
    guard let castInputA = inputA as? IN_A else {
        throw TypeStripingError.CalledWithIncorrectType
    }
    return function(castInputA, inputB)
}

internal func stripInputTypeInformation<IN, OUT>(function: IN -> OUT)(_ input: Any) throws -> OUT {
    return try stripInputTypeInformation(IN.self, from: function)(input)
}

internal func stripInputTypeInformation<IN, OUT>(inputType: IN.Type, from function: IN -> OUT)(_ input: Any) throws -> OUT {
    guard let castInput = input as? IN else {
        throw TypeStripingError.CalledWithIncorrectType
    }
    return function(castInput)
}

public func markerFunction<IN, OUT>(input: IN.Type = IN.self, _ output: OUT.Type = OUT.self) -> IN -> OUT {
    return { _ in
        assert(false, "Marker function cannot be called")
        // Will never be called, but Swift cannot infer the type without it
        return OUT.self as! OUT
    }
}

public struct SourceLocation {
    let file: String
    let line: UInt
}