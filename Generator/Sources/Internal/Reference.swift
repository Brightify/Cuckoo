import Foundation

@dynamicMemberLookup
final class Reference<Value> {
    private(set) var value: Value
    
    init(_ value: Value) {
        self.value = value
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}

extension Reference: Equatable where Value: Equatable {
    static func == (lhs: Reference<Value>, rhs: Reference<Value>) -> Bool {
        lhs.value == rhs.value
    }
}
