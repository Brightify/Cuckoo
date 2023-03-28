//
//  PropertyWrappers.swift
//  Cuckoo
//
//  Created by Kabir Oberai on 2023-03-28.
//

// wrappers without annotations aren't supported but their
// existence shouldn't cause the generator to crash

@propertyWrapper
struct DoublingWrapper {
    private var backing: Int
    var wrappedValue: Int {
        get { backing * 2 }
        set { backing = newValue }
    }

    init(wrappedValue: Int) {
        self.backing = wrappedValue
    }

    init() {
        self.backing = 0
    }
}

struct Wrappers {
    @DoublingWrapper var base
    @DoublingWrapper var withValue = 2
    @DoublingWrapper var withAnnotation: Int
    @DoublingWrapper var withAnnotationAndValue: Int = 2
}
