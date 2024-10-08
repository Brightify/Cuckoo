protocol HasName: Token {
    var name: String { get }
}

extension HasName {
    var mockName: String {
        "Mock\(name)"
    }

    var fullyQualifiedName: String {
        var names = [name]
        var parent: Token? = parent?.value
        while let p = parent as? HasName {
            names.insert(p.name, at: 0)
            parent = p.parent?.value
        }
        return names.joined(separator: ".")
    }

    func nameSerialize() -> GeneratorContext {
        [
            "name": name,
            "mockName": mockName,
        ]
    }
}
