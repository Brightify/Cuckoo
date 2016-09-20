//
//  VerifyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct VerifyProperty<T> {
    private let manager: MockManager
    private let name: String
    private let callMatcher: CallMatcher
    private let sourceLocation: SourceLocation
    
    public var get: __DoNotUse<T> {
        return manager.verify(getterName(name), callMatcher: callMatcher, parameterMatchers: [] as [ParameterMatcher<Void>], sourceLocation: sourceLocation)
    }
    
    @discardableResult
    public func set<M: Matchable>(_ matcher: M) -> __DoNotUse<Void> where M.MatchedType == T {
        return manager.verify(setterName(name), callMatcher: callMatcher, parameterMatchers: [matcher.matcher], sourceLocation: sourceLocation)
    }
    
    public init(manager: MockManager, name: String, callMatcher: CallMatcher, sourceLocation: SourceLocation) {
        self.manager = manager
        self.name = name
        self.callMatcher = callMatcher
        self.sourceLocation = sourceLocation
    }
}
