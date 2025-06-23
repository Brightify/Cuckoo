struct StubError: Error {}

class ClassWithTypedThrows {
    func typedThrows() throws(StubError) -> Int? {
        return nil
    }

    func genericWithTypedThrows<T>(_ value: T) throws(StubError) {}
}
