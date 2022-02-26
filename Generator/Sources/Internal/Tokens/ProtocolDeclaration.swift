struct ProtocolDeclaration: ContainerToken {
    var parent: Reference<Token>?

    var attributes: [Attribute]
    var accessibility: Accessibility
    var name: String
    var genericParameters: [GenericParameter]
    var genericRequirements: [String]
    var inheritedTypes: [String]
    var members: [Token]
    var isNSObjectProtocol = false

    func replacing(members: [Token]) -> ProtocolDeclaration {
        ProtocolDeclaration(
            parent: parent,
            attributes: attributes,
            accessibility: accessibility,
            name: name,
            genericParameters: genericParameters,
            genericRequirements: genericRequirements,
            inheritedTypes: inheritedTypes,
            members: members,
            isNSObjectProtocol: isNSObjectProtocol
        )
    }

    func replacing(isNSObjectProtocol: Bool) -> ProtocolDeclaration {
        ProtocolDeclaration(
            parent: parent,
            attributes: attributes,
            accessibility: accessibility,
            name: name,
            genericParameters: genericParameters,
            genericRequirements: genericRequirements,
            inheritedTypes: inheritedTypes,
            members: members,
            isNSObjectProtocol: isNSObjectProtocol
        )
    }
}
