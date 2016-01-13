//
//  Matchers.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

// Heavy type erasure in this class. Might be very dangerous!
public struct AnyMatcher<T>: Matcher {
    let targetType: Any.Type
    let describeFunction: T throws -> String
    let matchesFunction: T throws -> Bool
    
    init<M: Matcher>(_ wrapped: M) {
        self.targetType = M.MatchedType.self
        self.describeFunction = stripInputTypeInformation(wrapped.describe)
        self.matchesFunction = stripInputTypeInformation(wrapped.matches)
    }
    
    init() {
        self.targetType = T.self
        
        // Stubs to enable simple type matching
        self.describeFunction = stripInputTypeInformation(T.self, from: { _ in "" })
        self.matchesFunction = stripInputTypeInformation(T.self, from: { _ in true })
    }
    
    public func describe(input: T) -> String {
        do {
            return try describeFunction(input)
        } catch TypeStripingError.CalledWithIncorrectType {
            return "expected instance of <\(targetType)> got <\(input.dynamicType.self)>"
        } catch let error {
            return "Unknown error occured while matching: \(error)"
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
    private let function: T -> Bool
    private let description: T -> String
    
    public init(original: T, function: (T, T) -> Bool, description: (T, T) -> String) {
        self.function = curry(function)(original)
        self.description = curry(description)(original)
    }
    
    public init(function: T -> Bool, description: T -> String) {
        self.function = function
        self.description = description
    }
    
    public func describe(input: T) -> String {
        return description(input)
    }
    
    public func matches(input: T) -> Bool {
        return function(input)
    }
}