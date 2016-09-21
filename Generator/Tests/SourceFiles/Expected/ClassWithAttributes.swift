// MARK: - Mocks generated from file: SourceFiles/ClassWithAttributes.swift
/* Multi
   line
   comment */

import Cuckoo

public class MockClassWithAttributes: ClassWithAttributes, Cuckoo.Mock {
    public typealias MocksType = ClassWithAttributes
    public typealias Stubbing = __StubbingProxy_ClassWithAttributes
    public typealias Verification = __VerificationProxy_ClassWithAttributes
    public let manager = Cuckoo.MockManager()
    
    private var observed: ClassWithAttributes?
    
    public func spy(on victim: ClassWithAttributes) -> Self {
        observed = victim
        return self
    }
    
    public struct __StubbingProxy_ClassWithAttributes: Cuckoo.StubbingProxy {
        private let manager: Cuckoo.MockManager
        
        public init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
    }
    
    public struct __VerificationProxy_ClassWithAttributes: Cuckoo.VerificationProxy {
        private let manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

public class ClassWithAttributesStub: ClassWithAttributes {
}
