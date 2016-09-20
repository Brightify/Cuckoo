//
//  StubAction.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

enum StubAction<IN, OUT> {
    case callImplementation((IN) throws -> OUT)
    case returnValue(OUT)
    case throwError(Error)
    case callRealImplementation
}
