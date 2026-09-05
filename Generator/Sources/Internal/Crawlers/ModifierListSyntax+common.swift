import SwiftSyntax

extension Optional where Wrapped == DeclModifierListSyntax {
    var isFinal: Bool {
        self?.isFinal ?? false
    }

    var isStatic: Bool {
        self?.isStatic ?? false
    }

    var isClass: Bool {
        self?.isClass ?? false
    }
}

extension DeclModifierListSyntax {
    var isFinal: Bool {
        contains { $0.name.tokenKind == .keyword(.final) }
    }

    var isStatic: Bool {
        contains { $0.name.tokenKind == .keyword(.static) }
    }

    var isClass: Bool {
        contains { $0.name.tokenKind == .keyword(.class) }
    }
}
