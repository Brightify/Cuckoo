//
//  NSValueConvertible.swift
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import Foundation
import CoreGraphics

public protocol NSValueConvertible {
    func toNSValue() -> NSValue
}

extension Optional: NSValueConvertible where Wrapped: NSValueConvertible {
    public func toNSValue() -> NSValue {
        if let value = self {
            return value.toNSValue()
        } else {
            return NSValue(pointer: nil)
        }
    }
}

extension Int: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension Int8: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension Int16: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension Int32: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension Int64: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}

extension UInt: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension UInt8: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension UInt16: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension UInt32: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension UInt64: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}

extension Double: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}
extension Float: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}

extension Bool: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSNumber(value: self)
    }
}

extension NSRange: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(range: self)
    }
}

#if os(iOS)
import UIKit

extension CGRect: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(cgRect: self)
    }
}
extension CGPoint: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(cgPoint: self)
    }
}
extension CGSize: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(cgSize: self)
    }
}
extension CGVector: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(cgVector: self)
    }
}

extension UIEdgeInsets: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(uiEdgeInsets: self)
    }
}

extension UIOffset: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(uiOffset: self)
    }
}
#elseif os(macOS)
extension CGRect: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(rect: self)
    }
}
extension CGPoint: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(point: self)
    }
}
extension CGSize: NSValueConvertible {
    public func toNSValue() -> NSValue {
        return NSValue(size: self)
    }
}
#endif
