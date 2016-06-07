//
//  Description.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Description: class {
    func append(text text: String) -> Self

    func append(character character: Character) -> Self
}

extension Description {
    public func append(descriptionOf value: SelfDescribing) -> Self {
        value.describeTo(self)
        return self
    }

    public func append(value value: Any) -> Self {
        if let selfDescribing = value as? SelfDescribing {
            return append(descriptionOf: selfDescribing)
        }

        return append(text: "\(value)")
    }

    public func append(values values: Any..., start: String = "", separator: String = "", end: String = "") -> Self {
        append(text: start)

        values.enumerate().forEach {
            if $0 > 0 {
                append(text: separator)
            }

            append(value: $1)
        }
        append(text: end)

        return self
    }
}

public final class StringDescription: Description, CustomStringConvertible {
    public private(set) var description = ""

    public init(description: String = "") {
        self.description = description
    }

    public func append(text text: String) -> StringDescription {
        description += text
        return self
    }

    public func append(character character: Character) -> StringDescription {
        description.append(character)
        return self
    }
}