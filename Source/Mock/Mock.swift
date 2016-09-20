//
//  Mock.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Mock {
    associatedtype MocksType
    associatedtype Stubbing: StubbingProxy
    associatedtype Verification: VerificationProxy
    
    var manager: MockManager { get }
    
    func spy(on victim: MocksType) -> Self
    
    func getStubbingProxy() -> Stubbing
    
    func getVerificationProxy(_ callMatcher: CallMatcher, sourceLocation: SourceLocation) -> Verification
}

public extension Mock {
    func getStubbingProxy() -> Stubbing {
        return Stubbing(manager: manager)
    }
    
    func getVerificationProxy(_ callMatcher: CallMatcher, sourceLocation: SourceLocation) -> Verification {
        return Verification(manager: manager, callMatcher: callMatcher, sourceLocation: sourceLocation)
    }
}
