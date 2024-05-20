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

extension IdentifierTypeSyntax {
    var identifier: String {
        if case .identifier(let identifier) = name.tokenKind {
            return identifier
        } else {
            fatalError("Cuckoo error: Expected identifier. Please create an issue.")
        }
    }
}
