protocol HasAttributes: Token {
    var attributes: [Attribute] { get }
}

extension HasAttributes {
    private var unavailablePlatforms: [String] {
        attributes.compactMap { $0.unavailablePlatform }
    }

    var hasUnavailablePlatforms: Bool {
        !unavailablePlatforms.isEmpty
    }

    var unavailablePlatformsCheck: String {
        hasUnavailablePlatforms ? "#if !os(\(unavailablePlatforms.joined(separator: ") && !os(")))" : ""
    }

    func attributesSerialize() -> GeneratorContext {
        [
            "attributes": attributes,
        ]
    }
}
