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
/**
 * Matcher for sequences of elements that checks if at least one of the passed elements matches the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsAnyOf<T, S: Sequence>(values elements: T..., where equality: @escaping (T, T) -> Bool) -> ParameterMatcher<S> where T == S.Element {
    return containsAnyOf(elements, where: equality)
}
/**
 * Matcher for sequences of elements that checks if at least one of the passed elements matches the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsAnyOf<IN: Sequence, OUT: Sequence>(_ elements: IN, where equality: @escaping (IN.Element, IN.Element) -> Bool) -> ParameterMatcher<OUT> where IN.Element == OUT.Element {
    return ParameterMatcher { sequence in
        elements.contains { element in
            sequence.contains {
                equality($0, element)
            }
        }
    }
}

/**
 * Matcher for sequences of `Equatable` elements that checks if at least one of the passed elements matches the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyOf<T: Equatable, S: Sequence>(values elements: T...) -> ParameterMatcher<S> where T == S.Element {
    return containsAnyOf(elements)
}
/**
 * Matcher for sequences of `Equatable` elements that checks if at least one of the passed elements matches the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Equatable, IN.Element == OUT.Element {
    return containsAnyOf(elements, where: ==)
}

/**
 * Matcher for sequences of `Hashable` elements that checks if at least one of the passed elements matches the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyOf<T: Hashable, S: Sequence>(values elements: T...) -> ParameterMatcher<S> where T == S.Element {
    return containsAnyOf(elements)
}
/**
 * Matcher for sequences of `Hashable` elements that checks if at least one of the passed elements matches the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Hashable, IN.Element == OUT.Element {
    return ParameterMatcher { sequence in
        let set = Set(sequence)
        let elementsSet = Set(elements)
        return !set.isDisjoint(with: elementsSet)
    }
}


// MARK: Contains ALL of the elements.
/**
 * Matcher for sequences of elements that checks if all of the passed elements match the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 * - NOTE: When matching an Array, this matcher expects items as many times as they are present in the passed elements.
 */
public func containsAllOf<T, S: Sequence>(values elements: T..., where equality: @escaping (T, T) -> Bool) -> ParameterMatcher<S> where T == S.Element {
    return containsAllOf(elements, where: equality)
}
/**
 * Matcher for sequences of elements that checks if all of the passed elements match the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 * - NOTE: When passing an Array, this matcher expects items as many times as they are present in the passed elements.
 */
public func containsAllOf<IN: Sequence, OUT: Sequence>(_ elements: IN, where equality: @escaping (IN.Element, IN.Element) -> Bool) -> ParameterMatcher<OUT> where IN.Element == OUT.Element {
    return ParameterMatcher { sequence in
        var matchedSequence = sequence.map { (element: $0, matched: false) }
        for element in elements {
            if let matchedIndex = matchedSequence.firstIndex(where: { !$0.matched && equality($0.element, element) }) {
                matchedSequence[matchedIndex].matched = true
            } else {
                return false
            }
        }
        return true
    }
}

/**
 * Matcher for sequences of `Equatable` elements that checks if all of the passed elements match the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - returns: ParameterMatcher object.
 * - NOTE: When passing an Array, this matcher expects items as many times as they are present in the passed elements.
 */
public func containsAllOf<T: Equatable, S: Sequence>(values elements: T...) -> ParameterMatcher<S> where T == S.Element {
    return containsAllOf(elements)
}
/**
 * Matcher for sequences of `Equatable` elements that checks if all of the passed elements match the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - returns: ParameterMatcher object.
 * - NOTE: When passing an Array, this matcher expects items as many times as they are present in the passed elements.
 */
public func containsAllOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Equatable, IN.Element == OUT.Element {
    return containsAllOf(elements, where: ==)
}

/**
 * Matcher for sequences of `Hashable` elements that checks if all of the passed elements match the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - returns: ParameterMatcher object.
 * - NOTE: When passing an Array, this matcher expects items as many times as they are present in the passed elements.
 */
public func containsAllOf<T: Hashable>(values elements: T...) -> ParameterMatcher<[T]> {
    return containsAllOf(elements)
}
/**
 * Matcher for sequences of `Hashable` elements that checks if all of the passed elements match the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - returns: ParameterMatcher object.
 * - NOTE: When passing an Array, this matcher expects items as many times as they are present in the passed elements.
 */
