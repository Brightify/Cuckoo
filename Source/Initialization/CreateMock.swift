import Foundation

public func createMock<MOCKED: Mocked>(
    for mockedType: MOCKED.Type,
    configuration: (MockBuilder, MOCKED.MockType.Stubbing) -> MOCKED.MockType
) -> MOCKED.MockType {
    createMock(MOCKED.MockType.self, configuration: configuration)
}

public func createMock<MOCK: Mock>(
    _ mockType: MOCK.Type,
    configuration: (MockBuilder, MOCK.Stubbing) -> MOCK
) -> MOCK {
    let manager = MockManager(hasParent: MOCK.cuckoo_hasSuperclass)

    MockManager.preconfiguredManagerThreadLocal.value = manager
    defer { MockManager.preconfiguredManagerThreadLocal.delete() }

    let builder = MockBuilder(manager: manager)

    let stubbing = MOCK.Stubbing(manager: manager)
    return configuration(builder, stubbing)
}
