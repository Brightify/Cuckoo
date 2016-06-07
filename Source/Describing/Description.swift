//
//  Description.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public class Description: CustomStringConvertible {
    public private(set) var description = ""
    
    func append(texts: Any...) -> Description {
        texts.forEach {
            description += "\($0)"
        }
        return self
    }
    
    func appendValue(value: Any) -> Description {
        if let value = value as? SelfDescribing {
            value.describeTo(self)
        } else {
            description += "\(value)"
        }
        return self
    }
}