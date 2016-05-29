//
//  Description.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public class Description: CustomStringConvertible {
    public private(set) var description = ""
    
    func append(values: Any...) -> Description {
        values.forEach {
            if let value = $0 as? SelfDescribing {
                value.describeTo(self)
            } else {
                description += "\($0)"
            }
        }
        return self
    }
}