public func containsAllOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Hashable, IN.Element == OUT.Element {
    return ParameterMatcher { sequence in
        let sequenceDictionary: [IN.Element: Int] = sequence.reduce(into: [:]) { dictionary, element in
            dictionary[element, default: 0] += 1
        }
        let elementsDictionary: [IN.Element: Int] = elements.reduce(into: [:]) { dictionary, element in
            dictionary[element, default: 0] += 1
        }

        return elementsDictionary.allSatisfy { key, element in
            sequenceDictionary[key].map { $0 == element } ?? false
        }
    }
}
/**
 * Matcher for `Set`s of `Hashable` elements that checks if all of the passed elements match the passed `Set`.
 * - parameter elements: Elements that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAllOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Hashable, IN.Element == OUT.Element, IN: SetAlgebra {
    return ParameterMatcher { sequence in
        let set = Set(sequence)
        let elementsSet = Set(elements)
        return set.isSuperset(of: elementsSet)
    }
}


// MARK: Contains NONE of the elements.
/**
 * Matcher for sequences of elements that checks if none of the passed elements match the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoneOf<T, S: Sequence>(values elements: T..., where equality: @escaping (T, T) -> Bool) -> ParameterMatcher<S> where T == S.Element {
    return containsNoneOf(elements, where: equality)
}
/**
 * Matcher for sequences of elements that checks if none of the passed elements match the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoneOf<IN: Sequence, OUT: Sequence>(_ elements: IN, where equality: @escaping (IN.Element, IN.Element) -> Bool) -> ParameterMatcher<OUT> where IN.Element == OUT.Element {
    return not(containsAnyOf(elements, where: equality))
}

/**
 * Matcher for sequences of `Equatable` elements that checks if none of the passed elements match the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoneOf<T: Equatable, S: Sequence>(values elements: T...) -> ParameterMatcher<S> where T == S.Element {
    return containsNoneOf(elements)
}
/**
 * Matcher for sequences of `Equatable` elements that checks if none of the passed elements match the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoneOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Equatable, IN.Element == OUT.Element {
    return containsNoneOf(elements, where: ==)
}

/**
 * Matcher for sequences of `Hashable` elements that checks if none of the passed elements match the passed sequence.
 * - parameter values: Variadic elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoneOf<T: Hashable, S: Sequence>(values elements: T...) -> ParameterMatcher<S> where T == S.Element {
    return containsNoneOf(elements)
}
/**
 * Matcher for sequences of `Hashable` elements that checks if none of the passed elements match the passed sequence.
 * - parameter elements: Elements that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoneOf<IN: Sequence, OUT: Sequence>(_ elements: IN) -> ParameterMatcher<OUT> where IN.Element: Hashable, IN.Element == OUT.Element {
    return not(containsAnyOf(elements))
}


// MARK: Has length N (exact, at least, at most).
/**
 * Matcher for collections of elements that checks if the collection is exactly N elements long.
 * - parameter exactly: Required length of the matching collection.
 * - returns: ParameterMatcher object.
 */
public func hasLength<C: Collection>(exactly requiredExactLength: Int) -> ParameterMatcher<C> {
    return ParameterMatcher { collection in
        collection.count == requiredExactLength
    }
}

/**
 * Matcher for collections of elements that checks if the collection is at least N elements long with the option to include the number itself (default).
 * - parameter atLeast: Required minimum length of the matching collection.
 * - parameter inclusive: Whether the minimum length itself should be included.
 * - returns: ParameterMatcher object.
 */
public func hasLength<C: Collection>(atLeast requiredMinimumLength: Int, inclusive: Bool = true) -> ParameterMatcher<C> {
    return ParameterMatcher { collection in
        collection.count > requiredMinimumLength || (inclusive && collection.count == requiredMinimumLength)
    }
}

/**
 * Matcher for collections of elements that checks if the collection is at most N elements long with the option to include the number itself (default).
 * - parameter atMost: Required maximum length of the matching collection.
 * - parameter inclusive: Whether the maximum length itself should be included.
 * - returns: ParameterMatcher object.
 */
public func hasLength<C: Collection>(atMost requiredMaximumLength: Int, inclusive: Bool = true) -> ParameterMatcher<C> {
    return ParameterMatcher { collection in
        collection.count < requiredMaximumLength || (inclusive && collection.count == requiredMaximumLength)
    }
}

/**
 * Matcher for collections of elements that checks if the collection is at between N and M elements long with the option to include the bounds as well (default).
 * - parameter inRange: Required length range of the matching collection.
 * - parameter inclusive: Whether the length range bounds should be included.
 * - returns: ParameterMatcher object.
 */
public func hasLength<C: Collection>(inRange requiredLengthRange: CountableRange<Int>, inclusive: Bool = true) -> ParameterMatcher<C> {
    return hasLength(atLeast: requiredLengthRange.lowerBound, inclusive: inclusive)
        .and(hasLength(atMost: requiredLengthRange.upperBound, inclusive: inclusive))
}
