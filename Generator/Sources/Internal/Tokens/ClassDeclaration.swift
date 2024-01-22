struct ClassDeclaration: ContainerToken {
    var parent: Reference<Token>?

    var attributes: [Attribute]
    var accessibility: Accessibility
    var name: String
    var genericParameters: [GenericParameter]
    var genericRequirements: [String]
    var inheritedTypes: [String]
    var members: [Token]

    func replacing(members: [Token]) -> ClassDeclaration {
        ClassDeclaration(
            parent: parent,
            attributes: attributes,
            accessibility: accessibility,
            name: name,
            genericParameters: genericParameters,
            genericRequirements: genericRequirements,
            inheritedTypes: inheritedTypes,
            members: members
        )
    }
}
