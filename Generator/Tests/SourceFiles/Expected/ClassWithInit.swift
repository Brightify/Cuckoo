// MARK: - Mocks generated from file: SourceFiles/ClassWithInit.swift
//
//  ClassWithInit.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 09/02/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

class MockClassWithInit: ClassWithInit, Cuckoo.Mock {
    typealias MocksType = ClassWithInit
    typealias Stubbing = __StubbingProxy_ClassWithInit
    typealias Verification = __VerificationProxy_ClassWithInit
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ClassWithInit?

    func spy(on victim: ClassWithInit) -> Self {
        observed = victim
        return self
    }

    struct __StubbingProxy_ClassWithInit: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.manager = cuckoo_manager
        }
    }

    struct __VerificationProxy_ClassWithInit: Cuckoo.VerificationProxy {
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

class ClassWithInitStub: ClassWithInit {
}
