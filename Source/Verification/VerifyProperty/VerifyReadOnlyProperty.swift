//
//  VerifyReadOnlyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct VerifyReadOnlyProperty<T> {
    private let manager: MockManager
    private let name: String
    private let callMatcher: CallMatcher
    private let continuation: Continuation
    private let sourceLocation: SourceLocation

    @discardableResult
    public func get() -> __DoNotUse<Void, T> {
        return manager.verify(getterName(name), callMatcher: callMatcher, parameterMatchers: [] as [ParameterMatcher<Void>], continuation: continuation, sourceLocation: sourceLocation)
    }
    
    public init(manager: MockManager, name: String, callMatcher: CallMatcher, continuation: Continuation, sourceLocation: SourceLocation) {
        self.manager = manager
        self.name = name
        self.callMatcher = callMatcher
        self.continuation = continuation
        self.sourceLocation = sourceLocation
    }
}
