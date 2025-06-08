public protocol ToBeStubbedThrowingProperty {
    associatedtype GetterType: StubThrowingFunction

    var get: GetterType { get }
}

public struct ProtocolToBeStubbedThrowingProperty<MOCK: ProtocolMock, T>: ToBeStubbedThrowingProperty {
    private let manager: MockManager
    private let name: String

    public var get: ProtocolStubThrowingFunction<Void, T, Error> {
        ProtocolStubThrowingFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: getterName(name),
                parameterMatchers: []
            )
        )
    }

    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}

public struct ClassToBeStubbedThrowingProperty<MOCK: ClassMock, T>: ToBeStubbedThrowingProperty {
    private let manager: MockManager
    private let name: String

    public var get: ClassStubThrowingFunction<Void, T, Error> {
        ClassStubThrowingFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: getterName(name),
                parameterMatchers: []
            )
        )
    }

    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}
