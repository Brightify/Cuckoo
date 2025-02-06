extension Set: Matchable where Element: Matchable, Element == Element.MatchedType {
    public typealias MatchedType = Set<Element>

    public var matcher: ParameterMatcher<Set<Element>> {
        ParameterMatcher<Set<Element>> { other in
            self == other
        }
    }
}
