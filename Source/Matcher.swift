//
//  Matcher.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Matcher {
    typealias MatchedType
    
    /**
     Returns description for this matcher when applied to the given input.
     
     This is used to give user more information why the matcher did not match for example.
    */
    func describe(input: MatchedType) -> String
    
    /**
     Returns true if the input is matched by this matcher, false otherwise.
    */
    func matches(input: MatchedType) -> Bool
}

extension Matcher {
    func typeErased() -> AnyMatcher<MatchedType> {
        return AnyMatcher(self)
    }
}