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

    func recursivelyNormalizingTrivia(leading: Trivia = [], trailing: Trivia = []) -> Self {
        var mutableSelf = self
        mutableSelf.leadingTrivia = leading
        mutableSelf.trailingTrivia = trailing

        if var identifierType = mutableSelf.as(IdentifierTypeSyntax.self) {
            if let genericArguments = identifierType.genericArgumentClause?.arguments {
                identifierType.genericArgumentClause = GenericArgumentClauseSyntax(
                    arguments: GenericArgumentListSyntax(
                        genericArguments.enumerated().map { index, argument in
                            argument.recursivelyNormalizingTrivia(leading: index == 0 ? [] : .space)
                        }
                    )
                )
            }
            return identifierType.as(Self.self)!
        } else {
            return mutableSelf
        }
    }
}
