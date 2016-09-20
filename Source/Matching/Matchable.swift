//
//  Matchable.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/**
    Matchable can be anything that can produce its own parameter matcher.
    It is used instead of concrete value for stubbing and verification.
*/
public protocol Matchable {
    associatedtype MatchedType
    
    /// Matcher for this instance. This should be an equalTo type of a matcher, but it is not required.
    var matcher: ParameterMatcher<MatchedType> { get }
}

public extension Matchable {
    public func or<M>(_ otherMatchable: M) -> ParameterMatcher<MatchedType> where M: Matchable, M.MatchedType == MatchedType {
        return ParameterMatcher {
            return self.matcher.matches($0) || otherMatchable.matcher.matches($0)
        }
    }
    
    public func and<M>(_ otherMatchable: M) -> ParameterMatcher<MatchedType> where M: Matchable, M.MatchedType == MatchedType {
        return ParameterMatcher {
            return self.matcher.matches($0) && otherMatchable.matcher.matches($0)
        }
    }
}

extension Bool: Matchable {
    public var matcher: ParameterMatcher<Bool> {
        return equalTo(self)
    }
}

extension Int: Matchable {
    public var matcher: ParameterMatcher<Int> {
        return equalTo(self)
    }
}

extension String: Matchable {
    public var matcher: ParameterMatcher<String> {
        return equalTo(self)
    }
}

extension Float: Matchable {
    public var matcher: ParameterMatcher<Float> {
        return equalTo(self)
    }
}

extension Double: Matchable {
    public var matcher: ParameterMatcher<Double> {
        return equalTo(self)
    }
}

extension Character: Matchable {
    public var matcher: ParameterMatcher<Character> {
        return equalTo(self)
    }
}
