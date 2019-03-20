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

public protocol OptionalMatchable {
    associatedtype OptionalMatchedType

    var optionalMatcher: ParameterMatcher<OptionalMatchedType?> { get }
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

extension Optional: OptionalMatchable where Wrapped: OptionalMatchable, Wrapped.OptionalMatchedType == Wrapped {
    public typealias OptionalMatchedType = Wrapped

    public var optionalMatcher: ParameterMatcher<Wrapped?> {
        return ParameterMatcher<Wrapped?> { other in
            switch (self, other) {
            case (.none, .none):
                return true
            case (.some(let lhs), .some(let rhs)):
                return lhs.optionalMatcher.matches(rhs)
            default:
                return false
            }
        }
    }
}

extension Matchable where Self: Equatable {
    public var matcher: ParameterMatcher<Self> {
        return equal(to: self)
    }
}

extension OptionalMatchable where OptionalMatchedType == Self, Self: Equatable {
    public var optionalMatcher: ParameterMatcher<OptionalMatchedType?> {
        return ParameterMatcher { other in
            return Optional(self) == other
        }
    }
}

extension Bool: Matchable {}
extension Bool: OptionalMatchable {
    public typealias OptionalMatchedType = Bool
}

extension String: Matchable {}
extension String: OptionalMatchable {
    public typealias OptionalMatchedType = String
}

extension Float: Matchable {}
extension Float: OptionalMatchable {
    public typealias OptionalMatchedType = Float
}

extension Double: Matchable {}
extension Double: OptionalMatchable {
    public typealias OptionalMatchedType = Double
}

extension Character: Matchable {}
extension Character: OptionalMatchable {
    public typealias OptionalMatchedType = Character
}

extension Int: Matchable {}
extension Int: OptionalMatchable {
    public typealias OptionalMatchedType = Int
}

extension Int8: Matchable {}
extension Int8: OptionalMatchable {
    public typealias OptionalMatchedType = Int8
}

extension Int16: Matchable {}
extension Int16: OptionalMatchable {
    public typealias OptionalMatchedType = Int16
}

extension Int32: Matchable {}
extension Int32: OptionalMatchable {
    public typealias OptionalMatchedType = Int32
}

extension Int64: Matchable {}
extension Int64: OptionalMatchable {
    public typealias OptionalMatchedType = Int64
}

extension UInt: Matchable {}
extension UInt: OptionalMatchable {
    public typealias OptionalMatchedType = UInt
}

extension UInt8: Matchable {}
extension UInt8: OptionalMatchable {
    public typealias OptionalMatchedType = UInt8
}

extension UInt16: Matchable {}
extension UInt16: OptionalMatchable {
    public typealias OptionalMatchedType = UInt16
}

extension UInt32: Matchable {}
extension UInt32: OptionalMatchable {
    public typealias OptionalMatchedType = UInt32
}

extension UInt64: Matchable {}
extension UInt64: OptionalMatchable {
    public typealias OptionalMatchedType = UInt64
}
