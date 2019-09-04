//
//  Dictionary+matchers.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 04/09/2019.
//

extension Dictionary: Matchable where Value: Matchable, Value == Value.MatchedType {
    public typealias MatchedType = [Key: Value]

    public var matcher: ParameterMatcher<[Key: Value]> {
        return ParameterMatcher<[Key: Value]> { other in
            guard self.count == other.count else { return false }
            return self.allSatisfy {
                guard let foundElement = other[$0.key] else { return false }
                return $0.value.matcher.matches(foundElement)
            }
        }
    }
}
