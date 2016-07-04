//
//  SelfDescribing.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol SelfDescribing {
    func describeTo(description: Description)
}

extension Optional: SelfDescribing {
    public func describeTo(description: Description) {
        switch self {
        case .None:
            description.append(text: "nil")
        case .Some(let value):
            description.append(value: value)
        }
    }
}

extension String: SelfDescribing {
    public func describeTo(description: Description) {
        description.append(text: "\"\(self)\"")
    }
}

extension Bool: SelfDescribing {
    public func describeTo(description: Description) {
        description.append(text: "<\(self)>")
    }
}

extension Int: SelfDescribing {
    public func describeTo(description: Description) {
        description.append(text: "<\(self)>")
    }
}

extension Float: SelfDescribing {
    public func describeTo(description: Description) {
        description.append(text: "<\(self)>")
    }
}

extension Double: SelfDescribing {
    public func describeTo(description: Description) {
        description.append(text: "<\(self)>")
    }
}

extension Character: SelfDescribing {
    public func describeTo(description: Description) {
        description.append(text: "'\(self)'")
    }
}