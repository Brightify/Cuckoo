import Cuckoo

import Foundation

class MockEmptyClass: EmptyClass, Cuckoo.Mock {
    typealias MocksType = EmptyClass
    typealias Stubbing = __StubbingProxy_EmptyClass
    typealias Verification = __VerificationProxy_EmptyClass
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: EmptyClass?
    
    func spy(on victim: EmptyClass) -> Self {
        observed = victim
        return self
    }
    
    struct __StubbingProxy_EmptyClass: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.manager = cuckoo_manager
        }
    }
    
    struct __VerificationProxy_EmptyClass: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = cuckoo_manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

class EmptyClassStub: EmptyClass {
}
