import SwiftSyntax

extension StringLiteralExprSyntax {
    init(text: String) {
        self.init(openingQuote: .stringQuoteToken(), segments: [.stringSegment(.init(content: .stringSegment(text)))], closingQuote: .stringQuoteToken())
    }
}

extension ExprSyntaxProtocol {
    func tryIf(_ condition: Bool) -> ExprSyntaxProtocol {
        if condition {
            TryExprSyntax(expression: self)
        } else {
            self
        }
    }

    func awaitIf(_ condition: Bool) -> ExprSyntaxProtocol {
        if condition {
            AwaitExprSyntax(expression: self)
        } else {
            self
        }
    }
}

extension TokenSyntax {
    var identifier: String {
        tokenKind.identifier
    }
}

extension IdentifierTypeSyntax {
    var identifier: String {
        name.tokenKind.identifier
    }
}

extension TokenKind {
    var identifier: String {
        if case .identifier(let identifier) = self {
            return identifier
        } else {
            fatalError("Cuckoo error: Expected identifier. Please create an issue.")
        }
    }
}
