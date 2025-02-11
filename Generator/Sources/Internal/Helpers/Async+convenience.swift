import Foundation

// Taken from https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

    func asyncCompactMap<T>(
        _ transform: (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            if let value = try await transform(element) {
                values.append(value)
            }
        }

        return values
    }
}

extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}

extension Sequence where Element: Sendable {
    func concurrentForEach(
        _ operation: @escaping @Sendable (Element) async -> Void
    ) async {
        // A task group automatically waits for all of its
        // sub-tasks to complete, while also performing those
        // tasks in parallel:
        if #available(macOS 14.0, *) {
            await withDiscardingTaskGroup { group in
                for element in self {
                    group.addTask {
                        await operation(element)
                    }
                }
            }
        } else {
            await withTaskGroup(of: Void.self) { group in
                for element in self {
                    group.addTask {
                        await operation(element)
                    }
                }
            }
        }
    }
}

extension Sequence where Element: Sendable {
    func concurrentMap<T: Sendable>(
        _ transform: @escaping @Sendable (Element) async throws -> T
    ) async rethrows -> [T] {
        let tasks = map { element in
            Task {
                try await transform(element)
            }
        }

        return try await tasks.asyncMap { task in
            try await task.value
        }
    }

    func concurrentCompactMap<T: Sendable>(
        _ transform: @escaping @Sendable (Element) async throws -> T?
    ) async rethrows -> [T] {
        let tasks = map { element in
            Task {
                try await transform(element)
            }
        }

        return try await tasks.asyncCompactMap { task in
            try await task.value
        }
    }
}
