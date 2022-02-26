protocol HasMembers: Token {
    var members: [Token] { get set }

    func replacing(members: [Token]) -> Self
}
