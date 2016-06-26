//
//  OnStubCall.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

enum OnStubCall {
    case ReturnValue(Any)
    case ThrowError(ErrorType)
    case CallRealImplementation
}