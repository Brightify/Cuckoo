import Foundation

struct OrderedSet<Element: Hashable>: ExpressibleByArrayLiteral {
    var values: [Element] {
        orderedSet.array as! [Element]
    }

    private let orderedSet: NSMutableOrderedSet

    init() {
        orderedSet = NSMutableOrderedSet()
    }

    init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    init(_ array: [Element]) {
        orderedSet = NSMutableOrderedSet(array: array)
    }

    private init(orderedSet: NSMutableOrderedSet) {
        self.orderedSet = orderedSet
    }

    func contains(_ member: Element) -> Bool {
        orderedSet.contains(member)
    }

    mutating func insert(_ newMember: Element) {
        orderedSet.add(newMember)
    }

    mutating func remove(_ member: Element) {
        orderedSet.remove(member)
    }

    func union(_ other: OrderedSet<Element>) -> OrderedSet<Element> {
        withoutMutating { orderedSet in
            orderedSet.union(other.orderedSet)
        }
    }

    func intersection(_ other: OrderedSet<Element>) -> OrderedSet<Element> {
        withoutMutating { orderedSet in
            orderedSet.intersect(other.orderedSet)
        }
    }

    private func withoutMutating(work: (NSMutableOrderedSet) -> Void) -> OrderedSet<Element> {
        let orderedSetCopy = orderedSet.mutableCopy() as! NSMutableOrderedSet
        work(orderedSetCopy)
        return OrderedSet(orderedSet: orderedSetCopy)
    }
}
