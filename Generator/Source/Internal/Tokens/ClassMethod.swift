public struct ClassMethod: Method {
    public var name: String
    public var accessibility: Accessibility
    public var returnSignature: ReturnSignature
    public var range: CountableRange<Int>
    public var nameRange: CountableRange<Int>
    public var parameters: [MethodParameter]
    public var bodyRange: CountableRange<Int>
    public var attributes: [Attribute]
    public var genericParameters: [GenericParameter]
    public var isOptional: Bool {
        return false
    }
    public var isOverriding: Bool {
        return true
    }
}
