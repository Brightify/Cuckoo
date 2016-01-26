//
//  Matchable.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/**
    Matchable can be anything that can produce its own matcher.
    It is used instead of concrete value for stubbing and verification.
*/
public protocol Matchable {
    typealias MatchedType
    
    /// Matcher for this instance. This should be an equalTo type of a matcher, but it is not required.
    var matcher: AnyMatcher<MatchedType> { get }
}

extension Bool: Matchable {
    public var matcher: AnyMatcher<Bool> {
        return equalTo(self)
    }
}

extension Int: Matchable {
    public var matcher: AnyMatcher<Int> {
        return equalTo(self)
    }
}

extension String: Matchable {
    public var matcher: AnyMatcher<String> {
        return equalTo(self)
    }
}

extension Float: Matchable {
    public var matcher: AnyMatcher<Float> {
        return equalTo(self)
    }
}

extension Double: Matchable {
    public var matcher: AnyMatcher<Double> {
        return equalTo(self)
    }
}

extension Character: Matchable {
    public var matcher: AnyMatcher<Character> {
        return equalTo(self)
    }
}