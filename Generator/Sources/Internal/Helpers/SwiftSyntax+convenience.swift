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

extension SyntaxProtocol {
    var filteredDescription: String {
        trimmedDescription.replacingOccurrences(of: "\n", with: " ")
    }
}
