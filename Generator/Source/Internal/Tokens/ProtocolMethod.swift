public struct ProtocolMethod: Method {
    public var name: String
    public var accessibility: Accessibility
    public var returnSignature: ReturnSignature
    public var range: CountableRange<Int>
    public var nameRange: CountableRange<Int>
    public var parameters: [MethodParameter]
    public var attributes: [Attribute]
    public var genericParameters: [GenericParameter]

    public var isOptional: Bool {
        return attributes.map { $0.kind }.contains(.optional)
    }
    public var isOverriding: Bool {
        return false
    }
}
