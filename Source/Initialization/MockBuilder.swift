import Foundation

public class MockBuilder {
    private let manager: MockManager

    init(manager: MockManager) {
        self.manager = manager
    }

    public func enableSuperclassSpy() {
        manager.enableSuperclassSpy()
    }

    public func enableDefaultStubImplementation() {
        manager.enableDefaultStubImplementation()
    }
}
