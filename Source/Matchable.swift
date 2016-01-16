//
//  Matchable.swift
//  Mockery
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Matchable {
    typealias MatchedType
    
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