import SwiftSyntax
import SwiftParser

struct Typealias: Token, CustomStringConvertible {
    var parent: Reference<Token>?

    let alias: String
    let original: String

    var description: String {
        "typealias \(alias) = \(original)"
    }
}

extension Typealias {
    init(syntax: TypeAliasDeclSyntax) {
        self.init(
            alias: [
                syntax.name.filteredDescription,
                syntax.genericParameterClause?.trimmedDescription
            ]
            .compactMap { $0 }
            .joined(),
            original: syntax.initializer.value.trimmedDescription
        )
    }
}
