public struct Initializer: Method, HasAccessibility {
    public var name: String
    public var accessibility: Accessibility
    public var returnType: WrappableType
    public var returnSignature: ReturnSignature
    public var range: CountableRange<Int>
    public var nameRange: CountableRange<Int>
    public var parameters: [MethodParameter]
    public var isOverriding: Bool
    public var required: Bool
    public var attributes: [Attribute]
    public var genericParameters: [GenericParameter]

    public var isOptional: Bool {
        return false
    }
}
