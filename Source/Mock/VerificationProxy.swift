//
//  VerificationProxy.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol VerificationProxy {
    init(manager: MockManager, callMatcher: CallMatcher, sourceLocation: SourceLocation)
}
