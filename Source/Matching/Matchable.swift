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

    var optionalMatcher: ParameterMatcher<MatchedType?> { get }
}

public extension Matchable {
    func or<M>(_ otherMatchable: M) -> ParameterMatcher<MatchedType> where M: Matchable, M.MatchedType == MatchedType {
        return ParameterMatcher {
            return self.matcher.matches($0) || otherMatchable.matcher.matches($0)
        }
    }
    
    func and<M>(_ otherMatchable: M) -> ParameterMatcher<MatchedType> where M: Matchable, M.MatchedType == MatchedType {
        return ParameterMatcher {
            return self.matcher.matches($0) && otherMatchable.matcher.matches($0)
        }
    }
}

extension Optional: Matchable where Wrapped: Matchable, Wrapped.MatchedType == Wrapped {
    public typealias MatchedType = Wrapped?

    public var matcher: ParameterMatcher<Wrapped?> {
        return ParameterMatcher<Wrapped?> { other in
            switch (self, other) {
            case (.none, .none):
                return true
            case (.some(let lhs), .some(let rhs)):
                return lhs.matcher.matches(rhs)
            default:
                return false
            }
        }
    }
}

extension Matchable where Self == MatchedType {
    public var optionalMatcher: ParameterMatcher<MatchedType?> {
        return Optional(self).matcher
    }
}

extension Matchable where Self: Equatable {
    public var matcher: ParameterMatcher<Self> {
        return equal(to: self)
    }
}

extension Bool: Matchable {}

extension String: Matchable {}

extension Float: Matchable {}

extension Double: Matchable {}

extension Character: Matchable {}

extension Int: Matchable {}

extension Int8: Matchable {}

extension Int16: Matchable {}

extension Int32: Matchable {}

extension Int64: Matchable {}

extension UInt: Matchable {}

extension UInt8: Matchable {}

extension UInt16: Matchable {}

extension UInt32: Matchable {}

extension UInt64: Matchable {}
