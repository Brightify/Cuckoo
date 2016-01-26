//
//  Description.swift
//  Mockery
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Optional: SelfDescribing {
    public func describeTo(description: Description) {
        switch self {
        case .None:
            description.appendText("nil")
        case .Some(let value):
            description.appendValue(value)
        }
    }
}

extension String: SelfDescribing {
    public func describeTo(description: Description) {
        description.appendText("\"\(self)\"")
    }
}

extension Bool: SelfDescribing {
    public func describeTo(description: Description) {
        description.appendText("<\(self)>")
    }
}

extension Int: SelfDescribing {
    public func describeTo(description: Description) {
        description.appendText("<\(self)>")
    }
}

extension Float: SelfDescribing {
    public func describeTo(description: Description) {
        description.appendText("<\(self)>")
    }
}

extension Double: SelfDescribing {
    public func describeTo(description: Description) {
        description.appendText("<\(self)>")
    }
}

public protocol Description: class {
    
    func appendText(text: String) -> Self
    
    func appendCharacter(character: Character) -> Self
    
}

extension Description {
    public func appendDescriptionOf(value: SelfDescribing) -> Self {
        value.describeTo(self)
        return self
    }
    
    public func appendValue(value: Any) -> Self {
        if let selfDescribing = value as? SelfDescribing {
            return appendDescriptionOf(selfDescribing)
        }
        
        return appendText("\(value)")
    }
    
    public func appendValues<T>(values: T..., start: String, separator: String, end: String) -> Self {
        appendValues(values, start: start, separator: separator, end: end)

        values.forEach {
            appendValue($0)
        }
        return self
    }
    
    func appendDescriptions<T: SelfDescribing, S: SequenceType where S.Generator.Element == T>(values: S, start: String, separator: String, end: String) -> Self {
        values.forEach {
            appendDescriptionOf ($0)
        }
        return self
    }

}

public protocol SelfDescribing {
    func describeTo(description: Description)
}

public final class StringDescription: Description, CustomStringConvertible {
    public private(set) var description: String
    
    public init(description: String = "") {
        self.description = description
    }
    
    public func appendText(text: String) -> StringDescription {
        description += text
        return self
    }
    
    public func appendCharacter(character: Character) -> StringDescription {
        description.append(character)
        return self
    }
}