//
//  AnyMatcher.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
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
            description.append(text: "instance of").append(value: targetType)
        } catch let error {
            description.append(text: "Unknown error occured while matching: \(error)")
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

public typealias CallMatcher = AnyMatcher<[StubCall]>

enum TypeStripingError: ErrorType {
    case CalledWithIncorrectType
}

private func stripInputTypeInformation<IN, OUT>(function: IN -> OUT) -> Any throws -> OUT {
    return { input in
        guard let castInput = input as? IN else {
            throw TypeStripingError.CalledWithIncorrectType
        }
        return function(castInput)
    }
}

private func stripInputTypeInformation<IN_A, IN_B, OUT>(stripType: IN_A.Type, from function: (IN_A, IN_B) -> OUT) -> (Any, IN_B) throws -> OUT {
    return { inputA, inputB in
        guard let castInputA = inputA as? IN_A else {
            throw TypeStripingError.CalledWithIncorrectType
        }
        return function(castInputA, inputB)
    }
}
