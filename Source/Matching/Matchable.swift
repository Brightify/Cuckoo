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
        return equal(to: self)
    }
}

extension String: Matchable {
    public var matcher: ParameterMatcher<String> {
        return equal(to: self)
    }
}

extension Float: Matchable {
    public var matcher: ParameterMatcher<Float> {
        return equal(to: self)
    }
}

extension Double: Matchable {
    public var matcher: ParameterMatcher<Double> {
        return equal(to: self)
    }
}

extension Character: Matchable {
    public var matcher: ParameterMatcher<Character> {
        return equal(to: self)
    }
}

extension Int: Matchable {
    public var matcher: ParameterMatcher<Int> {
        return equal(to: self)
    }
}

extension Int8: Matchable {
    public var matcher: ParameterMatcher<Int8> {
        return equal(to: self)
    }
}

extension Int16: Matchable {
    public var matcher: ParameterMatcher<Int16> {
        return equal(to: self)
    }
}

extension Int32: Matchable {
    public var matcher: ParameterMatcher<Int32> {
        return equal(to: self)
    }
}

extension Int64: Matchable {
    public var matcher: ParameterMatcher<Int64> {
        return equal(to: self)
    }
}

extension UInt: Matchable {
    public var matcher: ParameterMatcher<UInt> {
        return equal(to: self)
    }
}

extension UInt8: Matchable {
    public var matcher: ParameterMatcher<UInt8> {
        return equal(to: self)
    }
}

extension UInt16: Matchable {
    public var matcher: ParameterMatcher<UInt16> {
        return equal(to: self)
    }
}

extension UInt32: Matchable {
    public var matcher: ParameterMatcher<UInt32> {
        return equal(to: self)
    }
}

extension UInt64: Matchable {
    public var matcher: ParameterMatcher<UInt64> {
        return equal(to: self)
    }
}
