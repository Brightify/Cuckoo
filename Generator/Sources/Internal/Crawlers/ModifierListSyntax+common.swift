import SwiftSyntax

extension Optional where Wrapped == DeclModifierListSyntax {
    var isFinal: Bool {
        self?.isFinal ?? false
    }

    var isStatic: Bool {
        self?.isStatic ?? false
    }
}

extension DeclModifierListSyntax {
    var isFinal: Bool {
        contains { $0.name.tokenKind == .keyword(.final) }
    }

    var isStatic: Bool {
        contains { $0.name.tokenKind == .keyword(.static) }
    }
}
