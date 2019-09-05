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


// MARK: Contains ANY of the elements.
public func containsAnyOf<T>(values elements: T..., where equality: @escaping (T, T) -> Bool) -> ParameterMatcher<[T]> {
    return containsAnyOf(elements, where: equality)
}
public func containsAnyOf<IN: Sequence, OUT: Sequence>(_ elements: IN, where equality: @escaping (IN.Element, IN.Element) -> Bool) -> ParameterMatcher<OUT> where IN.Element == OUT.Element {
    return ParameterMatcher { sequence in
        elements.contains { element in
            sequence.contains {
                equality($0, element)
            }
        }
    }
}

public func containsAnyOf<T: Equatable>(values elements: T...) -> ParameterMatcher<[T]> {
    return containsAnyOf(elements)
}
public func containsAnyOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Equatable, IN.Element == OUT.Element {
    return containsAnyOf(elements, where: ==)
}

public func containsAnyOf<T: Hashable>(values elements: T...) -> ParameterMatcher<[T]> {
    return containsAnyOf(elements)
}
public func containsAnyOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Hashable, IN.Element == OUT.Element {
    return ParameterMatcher { sequence in
        let set = Set(sequence)
        let elementsSet = Set(elements)
        return !set.isDisjoint(with: elementsSet)
    }
}


// MARK: Contains ALL of the elements.
public func containsAllOf<T>(values elements: T..., where equality: @escaping (T, T) -> Bool) -> ParameterMatcher<[T]> {
    return containsAllOf(elements, where: equality)
}
public func containsAllOf<IN: Sequence, OUT: Sequence>(_ elements: IN, where equality: @escaping (IN.Element, IN.Element) -> Bool) -> ParameterMatcher<OUT> where IN.Element == OUT.Element {
    return ParameterMatcher { sequence in
        elements.allSatisfy { element in
            sequence.contains {
                equality($0, element)
            }
        }
    }
}

public func containsAllOf<T: Equatable>(values elements: T...) -> ParameterMatcher<[T]> {
    return containsAllOf(elements)
}
public func containsAllOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Equatable, IN.Element == OUT.Element {
    return containsAllOf(elements, where: ==)
}

public func containsAllOf<T: Hashable>(values elements: T...) -> ParameterMatcher<[T]> {
    return containsAllOf(elements)
}
public func containsAllOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Hashable, IN.Element == OUT.Element {
    return ParameterMatcher { sequence in
        let set = Set(sequence)
        let elementsSet = Set(elements)
        return set.isSuperset(of: elementsSet)
    }
}


// MARK: Contains NONE of the elements.
public func containsNoneOf<T>(values elements: T..., where equality: @escaping (T, T) -> Bool) -> ParameterMatcher<[T]> {
    return containsNoneOf(elements, where: equality)
}
public func containsNoneOf<IN: Sequence, OUT: Sequence>(_ elements: IN, where equality: @escaping (IN.Element, IN.Element) -> Bool) -> ParameterMatcher<OUT> where IN.Element == OUT.Element {
    return not(containsAnyOf(elements, where: equality))
}

public func containsNoneOf<T: Equatable>(values elements: T...) -> ParameterMatcher<[T]> {
    return containsNoneOf(elements)
}
public func containsNoneOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Equatable, IN.Element == OUT.Element {
    return containsNoneOf(elements, where: ==)
}

public func containsNoneOf<T: Hashable>(values elements: T...) -> ParameterMatcher<[T]> {
    return containsNoneOf(elements)
}
public func containsNoneOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Hashable, IN.Element == OUT.Element {
    return not(containsAnyOf(elements))
}



// MARK: Has length N (exact, at least, at most).
public func hasLength<C: Collection>(exactly requiredExactLength: Int) -> ParameterMatcher<C> {
    return ParameterMatcher { collection in
        collection.count == requiredExactLength
    }
}

public func hasLength<C: Collection>(atLeast requiredMinimumLength: Int, inclusive: Bool = true) -> ParameterMatcher<C> {
    return ParameterMatcher { collection in
        collection.count > requiredMinimumLength || (inclusive && collection.count == requiredMinimumLength)
    }
}

public func hasLength<C: Collection>(atMost requiredMaximumLength: Int, inclusive: Bool = true) -> ParameterMatcher<C> {
    return ParameterMatcher { collection in
        collection.count < requiredMaximumLength || (inclusive && collection.count == requiredMaximumLength)
    }
}
