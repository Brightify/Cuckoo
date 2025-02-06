extension Dictionary: Matchable where Value: Matchable, Value == Value.MatchedType {
    public typealias MatchedType = [Key: Value]

    public var matcher: ParameterMatcher<[Key: Value]> {
        ParameterMatcher<[Key: Value]> { other in
            guard self.count == other.count else { return false }
            return self.allSatisfy {
                guard let foundElement = other[$0.key] else { return false }
                return $0.value.matcher.matches(foundElement)
            }
        }
    }
}

// MARK: PAIR MATCHING
// MARK: - Contains ANY of the elements as key-value pairs.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the key-value pairs from the passed dictionary.
 * - parameter inputDictionary: Dictionary that is used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyOf<K, V: Equatable>(_ inputDictionary: [K: V]) -> ParameterMatcher<[K: V]> {
    containsAnyOf(inputDictionary, where: ==)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the key-value pairs from the passed dictionary.
 * - parameter inputDictionary: Dictionary that is used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsAnyOf<K, V>(
    _ inputDictionary: [K: V],
    where equality: @escaping (V, V) -> Bool
) -> ParameterMatcher<[K: V]> {
    ParameterMatcher { dictionary in
        inputDictionary.contains { key, value in
            dictionary[key].map { equality($0, value) } ?? false
        }
    }
}

// MARK: - Contains ALL of the elements as key-value pairs.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the key-value pairs from the passed dictionary.
 * - parameter inputDictionary: Dictionary that is used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAllOf<K, V: Equatable>(_ inputDictionary: [K: V]) -> ParameterMatcher<[K: V]> {
    containsAllOf(inputDictionary, where: ==)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the key-value pairs from the passed dictionary.
 * - parameter inputDictionary: Dictionary that is used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsAllOf<K, V>(_ inputDictionary: [K: V], where equality: @escaping (V, V) -> Bool) -> ParameterMatcher<[K: V]> {
    ParameterMatcher { dictionary in
        inputDictionary.allSatisfy { key, value in
            dictionary[key].map { equality($0, value) } ?? false
        }
    }
}

// MARK: - Contains NONE of the elements as key-value pairs.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the key-value pairs from the passed dictionary.
 * - parameter inputDictionary: Dictionary that is used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsNoneOf<K, V: Equatable>(_ inputDictionary: [K: V]) -> ParameterMatcher<[K: V]> {
    containsNoneOf(inputDictionary, where: ==)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the key-value pairs from the passed dictionary.
 * - parameter inputDictionary: Dictionary that is used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoneOf<K, V>(
    _ inputDictionary: [K: V],
    where equality: @escaping (V, V) -> Bool
) -> ParameterMatcher<[K: V]> {
    not(containsAnyOf(inputDictionary, where: equality))
}


// MARK: KEYS MATCHING
// MARK: - Contains ANY of the elements as keys.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the passed keys.
 * - parameter values: Variadic keys that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyKeysOf<K, V>(values elements: K...) -> ParameterMatcher<[K: V]> {
    containsAnyKeysOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the passed keys.
 * - parameter elements: Keys that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyKeysOf<S: Sequence, V>(_ elements: S) -> ParameterMatcher<[S.Element: V]> {
    ParameterMatcher { dictionary in
        containsAnyOf(elements).matches(dictionary.keys)
    }
}

// MARK: - Contains ALL of the elements as keys.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the passed keys.
 * - parameter values: Variadic keys that are used for matching
 * - returns: ParameterMatcher object.
 */
public func containsAllKeysOf<K, V>(values elements: K...) -> ParameterMatcher<[K: V]> {
    containsAllKeysOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the passed keys.
 * - parameter elements: Keys that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAllKeysOf<S: Sequence, V>(_ elements: S) -> ParameterMatcher<[S.Element: V]> {
    ParameterMatcher { dictionary in
        containsAllOf(elements).matches(dictionary.keys)
    }
}

// MARK: - Contains NONE of the elements as keys.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed keys.
 * - parameter values: Variadic keys that are used for matching
 * - returns: ParameterMatcher object.
 */
public func containsNoKeysOf<K, V>(values elements: K...) -> ParameterMatcher<[K: V]> {
    containsNoKeysOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed keys.
 * - parameter elements: Keys that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsNoKeysOf<S: Sequence, V>(_ elements: S) -> ParameterMatcher<[S.Element: V]> {
    not(containsAnyKeysOf(elements))
}


// MARK: VALUES MATCHING
// MARK: - Contains ANY of the elements as values.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the passed values.
 * - parameter values: Variadic values that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsAnyValuesOf<K, V>(
    values elements: V...,
    where equality: @escaping (V, V) -> Bool
) -> ParameterMatcher<[K: V]> {
    containsAnyValuesOf(elements, where: equality)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the passed values.
 * - parameter elements: Values that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsAnyValuesOf<K, S: Sequence>(
    _ elements: S,
    where equality: @escaping (S.Element, S.Element) -> Bool
) -> ParameterMatcher<[K: S.Element]> {
    ParameterMatcher { dictionary in
        containsAnyOf(elements, where: equality).matches(dictionary.values)
    }
}

/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the passed values.
 * - parameter values: Variadic keys that are used for matching
 * - returns: ParameterMatcher object.
 */
public func containsAnyValuesOf<K, V: Equatable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    return containsAnyValuesOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the passed values.
 * - parameter elements: Keys that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyValuesOf<K, S: Sequence>(
    _ elements: S
) -> ParameterMatcher<[K: S.Element]> where S.Element: Equatable {
    containsAnyValuesOf(elements, where: ==)
}


/**
 * Matcher for dictionaries that checks if the matching dictionary contains any of the passed values.
 * - parameter values: Variadic values that are used for matching
 * - returns: ParameterMatcher object.
 */
public func containsAnyValuesOf<K, V: Hashable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    containsAnyValuesOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed values.
 * - parameter elements: Values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAnyValuesOf<K, S: Sequence>(
    _ elements: S
) -> ParameterMatcher<[K: S.Element]> where S.Element: Hashable {
    ParameterMatcher { dictionary in
        containsAnyOf(elements).matches(dictionary.values)
    }
}

// MARK: - Contains ALL of the elements as values.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the passed values.
 * - parameter values: Variadic values that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsAllValuesOf<K, V>(
    values elements: V...,
    where equality: @escaping (V, V) -> Bool
) -> ParameterMatcher<[K: V]> {
    containsAllValuesOf(elements, where: equality)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the passed values.
 * - parameter elements: Values that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsAllValuesOf<K, S: Sequence>(
    _ elements: S,
    where equality: @escaping (S.Element, S.Element) -> Bool
) -> ParameterMatcher<[K: S.Element]> {
    ParameterMatcher { dictionary in
        containsAllOf(elements, where: equality).matches(dictionary.values)
    }
}

/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the passed values.
 * - parameter values: Variadic values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAllValuesOf<K, V: Equatable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    containsAllValuesOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the passed values.
 * - parameter elements: Values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAllValuesOf<K, S: Sequence>(
    _ elements: S
) -> ParameterMatcher<[K: S.Element]> where S.Element: Equatable {
    containsAllValuesOf(elements, where: ==)
}

/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the passed values.
 * - parameter values: Variadic values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAllValuesOf<K, V: Hashable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    containsAllValuesOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains all of the passed values.
 * - parameter elements: Values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsAllValuesOf<K, S: Sequence>(
    _ elements: S
) -> ParameterMatcher<[K: S.Element]> where S.Element: Hashable {
    ParameterMatcher { dictionary in
        containsAllOf(elements).matches(dictionary.values)
    }
}

// MARK: - Contains NONE of the elements as values.
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed values.
 * - parameter values: Variadic values that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoValuesOf<K, V>(
    values elements: V...,
    where equality: @escaping (V, V) -> Bool
) -> ParameterMatcher<[K: V]> {
    containsNoValuesOf(elements, where: equality)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed values.
 * - parameter elements: Values that are used for matching.
 * - parameter where: Closure for determining equality of elements that don't conform to `Equatable`.
 * - returns: ParameterMatcher object.
 */
public func containsNoValuesOf<K, S: Sequence>(
    _ elements: S,
    where equality: @escaping (S.Element, S.Element) -> Bool
) -> ParameterMatcher<[K: S.Element]> {
    not(containsAnyValuesOf(elements, where: equality))
}

/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed values.
 * - parameter values: Variadic values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsNoValuesOf<K, V: Equatable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    containsNoValuesOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed values.
 * - parameter elements: Values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsNoValuesOf<K, S: Sequence>(
    _ elements: S
) -> ParameterMatcher<[K: S.Element]> where S.Element: Equatable {
    containsNoValuesOf(elements, where: ==)
}

/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed values.
 * - parameter values: Variadic values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsNoValuesOf<K, V: Hashable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    containsNoValuesOf(elements)
}
/**
 * Matcher for dictionaries that checks if the matching dictionary contains none of the passed values.
 * - parameter elements: Values that are used for matching.
 * - returns: ParameterMatcher object.
 */
public func containsNoValuesOf<K, S: Sequence>(
    _ elements: S
) -> ParameterMatcher<[K: S.Element]> where S.Element: Hashable {
    not(containsAnyValuesOf(elements))
}
