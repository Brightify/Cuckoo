//
//  VerifyReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct VerifyReadOnlyProperty<T> {
    private let cuckoo_manager: MockManager
    private let name: String
    private let callMatcher: CallMatcher
    private let sourceLocation: SourceLocation
    
    public var get: __DoNotUse<T> {
        return cuckoo_manager.verify(getterName(name), callMatcher: callMatcher, parameterMatchers: [] as [ParameterMatcher<Void>], sourceLocation: sourceLocation)
    }
    
    public init(cuckoo_manager: MockManager, name: String, callMatcher: CallMatcher, sourceLocation: SourceLocation) {
        self.cuckoo_manager = cuckoo_manager
        self.name = name
        self.callMatcher = callMatcher
        self.sourceLocation = sourceLocation
    }
}
