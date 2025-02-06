public protocol ToBeStubbedProperty: ToBeStubbedReadOnlyProperty where GetterType.OutputType == SetterType.InputType {
    associatedtype SetterType: StubNoReturnFunction

    func set<M: Matchable>(_ matcher: M) -> SetterType where M.MatchedType == SetterType.InputType
}

public struct ProtocolToBeStubbedProperty<MOCK: ProtocolMock, T>: ToBeStubbedProperty {
    private let manager: MockManager
    private let name: String
    
    public var get: ProtocolStubFunction<Void, T> {
        ProtocolStubFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: getterName(name),
                parameterMatchers: []
            )
        )
    }
    
    public func set<M: Matchable>(_ matcher: M) -> ProtocolStubNoReturnFunction<T> where M.MatchedType == T {
        ProtocolStubNoReturnFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: setterName(name),
                parameterMatchers: [matcher.matcher]
            )
        )
    }
    
    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}

public struct ClassToBeStubbedProperty<MOCK: ClassMock, T>: ToBeStubbedProperty {
    private let manager: MockManager
    private let name: String

    public var get: ClassStubFunction<Void, T> {
        ClassStubFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: getterName(name),
                parameterMatchers: []
            )
        )
    }

    public func set<M: Matchable>(_ matcher: M) -> ClassStubNoReturnFunction<T> where M.MatchedType == T {
        ClassStubNoReturnFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: setterName(name),
                parameterMatchers: [matcher.matcher]
            )
        )
    }

    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}

public protocol ToBeStubbedOptionalProperty: ToBeStubbedReadOnlyProperty where GetterType.OutputType == SetterType.InputType {
    associatedtype SetterType: StubNoReturnFunction

    func set<M: OptionalMatchable>(_ matcher: M) -> SetterType where Optional<M.OptionalMatchedType> == SetterType.InputType
}

public struct ProtocolToBeStubbedOptionalProperty<MOCK: ProtocolMock, T>: ToBeStubbedOptionalProperty {
    private let manager: MockManager
    private let name: String

    public var get: ProtocolStubFunction<Void, T?> {
        ProtocolStubFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: getterName(name),
                parameterMatchers: []
            )
        )
    }

    public func set<M: OptionalMatchable>(_ matcher: M) -> ProtocolStubNoReturnFunction<T?> where M.OptionalMatchedType == T {
        ProtocolStubNoReturnFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: setterName(name),
                parameterMatchers: [matcher.optionalMatcher]
            )
        )
    }

    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}

public struct ClassToBeStubbedOptionalProperty<MOCK: ClassMock, T>: ToBeStubbedOptionalProperty {
    private let manager: MockManager
    private let name: String

    public var get: ClassStubFunction<Void, T?> {
        ClassStubFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: getterName(name),
                parameterMatchers: []
            )
        )
    }

    public func set<M: OptionalMatchable>(_ matcher: M) -> ClassStubNoReturnFunction<T?> where M.OptionalMatchedType == T {
        ClassStubNoReturnFunction(
            stub: manager.createStub(
                for: MOCK.self,
                method: setterName(name),
                parameterMatchers: [matcher.optionalMatcher]
            )
        )
    }

    public init(manager: MockManager, name: String) {
        self.manager = manager
        self.name = name
    }
}
