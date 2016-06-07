//
//  FunctionMatcher.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct FunctionMatcher<T>: Matcher {
    private let matchesFunction: T -> Bool
    private let describeToFunction: Description -> Void
    private let describeMismatchFunction: ((T, to: Description) -> Void)?
    
    public init(original: T, function: (T, T) -> Bool, describeMismatch: ((T, to: Description) -> Void)? = nil, describeTo: Description -> Void) {
        self.init(function: { a in function(original, a) }, describeMismatch: describeMismatch, describeTo: describeTo)
    }
    
    public init(function: T -> Bool, describeMismatch: ((T, to: Description) -> Void)? = nil, describeTo: Description -> Void) {
        self.matchesFunction = function
        self.describeToFunction = describeTo
        self.describeMismatchFunction = describeMismatch
    }
    
    public func describeTo(description: Description) {
        describeToFunction(description)
    }
    
    public func describeMismatch(input: T, to description: Description) {
        if let describeMismatchFunction = describeMismatchFunction {
            describeMismatchFunction(input, to: description)
        } else {
            description.append(text: "was ").append(value: input)
        }
    }
    
    public func matches(input: T) -> Bool {
        return matchesFunction(input)
    }
}