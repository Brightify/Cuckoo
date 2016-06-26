//
//  StubAction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

enum StubAction<IN, OUT> {
    case CallImplementation(IN throws -> OUT)
    case ReturnValue(OUT)
    case ThrowError(ErrorType)
    case CallRealImplementation
}