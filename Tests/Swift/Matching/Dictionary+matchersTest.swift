//
//  Dictionary+matchersTest.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 05/09/2019.
//

import XCTest
import Cuckoo

class DictionaryParameterMatcherTest: XCTestCase {
    // MARK: Contains ANY of the elements as key-value pairs.
    func testContainsAnyOf() {
        // With keys identical to values.
        XCTAssertFalse(containsAnyOf([1, 3].toDictionaryAsKeysWithHashable()).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertTrue(containsAnyOf([1, 3].toDictionaryAsKeysWithEquatable()).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAnyOf([1, 3].toDictionaryAsKeysWithNonEquatable(), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAnyOf([1, 3].toDictionaryAsKeysWithEquatable()).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAnyOf([1, 3].toDictionaryAsKeysWithHashable()).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        // With keys different from values.
        XCTAssertFalse(containsAnyOf([1, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertTrue(containsAnyOf([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })).matches([1, 2].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })))
        XCTAssertFalse(containsAnyOf([1, 3].toDictionaryAsKeysWithNonEquatable({ ($0, .init(g: $0 - 1)) }), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAnyOf([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })).matches([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })))
        XCTAssertTrue(containsAnyOf([1, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })).matches([1, 2, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })))
    }

    // MARK: Contains ALL of the elements as key-value pairs.
    func testContainsAllOf() {
        XCTAssertFalse(containsAllOf([1, 3].toDictionaryAsKeysWithHashable()).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsAllOf([1, 3].toDictionaryAsKeysWithEquatable()).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAllOf([1, 3].toDictionaryAsKeysWithNonEquatable(), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAllOf([1, 3].toDictionaryAsKeysWithEquatable()).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAllOf([1, 3].toDictionaryAsKeysWithHashable()).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        XCTAssertFalse(containsAllOf([1, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsAllOf([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })).matches([1, 2].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })))
        XCTAssertFalse(containsAllOf([1, 3].toDictionaryAsKeysWithNonEquatable({ ($0, .init(g: $0 - 1)) }), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAllOf([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })).matches([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })))
        XCTAssertTrue(containsAllOf([1, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })).matches([1, 2, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })))
    }

    // MARK: Contains NONE of the elements as key-value pairs.
    func testContainsNoneOf() {
        // With keys identical to values.
        XCTAssertTrue(containsNoneOf([1, 3].toDictionaryAsKeysWithHashable()).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsNoneOf([1, 3].toDictionaryAsKeysWithEquatable()).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsNoneOf([1, 3].toDictionaryAsKeysWithNonEquatable(), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertFalse(containsNoneOf([1, 3].toDictionaryAsKeysWithEquatable()).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsNoneOf([1, 3].toDictionaryAsKeysWithHashable()).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        // With keys different from values.
        XCTAssertTrue(containsNoneOf([1, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsNoneOf([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })).matches([1, 2].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })))
        XCTAssertTrue(containsNoneOf([1, 3].toDictionaryAsKeysWithNonEquatable({ ($0, .init(g: $0 - 1)) }), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertFalse(containsNoneOf([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })).matches([1, 3].toDictionaryAsKeysWithEquatable({ ($0, .init(g: $0 - 1)) })))
        XCTAssertFalse(containsNoneOf([1, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })).matches([1, 2, 3].toDictionaryAsKeysWithHashable({ ($0, .init(g: $0 - 1)) })))
    }

    // MARK: Contains ANY of the elements as keys.
    func testContainsAnyKeysOf() {
        // Variadic parameters.
        XCTAssertFalse(containsAnyKeysOf(values: 1, 3).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertTrue(containsAnyKeysOf(values: 1, 3).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAnyKeysOf(values: 1, 3).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAnyKeysOf(values: 1, 3).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAnyKeysOf(values: 1, 3).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        // Passed by array.
        XCTAssertFalse(containsAnyKeysOf([1, 3]).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertTrue(containsAnyKeysOf([1, 3]).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAnyKeysOf([1, 3]).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAnyKeysOf([1, 3]).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAnyKeysOf([1, 3]).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))
    }

    // MARK: Contains ALL of the elements as keys.
    func testContainsAllKeysOf() {
        // Variadic parameters.
        XCTAssertFalse(containsAllKeysOf(values: 1, 3).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsAllKeysOf(values: 1, 3).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAllKeysOf(values: 1, 3).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAllKeysOf(values: 1, 3).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAllKeysOf(values: 1, 3).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        // Passed by array.
        XCTAssertFalse(containsAllKeysOf([1, 3]).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsAllKeysOf([1, 3]).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAllKeysOf([1, 3]).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAllKeysOf([1, 3]).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAllKeysOf([1, 3]).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))
    }

    // MARK: Contains NONE of the elements as keys.
    func testContainsNoKeysOf() {
        // Variadic parameters.
        XCTAssertTrue(containsNoKeysOf(values: 1, 3).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsNoKeysOf(values: 1, 3).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsNoKeysOf(values: 1, 3).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertFalse(containsNoKeysOf(values: 1, 3).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsNoKeysOf(values: 1, 3).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        // Passed by array.
        XCTAssertTrue(containsNoKeysOf([1, 3]).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsNoKeysOf([1, 3]).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsNoKeysOf([1, 3]).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertFalse(containsNoKeysOf([1, 3]).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsNoKeysOf([1, 3]).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))
    }

    // MARK: Contains ANY of the elements as values.
    func testContainsAnyValuesOf() {
        // Variadic parameters.
        XCTAssertFalse(containsAnyValuesOf(values: .init(g: 1), .init(g: 3)).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertTrue(containsAnyValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAnyValuesOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAnyValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAnyValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        // Passed by array.
        XCTAssertFalse(containsAnyValuesOf([1, 3].map(TestStructs.H.init)).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertTrue(containsAnyValuesOf([1, 3].map(TestStructs.E.init)).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAnyValuesOf([1, 3].map(TestStructs.N.init), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAnyValuesOf([1, 3].map(TestStructs.E.init)).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAnyValuesOf([1, 3].map(TestStructs.H.init)).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        XCTAssertTrue(
            containsAnyValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: 3), 3: .init(g: 1)]))
        XCTAssertTrue(
            containsAnyValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: 3), 3: .init(g: 4)]))
        XCTAssertTrue(
            containsAnyValuesOf([.init(g: 1), .init(g: 3)])
                .matches([1: TestStructs.H(g: 3)]))
        XCTAssertTrue(
            containsAnyValuesOf([.init(g: 1), .init(g: 3)])
                .matches([1: TestStructs.H(g: 1)]))
        XCTAssertFalse(
            containsAnyValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: -3)]))
    }

    // MARK: Contains ALL of the elements as values.
    func testContainsAllValuesOf() {
        // Variadic parameters.
        XCTAssertFalse(containsAllValuesOf(values: .init(g: 1), .init(g: 3)).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsAllValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAllValuesOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAllValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAllValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        // Passed by array.
        XCTAssertFalse(containsAllValuesOf([1, 3].map(TestStructs.H.init)).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsAllValuesOf([1, 3].map(TestStructs.E.init)).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsAllValuesOf([1, 3].map(TestStructs.N.init), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertTrue(containsAllValuesOf([1, 3].map(TestStructs.E.init)).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsAllValuesOf([1, 3].map(TestStructs.H.init)).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        XCTAssertTrue(
            containsAllValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: 3), 3: .init(g: 1)]))
        XCTAssertFalse(
            containsAllValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: 3), 3: .init(g: 4)]))
        XCTAssertTrue(
            containsAllValuesOf([.init(g: 1), .init(g: 3)])
                .matches([1: TestStructs.H(g: 3), 3: .init(g: 1)]))
        XCTAssertFalse(
            containsAllValuesOf([.init(g: 1), .init(g: 3)])
                .matches([1: TestStructs.H(g: 3), 2: TestStructs.H(g: 3), 3: TestStructs.H(g: 3)]))
        XCTAssertFalse(
            containsAllValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: -3)]))
    }

    // MARK: Contains NONE of the elements as values.
    func testContainsNoValuesOf() {
        // Variadic parameters.
        XCTAssertTrue(containsNoValuesOf(values: .init(g: 1), .init(g: 3)).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsNoValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsNoValuesOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertFalse(containsNoValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsNoValuesOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        // Passed by array.
        XCTAssertTrue(containsNoValuesOf([1, 3].map(TestStructs.H.init)).matches([2].toDictionaryAsKeysWithHashable()))
        XCTAssertFalse(containsNoValuesOf([1, 3].map(TestStructs.E.init)).matches([1, 2].toDictionaryAsKeysWithEquatable()))
        XCTAssertTrue(containsNoValuesOf([1, 3].map(TestStructs.N.init), where: { $0.g == $1.g }).matches([0, 2].toDictionaryAsKeysWithNonEquatable()))
        XCTAssertFalse(containsNoValuesOf([1, 3].map(TestStructs.E.init)).matches([1, 3].toDictionaryAsKeysWithEquatable()))
        XCTAssertFalse(containsNoValuesOf([1, 3].map(TestStructs.H.init)).matches([1, 2, 3].toDictionaryAsKeysWithHashable()))

        XCTAssertFalse(
            containsNoValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: 3), 3: .init(g: 1)]))
        XCTAssertFalse(
            containsNoValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: 3), 3: .init(g: 4)]))
        XCTAssertFalse(
            containsNoValuesOf([.init(g: 1), .init(g: 3)])
                .matches([1: TestStructs.H(g: 3)]))
        XCTAssertFalse(
            containsNoValuesOf([.init(g: 1), .init(g: 3)])
                .matches([1: TestStructs.H(g: 1)]))
        XCTAssertTrue(
            containsNoValuesOf([.init(g: 1), .init(g: 3)])
                .matches([2: TestStructs.H(g: -3)]))
    }

    // MARK: Has length N (exact, at least, at most).
    func testHasLengthExact() {
        XCTAssertTrue(hasLength(exactly: 4).matches([1: 1, 2: 2, 3: 3, 4: 4]))
        XCTAssertFalse(hasLength(exactly: 2).matches([1: 1, 2: 2, 3: 3, 4: 4]))
        XCTAssertTrue(hasLength(exactly: 0).matches([:]))
    }

    func testHasLengthAtLeast() {
        XCTAssertTrue(hasLength(atLeast: 4).matches([1: 1, 2: 2, 3: 3, 4: 4]))
        XCTAssertTrue(hasLength(atLeast: 2).matches([1: 1, 2: 2, 3: 3, 4: 4]))
        XCTAssertTrue(hasLength(atLeast: 0).matches([:]))

        XCTAssertFalse(hasLength(atLeast: 4, inclusive: false).matches([1: 1, 2: 2, 3: 3, 4: 4]))
        XCTAssertTrue(hasLength(atLeast: 2, inclusive: false).matches([1: 1, 2: 2, 3: 3, 4: 4]))
        XCTAssertFalse(hasLength(atLeast: 0, inclusive: false).matches([:]))
    }

    func testHasLengthAtMost() {
        XCTAssertTrue(hasLength(atMost: 4).matches([1: 1, 2: 2, 3: 3, 4: 4]))
        XCTAssertFalse(hasLength(atMost: 2).matches([1: 1, 2: 2, 3: 3, 4: 4]))
        XCTAssertTrue(hasLength(atMost: 0).matches([:]))

        XCTAssertTrue(hasLength(atMost: 5, inclusive: false).matches([1, 2, 3, 4]))
        XCTAssertFalse(hasLength(atMost: 2, inclusive: false).matches([1, 2, 3, 4]))
        XCTAssertFalse(hasLength(atMost: 0, inclusive: false).matches([:]))
    }
}

extension Array where Element == Int {
    func toDictionaryAsKeysAndValues(_ constructor: (Int) -> (Int, Int) = { ($0, $0) }) -> [Int: Int] {
        return Dictionary(uniqueKeysWithValues: map(constructor))
    }

    func toDictionaryAsKeysWithNonEquatable(_ constructor: (Int) -> (Int, TestStructs.N) = { ($0, TestStructs.N(g: $0)) }) -> [Int: TestStructs.N] {
        return Dictionary(uniqueKeysWithValues: map(constructor))
    }

    func toDictionaryAsKeysWithEquatable(_ constructor: (Int) -> (Int, TestStructs.E) = { ($0, TestStructs.E(g: $0)) }) -> [Int: TestStructs.E] {
        return Dictionary(uniqueKeysWithValues: map(constructor))
    }

    func toDictionaryAsKeysWithHashable(_ constructor: (Int) -> (Int, TestStructs.H) = { ($0, TestStructs.H(g: $0)) }) -> [Int: TestStructs.H] {
        return Dictionary(uniqueKeysWithValues: map(constructor))
    }
}
