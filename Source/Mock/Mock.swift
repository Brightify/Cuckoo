public protocol HasMockManager {
    var cuckoo_manager: MockManager { get }
}

public protocol HasSuperclass {
    static var cuckoo_hasSuperclass: Bool { get }
}

public protocol Mock: HasMockManager, HasSuperclass {
    associatedtype MocksType
    associatedtype Stubbing: StubbingProxy
    associatedtype Verification: VerificationProxy

    func getStubbingProxy() -> Stubbing
    
    func getVerificationProxy(_ callMatcher: CallMatcher, sourceLocation: SourceLocation) -> Verification

    func enableDefaultImplementation(_ stub: MocksType)
}

public extension Mock {
    func getStubbingProxy() -> Stubbing {
        Stubbing(manager: cuckoo_manager)
    }
    
    func getVerificationProxy(_ callMatcher: CallMatcher, sourceLocation: SourceLocation) -> Verification {
        Verification(manager: cuckoo_manager, callMatcher: callMatcher, sourceLocation: sourceLocation)
    }

    func withEnabledDefaultImplementation(_ stub: MocksType) -> Self {
        enableDefaultImplementation(stub)
        return self
    }
}

public protocol ProtocolMock: Mock { }

public protocol ClassMock: Mock {
    func enableSuperclassSpy()
}

public extension ClassMock {
    func enableSuperclassSpy() {
        cuckoo_manager.enableSuperclassSpy()
    }

    func withEnabledSuperclassSpy() -> Self {
        enableSuperclassSpy()
        return self
    }
}

public extension ClassMock {
    static var cuckoo_hasSuperclass: Bool {
        true
    }
}

public extension ProtocolMock {
    static var cuckoo_hasSuperclass: Bool {
        false
    }
}
