open class Timer {
    public init() {}
    open func read() -> Int { 17 }
}

public protocol Clock {
    func read() -> Int
}

public protocol Store {
    associatedtype Value
    func read() -> Value
}

public struct Namespace {
    public protocol NestedClock {
        func read() -> Int
    }
}
