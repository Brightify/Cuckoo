struct ProtocolDeclaration: ContainerToken {
    var parent: Reference<Token>?

    var attributes: [Attribute]
    var accessibility: Accessibility
    var name: String
    var associatedTypes: [GenericParameter]
    var primaryAssociatedTypes: [GenericParameter]
    var genericRequirements: [String]
    var inheritedTypes: [String]
    var members: [Token]
    var isNSObjectProtocol = false
    var isActorRequirement = false

    func replacing(members: [Token]) -> ProtocolDeclaration {
        ProtocolDeclaration(
            parent: parent,
            attributes: attributes,
            accessibility: accessibility,
            name: name,
            associatedTypes: associatedTypes,
            primaryAssociatedTypes: primaryAssociatedTypes,
            genericRequirements: genericRequirements,
            inheritedTypes: inheritedTypes,
            members: members,
            isNSObjectProtocol: isNSObjectProtocol,
            isActorRequirement: isActorRequirement
        )
    }

    func replacing(isNSObjectProtocol: Bool) -> ProtocolDeclaration {
        ProtocolDeclaration(
            parent: parent,
            attributes: attributes,
            accessibility: accessibility,
            name: name,
            associatedTypes: associatedTypes,
            primaryAssociatedTypes: primaryAssociatedTypes,
            genericRequirements: genericRequirements,
            inheritedTypes: inheritedTypes,
            members: members,
            isNSObjectProtocol: isNSObjectProtocol,
            isActorRequirement: isActorRequirement
        )
    }

    func replacing(isActorRequirement: Bool) -> ProtocolDeclaration {
        ProtocolDeclaration(
            parent: parent,
            attributes: attributes,
            accessibility: accessibility,
            name: name,
            associatedTypes: associatedTypes,
            primaryAssociatedTypes: primaryAssociatedTypes,
            genericRequirements: genericRequirements,
            inheritedTypes: inheritedTypes,
            members: members,
            isNSObjectProtocol: isNSObjectProtocol,
            isActorRequirement: isActorRequirement
        )
    }
    
    var genericParameters: [GenericParameter] {
        (associatedTypes + primaryAssociatedTypes).merged()
    }
    
    var nonPrimaryAssociatedTypes: [GenericParameter] {
        associatedTypes.filter { !primaryAssociatedTypes.map(\.name).contains($0.name) }
    }
}
