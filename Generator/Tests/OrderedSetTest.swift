import XCTest

final class OrderedSetTest: XCTestCase {
    func testInitializers() {
        _ = OrderedSet<Int>()
        _ = [] as OrderedSet<String>
        _ = ["1", "2", "4"] as OrderedSet<String>
    }

    func testEmpty() {
        let set = OrderedSet<Double>()
        XCTAssertEqual(set.values, [])
    }

    func testBasicUsage() {
        var set = OrderedSet<Int>()
        set.insert(2)
        XCTAssertEqual(set.values, [2])
        set.insert(0)
        XCTAssertEqual(set.values, [2, 0])
        set.insert(1)
        XCTAssertEqual(set.values, [2, 0, 1])
    }

    func testDeduplicationInit() {
        let set: OrderedSet<Int> = [1, 2, 3, 2, 0, 1]
        XCTAssertEqual(set.values, [1, 2, 3, 0])
    }

    func testDeduplicationInsert() {
        var set = OrderedSet<String>()
        set.insert("1")
        XCTAssertEqual(set.values, ["1"])
        set.insert("11")
        XCTAssertEqual(set.values, ["1", "11"])
        set.insert("111")
        XCTAssertEqual(set.values, ["1", "11", "111"])
        set.insert("11")
        XCTAssertEqual(set.values, ["1", "11", "111"])
        set.insert("1")
        XCTAssertEqual(set.values, ["1", "11", "111"])
    }

    func testRemove() {
        var set: OrderedSet<String> = ["gg", "bg", "wp", "ez"]
        set.remove("ez")
        XCTAssertEqual(set.values, ["gg", "bg", "wp"])
        set.remove("bg")
        XCTAssertEqual(set.values, ["gg", "wp"])
    }

    func testContains() {
        var set: OrderedSet<Int> = [1, 2, 3, 4, 5]
        XCTAssertFalse(set.contains(6))
        XCTAssertTrue(set.contains(1))
        set.insert(6)
        XCTAssertTrue(set.contains(6))
        set.remove(2)
        XCTAssertFalse(set.contains(2))
    }

    func testIntersection() {
        let set1: OrderedSet<Int> = [1, 2, 3, 4]
        let set2: OrderedSet<Int> = [2, 3, 4, 5]
        XCTAssertEqual(set1.intersection(set2).values, [2, 3, 4])
        XCTAssertEqual(set1.values, [1, 2, 3, 4])
        XCTAssertEqual(set2.values, [2, 3, 4, 5])
    }

    func testUnion() {
        let set1: OrderedSet<Int> = [1, 2, 3, 4]
        let set2: OrderedSet<Int> = [2, 3, 4, 5]
        XCTAssertEqual(set1.union(set2).values, [1, 2, 3, 4, 5])
        XCTAssertEqual(set1.values, [1, 2, 3, 4])
        XCTAssertEqual(set2.values, [2, 3, 4, 5])
    }
}
