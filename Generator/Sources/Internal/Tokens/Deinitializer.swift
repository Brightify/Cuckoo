struct Deinitializer: Token, HasAttributes {
    var parent: Reference<Token>?

    var attributes: [Attribute]
}
