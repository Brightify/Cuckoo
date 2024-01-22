protocol Serializable {
    func serialize() -> GeneratorContext
}

typealias GeneratorContext = [String: Any]

extension GeneratorContext {
    mutating func merge(_ other: GeneratorContext) {
        merge(other, uniquingKeysWith: { $1 })
    }
}

extension Array where Element == GeneratorContext {
    func merge() -> GeneratorContext {
        var context: GeneratorContext = [:]
        forEach { context.merge($0) }
        return context
    }
}
