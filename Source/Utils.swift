//
//  Utils.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

internal func curry<A>(function: A -> ()) -> A -> () {
    return { a in function(a) }
}

internal func curry<A, B>(function: A -> B) -> A -> B {
    return { a in function(a) }
}

internal func curry<A, B, C>(function: (A, B) -> C) -> A -> B -> C {
    return { a in { b in function(a, b) } }
}

internal func curry<A, B, C, D>(function: (A, B, C) -> D) -> A -> B -> C -> D {
    return { a in { b in { c in function(a, b, c) } } }
}

internal func curry<A, B, C, D, E>(function: (A, B, C, D) -> E) -> A -> B -> C -> D -> E {
    return { a in { b in { c in { d in function(a, b, c, d) } } } }
}

internal func curry<A, B, C, D, E, F>(function: (A, B, C, D, E) -> F) -> A -> B -> C -> D -> E -> F {
    return { a in { b in { c in { d in { e in function(a, b, c, d, e) } } } } }
}

enum TypeStripingError: ErrorType {
    case CalledWithIncorrectType
}

internal func stripInputTypeInformation<IN_A, IN_B, OUT>(stripType: IN_A.Type, from function: (IN_A, IN_B) -> OUT) -> (Any, IN_B) throws -> OUT {
    return { inputA, inputB in
        guard let castInputA = inputA as? IN_A else {
            throw TypeStripingError.CalledWithIncorrectType
        }
        return function(castInputA, inputB)
    }
}

internal func stripInputTypeInformation<IN, OUT>(function: IN -> OUT) -> Any throws -> OUT {
    return { input in
        return try stripInputTypeInformation(IN.self, from: function)(input)
    }
}

internal func stripInputTypeInformation<IN, OUT>(inputType: IN.Type, from function: IN -> OUT) -> Any throws -> OUT {
    return { input in
        guard let castInput = input as? IN else {
            throw TypeStripingError.CalledWithIncorrectType
        }
        return function(castInput)
    }
}

public func typed<OWNER, IN, OUT>(function: OWNER -> IN -> OUT) -> IN -> IN {
    return { $0 }
}

public func markerFunction<IN, OUT>(input: IN.Type = IN.self, _ output: OUT.Type = OUT.self) -> IN -> OUT {
    return { _ in
        assert(false, "Marker function cannot be called")
        // Will never be called, but Swift cannot infer the type without it
        return OUT.self as! OUT
    }
}

public struct SourceLocation {
    let file: StaticString
    let line: UInt
}