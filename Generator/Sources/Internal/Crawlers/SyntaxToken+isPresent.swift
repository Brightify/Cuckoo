import SwiftSyntax

extension Optional where Wrapped == TokenSyntax {
    var isPresent: Bool {
        self?.isPresent ?? false
    }
}

extension TokenSyntax {
    var isPresent: Bool {
        presence == .present
    }
}
