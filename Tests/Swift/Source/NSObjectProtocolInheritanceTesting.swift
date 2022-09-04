//
//  NSObjectProtocolInheritanceTesting.swift
//  Cuckoo
//
//  Created by Shoto Kobayashi on 04/09/2022.
//

import Foundation

protocol PlainProtocolToTestNSObjectProtocolInheritance {
}

protocol ProtocolNotInheritingFromNSObjectProtocol {
}

protocol ProtocolInheritingFromNSObjectProtocol: NSObjectProtocol {
}

protocol ChildProtocolInheritingFromNSObjectProtocol: ProtocolInheritingFromNSObjectProtocol {
}

protocol ProtocolInheritingFromNSObjectProtocolUsingProtocolComposition: NSObjectProtocol & PlainProtocolToTestNSObjectProtocolInheritance {
}

protocol ChildProtocolInheritingFromNSObjectProtocolUsingProtocolComposition: ProtocolInheritingFromNSObjectProtocolUsingProtocolComposition {
}

protocol ProtocolInheritingFromNSObjectProtocolAndOtherProtocol: NSObjectProtocol, PlainProtocolToTestNSObjectProtocolInheritance {
}

protocol ChildProtocolInheritingFromNSObjectProtocolAndOtherProtocol: ProtocolInheritingFromNSObjectProtocolAndOtherProtocol {
}
