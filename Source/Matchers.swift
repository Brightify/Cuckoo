//
//  Matchers.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct AnyMatcher<T>: Matcher {
    let targetType: Any.Type
    let describeToFunction: Description -> Void
    let describeMismatchFunction: (T, to: Description) throws -> Void
    let matchesFunction: T throws -> Bool
    
    init<M: Matcher>(_ wrapped: M) {
        self.targetType = M.MatchedType.self
        
        self.describeToFunction = wrapped.describeTo
        self.describeMismatchFunction = stripInputTypeInformation(M.MatchedType.self, from: wrapped.describeMismatch)
        self.matchesFunction = stripInputTypeInformation(wrapped.matches)
    }
    
    init() {
        self.targetType = T.self
        
        // Stubs to enable simple type matching
        self.describeToFunction = { _ in }
        self.describeMismatchFunction = { _ in }
        self.matchesFunction = { _ in true }
    }
    
    public func describeTo(description: Description) {
        describeToFunction(description)
    }
    
    public func describeMismatch(input: T, to description: Description) {
        do {
            return try describeMismatchFunction(input, to: description)
        } catch TypeStripingError.CalledWithIncorrectType {
            description.appendText("instance of").appendValue(targetType)
        } catch let error {
            description.appendText("Unknown error occured while matching: \(error)")
        }
    }
    
    public func matches(input: T) -> Bool {
        do {
            return try matchesFunction(input)
        } catch {
            return false
        }
    }
}

public struct FunctionMatcher<T>: Matcher {
    private let matchesFunction: T -> Bool
    private let describeToFunction: Description -> Void
    private let describeMismatchFunction: ((T, to: Description) -> Void)?
    
    public init(original: T, function: (T, T) -> Bool, describeMismatch: ((T, to: Description) -> Void)? = nil, describeTo: Description -> Void) {
        self.init(function: curry(function)(original), describeMismatch: describeMismatch, describeTo: describeTo)
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
            description.appendText("was ").appendValue(input)
        }
        
    }
    
    public func matches(input: T) -> Bool {
        return matchesFunction(input)
    }
}