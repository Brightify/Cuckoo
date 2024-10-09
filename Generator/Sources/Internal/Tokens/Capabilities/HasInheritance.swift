protocol HasInheritance: Token {
    var inheritedTypes: [String] { get }
}

extension HasInheritance {
    func inheritanceSerialize() -> GeneratorContext {
        [
            "inheritedTypes": inheritedTypes,
        ]
    }
}
