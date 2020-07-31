//
//  __DoNotUse.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Marker struct for use as a return type in verification.
public struct __DoNotUse<IN, OUT> { }

public extension __DoNotUse {

    /// Hint at the return type when verifying a function where the function is generic
    /// and the type is inferred from the return value
    func with(returnType: OUT.Type) { }
}
