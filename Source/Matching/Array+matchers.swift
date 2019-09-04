//
//  Array+matchers.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 04/09/2019.
//

extension Array: Matchable where Element: Matchable, Element == Element.MatchedType {
    public typealias MatchedType = [Element]

    public var matcher: ParameterMatcher<[Element]> {
        return ParameterMatcher<[Element]> { other in
            guard self.count == other.count else { return false }
            return zip(self, other).allSatisfy { $0.matcher.matches($1) }
        }
    }
}
