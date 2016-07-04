//
//  Description.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public final class Description: CustomStringConvertible {
    public private(set) var description = ""

    public init(description: String = "") {
        self.description = description
    }

    public func append(text text: String) -> Self {
        description += text
        return self
    }
    
    public func append(descriptionOf value: SelfDescribing) -> Self {
        value.describeTo(self)
        return self
    }
    
    public func append(value value: Any) -> Self {
        if let selfDescribing = value as? SelfDescribing {
            return append(descriptionOf: selfDescribing)
        } else {
            return append(text: "\(value)")
        }
    }
}