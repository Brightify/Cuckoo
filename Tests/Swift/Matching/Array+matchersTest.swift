//
//  Array+matchersTest.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 05/09/2019.
//

import XCTest
import Cuckoo

struct TestStructs {
    struct N {
        let g: Int
    }
    struct E: Equatable {
        let g: Int
    }
    struct H: Hashable {
        let g: Int
    }
}

class ArrayMatcherTest: XCTestCase {
    // MARK: Contains ANY of the elements.
    func testContainsAnyOf() {
        // Variadic parameters.
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([2].map(TestStructs.N.init)))
        XCTAssertTrue(containsAnyOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([1, 2, 3].map(TestStructs.N.init)))
        XCTAssertTrue(containsAnyOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([1, 2, 3, 4, 5].map(TestStructs.N.init)))
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([4, 5, 6, 0].map(TestStructs.N.init)))
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([].map(TestStructs.N.init)))

        // Passed by array.
        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([2].map(TestStructs.N.init)))
        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([1, 2, 3].map(TestStructs.N.init)))
        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([1, 2, 3, 4, 5].map(TestStructs.N.init)))
        XCTAssertFalse(containsAnyOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([4, 5, 6, 0].map(TestStructs.N.init)))
        XCTAssertFalse(containsAnyOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([].map(TestStructs.N.init)))
    }

    func testContainsAnyOfEquatable() {
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([2].map(TestStructs.E.init)))
        XCTAssertTrue(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].map(TestStructs.E.init)))
        XCTAssertTrue(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3, 4, 5].map(TestStructs.E.init)))
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([4, 5, 6, 0].map(TestStructs.E.init)))
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([].map(TestStructs.E.init)))

        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.E.init)).matches([2].map(TestStructs.E.init)))
        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.E.init)).matches([1, 2, 3].map(TestStructs.E.init)))
        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.E.init)).matches([1, 2, 3, 4, 5].map(TestStructs.E.init)))
        XCTAssertFalse(containsAnyOf((1...3).map(TestStructs.E.init)).matches([4, 5, 6, 0].map(TestStructs.E.init)))
        XCTAssertFalse(containsAnyOf((1...3).map(TestStructs.E.init)).matches([].map(TestStructs.E.init)))
    }

    func testContainsAnyOfHashable() {
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([2].map(TestStructs.H.init)))
        XCTAssertTrue(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].map(TestStructs.H.init)))
        XCTAssertTrue(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3, 4, 5].map(TestStructs.H.init)))
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([4, 5, 6, 0].map(TestStructs.H.init)))
        XCTAssertFalse(containsAnyOf(values: .init(g: 1), .init(g: 3)).matches([].map(TestStructs.H.init)))

        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.H.init)).matches([2].map(TestStructs.H.init)))
        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.H.init)).matches([1, 2, 3].map(TestStructs.H.init)))
        XCTAssertTrue(containsAnyOf((1...3).map(TestStructs.H.init)).matches([1, 2, 3, 4, 5].map(TestStructs.H.init)))
        XCTAssertFalse(containsAnyOf((1...3).map(TestStructs.H.init)).matches([4, 5, 6, 0].map(TestStructs.H.init)))
        XCTAssertFalse(containsAnyOf((1...3).map(TestStructs.H.init)).matches([].map(TestStructs.H.init)))
    }

    // MARK: Contains ALL of the elements.
    func testContainsAllOf() {
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([2].map(TestStructs.N.init)))
        XCTAssertTrue(containsAllOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([1, 2, 3].map(TestStructs.N.init)))
        XCTAssertTrue(containsAllOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([1, 2, 3, 4, 5].map(TestStructs.N.init)))
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([4, 5, 6, 0].map(TestStructs.N.init)))
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([3].map(TestStructs.N.init)))

        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([2].map(TestStructs.N.init)))
        XCTAssertTrue(containsAllOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([1, 2, 3].map(TestStructs.N.init)))
        XCTAssertTrue(containsAllOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([1, 2, 3, 4, 5].map(TestStructs.N.init)))
        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([4, 5, 6, 0].map(TestStructs.N.init)))
        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([3].map(TestStructs.N.init)))
    }

    func testContainsAllOfEquatable() {
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([2].map(TestStructs.E.init)))
        XCTAssertTrue(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].map(TestStructs.E.init)))
        XCTAssertTrue(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3, 4, 5].map(TestStructs.E.init)))
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([4, 5, 6, 0].map(TestStructs.E.init)))
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([3].map(TestStructs.E.init)))

        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.E.init)).matches([2].map(TestStructs.E.init)))
        XCTAssertTrue(containsAllOf((1...3).map(TestStructs.E.init)).matches([1, 2, 3].map(TestStructs.E.init)))
        XCTAssertTrue(containsAllOf((1...3).map(TestStructs.E.init)).matches([1, 2, 3, 4, 5].map(TestStructs.E.init)))
        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.E.init)).matches([4, 5, 6, 0].map(TestStructs.E.init)))
        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.E.init)).matches([3].map(TestStructs.E.init)))
    }

    func testContainsAllOfHashable() {
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([2].map(TestStructs.H.init)))
        XCTAssertTrue(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].map(TestStructs.H.init)))
        XCTAssertTrue(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3, 4, 5].map(TestStructs.H.init)))
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([4, 5, 6, 0].map(TestStructs.H.init)))
        XCTAssertFalse(containsAllOf(values: .init(g: 1), .init(g: 3)).matches([3].map(TestStructs.H.init)))

        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.H.init)).matches([2].map(TestStructs.H.init)))
        XCTAssertTrue(containsAllOf((1...3).map(TestStructs.H.init)).matches([1, 2, 3].map(TestStructs.H.init)))
        XCTAssertTrue(containsAllOf((1...3).map(TestStructs.H.init)).matches([1, 2, 3, 4, 5].map(TestStructs.H.init)))
        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.H.init)).matches([4, 5, 6, 0].map(TestStructs.H.init)))
        XCTAssertFalse(containsAllOf((1...3).map(TestStructs.H.init)).matches([3].map(TestStructs.H.init)))
    }

    func testContainsAllOfMultiple() {
        XCTAssertFalse(containsAllOf(values: 1, 3, 2, 2, 1).matches([2]))
        XCTAssertFalse(containsAllOf(values: 1, 3, 2, 2, 1).matches([1, 2, 3]))
        XCTAssertFalse(containsAllOf(values: 1, 3, 2, 2, 1).matches([1, 3, 2, 2]))
        XCTAssertTrue(containsAllOf(values: 1, 3, 2, 2, 1).matches([1, 3, 2, 2, 1]))

        XCTAssertFalse(containsAllOf([1, 3, 2, 2, 1]).matches([2]))
        XCTAssertFalse(containsAllOf([1, 3, 2, 2, 1]).matches([1, 2, 3]))
        XCTAssertFalse(containsAllOf([1, 3, 2, 2, 1]).matches([1, 3, 2, 2]))
        XCTAssertTrue(containsAllOf([1, 3, 2, 2, 1]).matches([1, 3, 2, 2, 1]))
    }

    // MARK: Contains NONE of the elements.
    func testContainsNoneOf() {
        // Variadic parameters.
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([2].map(TestStructs.N.init)))
        XCTAssertFalse(containsNoneOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([1, 2, 3].map(TestStructs.N.init)))
        XCTAssertFalse(containsNoneOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([1, 2, 3, 4, 5].map(TestStructs.N.init)))
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([4, 5, 6, 0].map(TestStructs.N.init)))
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3), where: { $0.g == $1.g }).matches([].map(TestStructs.N.init)))

        // Passed by array.
        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([2].map(TestStructs.N.init)))
        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([1, 2, 3].map(TestStructs.N.init)))
        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([1, 2, 3, 4, 5].map(TestStructs.N.init)))
        XCTAssertTrue(containsNoneOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([4, 5, 6, 0].map(TestStructs.N.init)))
        XCTAssertTrue(containsNoneOf((1...3).map(TestStructs.N.init), where: { $0.g == $1.g }).matches([].map(TestStructs.N.init)))
    }

    func testContainsNoneOfEquatable() {
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([2].map(TestStructs.E.init)))
        XCTAssertFalse(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].map(TestStructs.E.init)))
        XCTAssertFalse(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3, 4, 5].map(TestStructs.E.init)))
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([4, 5, 6, 0].map(TestStructs.E.init)))
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([].map(TestStructs.E.init)))

        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.E.init)).matches([2].map(TestStructs.E.init)))
        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.E.init)).matches([1, 2, 3].map(TestStructs.E.init)))
        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.E.init)).matches([1, 2, 3, 4, 5].map(TestStructs.E.init)))
        XCTAssertTrue(containsNoneOf((1...3).map(TestStructs.E.init)).matches([4, 5, 6, 0].map(TestStructs.E.init)))
        XCTAssertTrue(containsNoneOf((1...3).map(TestStructs.E.init)).matches([].map(TestStructs.E.init)))
    }

    func testContainsNoneOfHashable() {
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([2].map(TestStructs.H.init)))
        XCTAssertFalse(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3].map(TestStructs.H.init)))
        XCTAssertFalse(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([1, 2, 3, 4, 5].map(TestStructs.H.init)))
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([4, 5, 6, 0].map(TestStructs.H.init)))
        XCTAssertTrue(containsNoneOf(values: .init(g: 1), .init(g: 3)).matches([].map(TestStructs.H.init)))

        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.H.init)).matches([2].map(TestStructs.H.init)))
        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.H.init)).matches([1, 2, 3].map(TestStructs.H.init)))
        XCTAssertFalse(containsNoneOf((1...3).map(TestStructs.H.init)).matches([1, 2, 3, 4, 5].map(TestStructs.H.init)))
        XCTAssertTrue(containsNoneOf((1...3).map(TestStructs.H.init)).matches([4, 5, 6, 0].map(TestStructs.H.init)))
        XCTAssertTrue(containsNoneOf((1...3).map(TestStructs.H.init)).matches([].map(TestStructs.H.init)))
    }

    // MARK: Has length N (exact, at least, at most).
    func testHasLengthExact() {
        XCTAssertTrue(hasLength(exactly: 4).matches([1, 2, 3, 4]))
        XCTAssertFalse(hasLength(exactly: 2).matches([1, 2, 3, 4]))
        XCTAssertTrue(hasLength(exactly: 0).matches([]))
    }

    func testHasLengthAtLeast() {
        XCTAssertTrue(hasLength(atLeast: 4).matches([1, 2, 3, 4]))
        XCTAssertTrue(hasLength(atLeast: 2).matches([1, 2, 3, 4]))
        XCTAssertTrue(hasLength(atLeast: 0).matches([]))

        XCTAssertFalse(hasLength(atLeast: 4, inclusive: false).matches([1, 2, 3, 4]))
        XCTAssertTrue(hasLength(atLeast: 2, inclusive: false).matches([1, 2, 3, 4]))
        XCTAssertFalse(hasLength(atLeast: 0, inclusive: false).matches([]))
    }

    func testHasLengthAtMost() {
        XCTAssertTrue(hasLength(atMost: 4).matches([1, 2, 3, 4]))
        XCTAssertFalse(hasLength(atMost: 2).matches([1, 2, 3, 4]))
        XCTAssertTrue(hasLength(atMost: 0).matches([]))

        XCTAssertTrue(hasLength(atMost: 5, inclusive: false).matches([1, 2, 3, 4]))
        XCTAssertFalse(hasLength(atMost: 2, inclusive: false).matches([1, 2, 3, 4]))
        XCTAssertFalse(hasLength(atMost: 0, inclusive: false).matches([]))
    }
}
