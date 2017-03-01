// MARK: - Mocks generated from file: SourceFiles/MultipleClasses.swift
//
//  MultipleClasses.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

class MockA: A, Cuckoo.Mock {
    typealias MocksType = A
    typealias Stubbing = __StubbingProxy_A
    typealias Verification = __VerificationProxy_A
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: A?
    
    func spy(on victim: A) -> Self {
        observed = victim
        return self
    }
    
    struct __StubbingProxy_A: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.manager = cuckoo_manager
        }
    }
    
    struct __VerificationProxy_A: Cuckoo.VerificationProxy {
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

class AStub: A {
}

class MockB: B, Cuckoo.Mock {
    typealias MocksType = B
    typealias Stubbing = __StubbingProxy_B
    typealias Verification = __VerificationProxy_B
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: B?
    
    func spy(on victim: B) -> Self {
        observed = victim
        return self
    }
    
    struct __StubbingProxy_B: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.manager = cuckoo_manager
        }
    }
    
    struct __VerificationProxy_B: Cuckoo.VerificationProxy {
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

class BStub: B {
}
