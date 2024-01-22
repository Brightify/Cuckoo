import Foundation

/// This structure exists purely for supporting nested classes,
/// it could be any container (like `struct` or `extension`).
struct NamespaceDeclaration: Token, HasAccessibility, HasName, HasMembers {
    var parent: Reference<Token>?

    var attributes: [Attribute]
    var accessibility: Accessibility
    var name: String
    var members: [Token]

    func replacing(members: [Token]) -> NamespaceDeclaration {
        NamespaceDeclaration(
            parent: parent,
            attributes: attributes,
            accessibility: accessibility,
            name: name,
            members: members
        )
    }
}
