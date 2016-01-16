//
//  Description.swift
//  Mockery
//
//  Created by Tadeas Kriz on 16/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//
/*
@Override
public Description appendValue(Object value) {
    if (value == null) {
        append("null");
    } else if (value instanceof String) {
        toJavaSyntax((String) value);
    } else if (value instanceof Character) {
        append('"');
            toJavaSyntax((Character) value);
            append('"');
    } else if (value instanceof Short) {
        append('<');
        append(descriptionOf(value));
        append("s>");
    } else if (value instanceof Long) {
        append('<');
        append(descriptionOf(value));
        append("L>");
    } else if (value instanceof Float) {
        append('<');
        append(descriptionOf(value));
        append("F>");
    } else if (value.getClass().isArray()) {
        appendValueList("[",", ","]", new ArrayIterator(value));
    } else {
        append('<');
        append(descriptionOf(value));
        append('>');
    }
    return this;
}
*/

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

//public class BaseDescription: Description {
    
//}

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