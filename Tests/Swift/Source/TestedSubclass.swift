class TestedSubclass: TestedClass, TestedProtocol {
    required override init() {
        super.init()
    }

    required init(test: String) {
        super.init()
    }

    required init(labelA a: String, _ b: String) {
        super.init()
    }

    init(notRequired: Bool) {
        super.init()
    }

    convenience init(convenient: Bool) {
        self.init(notRequired: convenient)
    }

    func withImplicitlyUnwrappedOptional(i: Int!) -> String {
        return ""
    }
    
    // Should not be conflicting in mocked class
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    override func withAsync() async -> Int {
        return 1
    }
    
    // Should not be conflicting in mocked class
    override func withThrows() throws -> Int {
        return 1
    }

    func withNamedTuple(tuple: (a: String, b: String)) -> Int {
        return 0
    }

    func subclassMethod() -> Int {
        return 0
    }
    
    func withOptionalClosureAndReturn(_ a: String, closure: ((String) -> Void)?) -> Int {
        return 1
    }
    
    func withClosureAndParam(_ a: String, closure: (String) -> Int) -> Int {
        return 0
    }
    
    func withMultClosures(closure: ((String)) -> Int, closureB: (String) -> Int, closureC: (String) -> Int) -> Int {
        return 0
    }
    
    func withThrowingClosure(closure: (String) throws -> String?) -> String? {
        return nil
    }
    
    func withThrowingClosureThrows(closure: (String) throws -> String?) throws -> String? {
        return nil
    }
    
    func withThrowingEscapingClosure(closure: @escaping (String) throws -> String?) -> String? {
        return nil
    }
    
    func withThrowingOptionalClosureThrows(closure: ((String) throws -> String?)?) throws -> String? {
        return nil
    }

    func methodWithParameter(_ param: String) -> String {
        return "b"
    }

    func methodWithParameter(_ param: Int) -> String {
        return "c"
    }

    func genericReturn() -> Dictionary<Int, Void> {
        return [:]
    }

    // Don't fix method line breaks.
    // This method is for testing multiline argument.
    func multilineMethod(
        completion: @escaping (
            _ bar: Int,
            _ baz: Int,
            _ qux: Int
        ) -> Void
    ) {
    }

    // Don't fix method line breaks.
    // This method is for testing generic multiline arguments.
    func genericMultilineMethod<
        T,
        U,
        V
    >(
        completion: @escaping (
            _ bar: V,
            _ baz: U,
            _ qux: T
        ) -> Void
    ) {

    }

    func frobnicate() -> LongType<
      Int,
      String,
      Bool,
      Void
    > {
        LongType()
    }

    @available(iOS 13.0, *)
    @available(tvOS 13.0, *)
    @available(macOS 10.15, *)
    func asyncMethod() async {
        try? await Task.sleep(nanoseconds: 10)
    }

    func compositionalParameters(param1: any Numeric, param2: OnlyLabelProtocol & Codable) {}
}

class TestedSubSubClass: TestedSubclass {

    func subSubMethod() -> String? {
        return nil
    }
    
}
