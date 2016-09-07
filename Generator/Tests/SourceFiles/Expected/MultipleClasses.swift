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
    typealias Stubbing = __StubbingProxy_A
    typealias Verification = __VerificationProxy_A
    let manager = Cuckoo.MockManager()
    
    private var observed: A?
    
    override init() {
    }
    
    func spy(on victim: A) -> MockA {
        observed = victim
        return self
    }
    
    struct __StubbingProxy_A: Cuckoo.StubbingProxy {
        private let manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
    }
    
    struct __VerificationProxy_A: Cuckoo.VerificationProxy {
        private let manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}

class MockB: B, Cuckoo.Mock {
    typealias Stubbing = __StubbingProxy_B
    typealias Verification = __VerificationProxy_B
    let manager = Cuckoo.MockManager()
    
    private var observed: B?
    
    override init() {
    }
    
    func spy(on victim: B) -> MockB {
        observed = victim
        return self
    }
    
    struct __StubbingProxy_B: Cuckoo.StubbingProxy {
        private let manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
    }
    
    struct __VerificationProxy_B: Cuckoo.VerificationProxy {
        private let manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}
