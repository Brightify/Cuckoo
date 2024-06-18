struct Variable: Token, HasAccessibility, HasAttributes {
    struct Effects {
        var isThrowing = false
        var isAsync = false
    }

    var parent: Reference<Token>?

    var documentation: [String]
    var attributes: [Attribute]
    var accessibility: Accessibility
    var setterAccessibility: Accessibility?
    var name: String
    var type: ComplexType
    var effects: Effects
    var isReadOnly: Bool {
        setterAccessibility?.isAccessible != true
    }
    // This flag is used to block generating inherited variables if the property to be overridden
    // is a constant, which Swift doesn't allow.
    var isConstant: Bool

    func serialize() -> [String: Any] {
        let readOnlyVerifyString = isReadOnly ? "ReadOnly" : ""
        let readOnlyStubString = effects.isThrowing ? "" : readOnlyVerifyString
        let optionalString = type.isOptional && !isReadOnly ? "Optional" : ""
        let throwingString = effects.isThrowing ? "Throwing" : ""

        guard let parent else {
            fatalError("Failed to find parent of variable \(name). Please file a bug.")
        }

        return [
            "documentation": documentation,
            "isOverriding": parent.isClass,
            "name": name,
            "type": type.description,
            "nonOptionalType": type.unoptionaled.description,
            "accessibility": accessibility.sourceName,
            "isAsync": effects.isAsync,
            "isThrowing": effects.isThrowing,
            "isReadOnly": isReadOnly,
            "stubType": (parent.isClass ? "Class" : "Protocol") + "ToBeStubbed\(readOnlyStubString)\(optionalString)\(throwingString)Property",
            "verifyType": "Verify\(readOnlyVerifyString)\(optionalString)Property",
            "attributes": attributes,
            "hasUnavailablePlatforms": hasUnavailablePlatforms,
            "unavailablePlatformsCheck": unavailablePlatformsCheck,
        ]
    }
}

extension Variable: Inheritable {
    var isInheritable: Bool {
        !isConstant
    }

    func isEqual(to other: Inheritable) -> Bool {
        guard let other = other as? Variable else { return false }
        return name == other.name
    }
}
