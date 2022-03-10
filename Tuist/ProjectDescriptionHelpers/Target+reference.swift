import ProjectDescription

extension Target {
    public var reference: TargetReference {
        TargetReference(stringLiteral: name)
    }
}
