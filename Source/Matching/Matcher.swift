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
    
    public func describeMismatch(input: MatchedType, to description: Description) {
        description.append(text: "was ").append(value: input)
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
            $0.append(text: "either ").append(descriptionOf: self).append(text: " or ").append(descriptionOf: otherMatcher)
        }
        
        return FunctionMatcher(function: function, describeTo: description).typeErased()
    }
    
    public func and(otherMatcher: AnyMatcher<MatchedType>) -> AnyMatcher<MatchedType> {
        let function: MatchedType -> Bool = {
            return self.matches($0) && otherMatcher.matches($0)
        }
        let description: Description -> Void = {
            $0.append(text: "both ").append(descriptionOf: self).append(text: " and ").append(descriptionOf: otherMatcher)
        }
        
        return FunctionMatcher(function: function, describeTo: description).typeErased()
    }
    
}