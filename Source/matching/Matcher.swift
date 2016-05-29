//
//  Matcher.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Matcher: SelfDescribing, Matchable {
    associatedtype MatchedType
    
    /**
     Describes the mismatch to the given description.
    */
    func describeMismatch(input: MatchedType, to description: Description)
    
    /**
     Returns true if the input is matched by this matcher, false otherwise.
    */
    func matches(input: MatchedType) -> Bool
}

extension Matcher {
    public var matcher: AnyMatcher<MatchedType> {
        return typeErased()
    }
}

extension Matcher {
    public func typeErased() -> AnyMatcher<MatchedType> {
        return AnyMatcher(self)
    }
    
    public func or(otherMatcher: AnyMatcher<MatchedType>) -> AnyMatcher<MatchedType> {
        let function: MatchedType -> Bool = {
            return self.matches($0) || otherMatcher.matches($0)
        }
        let description: Description -> Void = {
            $0.append("either", self, "or", otherMatcher)
        }
        
        return FunctionMatcher(function: function, describeTo: description).typeErased()
    }
    
    public func and(otherMatcher: AnyMatcher<MatchedType>) -> AnyMatcher<MatchedType> {
        let function: MatchedType -> Bool = {
            return self.matches($0) && otherMatcher.matches($0)
        }
        let description: Description -> Void = {
            $0.append("both", self, "and", otherMatcher)
        }
        
        return FunctionMatcher(function: function, describeTo: description).typeErased()
    }
    
}