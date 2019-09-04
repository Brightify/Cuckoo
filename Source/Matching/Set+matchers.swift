//
//  Set+matchers.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 04/09/2019.
//

extension Set: Matchable where Element: Matchable, Element == Element.MatchedType {
    public typealias MatchedType = Set<Element>

    public var matcher: ParameterMatcher<Set<Element>> {
        return ParameterMatcher<Set<Element>> { other in
            return self == other
        }
    }
}
