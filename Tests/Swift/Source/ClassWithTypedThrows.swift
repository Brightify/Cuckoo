struct StubError: Error {}

class ClassWithTypedThrows {
    enum Error: Swift.Error {
        case failed
    }

    func typedThrows() throws(Error) -> Int? {
        return nil
    }

    func genericWithTypedThrows<T>(_ value: T) throws(StubError) {}

    func asyncTypedThrow() async throws(Error) -> Int? {
        return nil
    }

    func asyncGenericWithTypedThrows<T>(_ value: T) async throws(StubError) {}

    func untypedThrows() throws {}
}
