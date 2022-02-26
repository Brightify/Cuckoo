extension Set: Matchable where Element: Matchable, Element == Element.MatchedType {
    public typealias MatchedType = Set<Element>

    public var matcher: ParameterMatcher<Set<Element>> {
        return ParameterMatcher<Set<Element>> { other in
            return self == other
        }
    }
}
