//
//  VerifyProperty.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct VerifyProperty<T> {
    private let cuckoo_manager: MockManager
    private let name: String
    private let callMatcher: CallMatcher
    private let sourceLocation: SourceLocation
    
    public var get: __DoNotUse<T> {
        return cuckoo_manager.verify(getterName(name), callMatcher: callMatcher, parameterMatchers: [] as [ParameterMatcher<Void>], sourceLocation: sourceLocation)
    }
    
    @discardableResult
    public func set<M: Matchable>(_ matcher: M) -> __DoNotUse<Void> where M.MatchedType == T {
        return cuckoo_manager.verify(setterName(name), callMatcher: callMatcher, parameterMatchers: [matcher.matcher], sourceLocation: sourceLocation)
    }
    
    public init(cuckoo_manager: MockManager, name: String, callMatcher: CallMatcher, sourceLocation: SourceLocation) {
        self.cuckoo_manager = cuckoo_manager
        self.name = name
        self.callMatcher = callMatcher
        self.sourceLocation = sourceLocation
    }
}
