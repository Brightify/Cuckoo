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


// MARK: PAIR MATCHING
// MARK: Contains ANY of the elements as key-value pairs.
public func containsAnyOf<K, V: Equatable>(_ inputDictionary: [K: V]) -> ParameterMatcher<[K: V]> {
    return containsAnyOf(inputDictionary, where: ==)
}
public func containsAnyOf<K, V>(_ inputDictionary: [K: V], where equality: @escaping (V, V) -> Bool) -> ParameterMatcher<[K: V]> {
    return ParameterMatcher { dictionary in
        inputDictionary.contains { key, value in
            dictionary[key].map { equality($0, value) } ?? false
        }
    }
}

// MARK: Contains ALL of the elements as key-value pairs.
public func containsAllOf<K, V: Equatable>(_ inputDictionary: [K: V]) -> ParameterMatcher<[K: V]> {
    return containsAllOf(inputDictionary, where: ==)
}
public func containsAllOf<K, V>(_ inputDictionary: [K: V], where equality: @escaping (V, V) -> Bool) -> ParameterMatcher<[K: V]> {
    return ParameterMatcher { dictionary in
        inputDictionary.allSatisfy { key, value in
            dictionary[key].map { equality($0, value) } ?? false
        }
    }
}

// MARK: Contains NONE of the elements as key-value pairs.
public func containsNoneOf<K, V: Equatable>(_ inputDictionary: [K: V]) -> ParameterMatcher<[K: V]> {
    return containsNoneOf(inputDictionary, where: ==)
}
public func containsNoneOf<K, V>(_ inputDictionary: [K: V], where equality: @escaping (V, V) -> Bool) -> ParameterMatcher<[K: V]> {
    return not(containsAnyOf(inputDictionary, where: equality))
}


// MARK: KEYS MATCHING
// MARK: Contains ANY of the elements as keys.
public func containsAnyKeysOf<K, V>(values elements: K...) -> ParameterMatcher<[K: V]> {
    return containsAnyKeysOf(elements)
}
public func containsAnyKeysOf<S: Sequence, V>(_ elements: S) -> ParameterMatcher<[S.Element: V]> {
    return ParameterMatcher { dictionary in
        containsAnyOf(elements).matches(dictionary.keys)
    }
}

// MARK: Contains ALL of the elements as keys.
public func containsAllKeysOf<K, V>(values elements: K...) -> ParameterMatcher<[K: V]> {
    return containsAllKeysOf(elements)
}
public func containsAllKeysOf<S: Sequence, V>(_ elements: S) -> ParameterMatcher<[S.Element: V]> {
    return ParameterMatcher { dictionary in
        containsAllOf(elements).matches(dictionary.keys)
    }
}

// MARK: Contains NONE of the elements as keys.
public func containsNoKeysOf<K, V>(values elements: K...) -> ParameterMatcher<[K: V]> {
    return containsNoKeysOf(elements)
}
public func containsNoKeysOf<S: Sequence, V>(_ elements: S) -> ParameterMatcher<[S.Element: V]> {
    return not(containsAnyKeysOf(elements))
}


// MARK: VALUES MATCHING
// MARK: Contains ANY of the elements as values.
public func containsAnyValuesOf<K, V>(values elements: V..., where equality: @escaping (V, V) -> Bool) -> ParameterMatcher<[K: V]> {
    return containsAnyValuesOf(elements, where: equality)
}
public func containsAnyValuesOf<K, S: Sequence>(_ elements: S, where equality: @escaping (S.Element, S.Element) -> Bool) -> ParameterMatcher<[K: S.Element]> {
    return ParameterMatcher { dictionary in
        containsAnyOf(elements, where: equality).matches(dictionary.values)
    }
}

public func containsAnyValuesOf<K, V: Equatable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    return containsAnyValuesOf(elements)
}
public func containsAnyValuesOf<K, S: Sequence>(_ elements: S) -> ParameterMatcher<[K: S.Element]> where S.Element: Equatable {
    return containsAnyValuesOf(elements, where: ==)
}

public func containsAnyValuesOf<K, V: Hashable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    return containsAnyValuesOf(elements)
}
public func containsAnyValuesOf<K, S: Sequence>(_ elements: S) -> ParameterMatcher<[K: S.Element]> where S.Element: Hashable {
    return ParameterMatcher { dictionary in
        containsAnyOf(elements).matches(dictionary.values)
    }
}

// MARK: Contains ALL of the elements as values.
public func containsAllValuesOf<K, V>(values elements: V..., where equality: @escaping (V, V) -> Bool) -> ParameterMatcher<[K: V]> {
    return containsAllValuesOf(elements, where: equality)
}
public func containsAllValuesOf<K, S: Sequence>(_ elements: S, where equality: @escaping (S.Element, S.Element) -> Bool) -> ParameterMatcher<[K: S.Element]> {
    return ParameterMatcher { dictionary in
        containsAllOf(elements, where: equality).matches(dictionary.values)
    }
}

public func containsAllValuesOf<K, V: Equatable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    return containsAllValuesOf(elements)
}
public func containsAllValuesOf<K, S: Sequence>(_ elements: S) -> ParameterMatcher<[K: S.Element]> where S.Element: Equatable {
    return containsAllValuesOf(elements, where: ==)
}

public func containsAllValuesOf<K, V: Hashable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    return containsAllValuesOf(elements)
}
public func containsAllValuesOf<K, S: Sequence>(_ elements: S) -> ParameterMatcher<[K: S.Element]> where S.Element: Hashable {
    return ParameterMatcher { dictionary in
        containsAllOf(elements).matches(dictionary.values)
    }
}

// MARK: Contains NONE of the elements as values.
public func containsNoValuesOf<K, V>(values elements: V..., where equality: @escaping (V, V) -> Bool) -> ParameterMatcher<[K: V]> {
    return containsNoValuesOf(elements, where: equality)
}
public func containsNoValuesOf<K, S: Sequence>(_ elements: S, where equality: @escaping (S.Element, S.Element) -> Bool) -> ParameterMatcher<[K: S.Element]> {
    return not(containsAnyValuesOf(elements, where: equality))
}

public func containsNoValuesOf<K, V: Equatable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    return containsNoValuesOf(elements)
}
public func containsNoValuesOf<K, S: Sequence>(_ elements: S) -> ParameterMatcher<[K: S.Element]> where S.Element: Equatable {
    return containsNoValuesOf(elements, where: ==)
}

public func containsNoValuesOf<K, V: Hashable>(values elements: V...) -> ParameterMatcher<[K: V]> {
    return containsNoValuesOf(elements)
}
public func containsNoValuesOf<K, S: Sequence>(_ elements: S) -> ParameterMatcher<[K: S.Element]> where S.Element: Hashable {
    return not(containsAnyValuesOf(elements))
}
