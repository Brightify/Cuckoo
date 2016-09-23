//
//  DefaultValueRegistry.swift
//  Cuckoo
//
//  Created by Tadeáš Kříž on 20/09/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public class DefaultValueRegistry {
    
    private static let defaultRegisteredTypes: [ObjectIdentifier: Any] = [
        ObjectIdentifier(Void.self): Void(),
        ObjectIdentifier(Int.self): Int(),
        ObjectIdentifier(Int8.self): Int8(),
        ObjectIdentifier(Int16.self): Int16(),
        ObjectIdentifier(Int32.self): Int32(),
        ObjectIdentifier(Int64.self): Int64(),
        ObjectIdentifier(UInt.self): UInt(),
        ObjectIdentifier(UInt8.self): UInt8(),
        ObjectIdentifier(UInt16.self): UInt16(),
        ObjectIdentifier(UInt32.self): UInt32(),
        ObjectIdentifier(UInt64.self): UInt64(),
        ObjectIdentifier(String.self): String(),
        ObjectIdentifier(Bool.self): Bool(),
        ObjectIdentifier(Double.self): Double(),
        ObjectIdentifier(Float.self): Float()
    ]
    
    private static var registeredTypes = defaultRegisteredTypes
    
    public static func register<T>(value: T, forType type: T.Type) {
        registeredTypes[ObjectIdentifier(type)] = value
    }
    
    public static func defaultValue<T>(for type: Set<T>.Type) -> Set<T> {
        return defaultValueOrNil(for: type) ?? []
    }
    
    public static func defaultValue<T>(for type: Array<T>.Type) -> Array<T> {
        return defaultValueOrNil(for: type) ?? []
    }
    
    public static func defaultValue<K, V>(for type: Dictionary<K, V>.Type) -> Dictionary<K, V> {
        return defaultValueOrNil(for: type) ?? [:]
    }
    
    public static func defaultValue<T>(for type: Optional<T>.Type) -> Optional<T> {
        return defaultValueOrNil(for: type) ?? nil
    }
    
    public static func defaultValue<T>(for type: T.Type) -> T {
        if let registeredDefault = defaultValueOrNil(for: type) {
            return registeredDefault
        }
        fatalError("Type \(T.self) does not have default return value registered.")
    }
    
    public static func reset() {
        registeredTypes = defaultRegisteredTypes
    }
    
    private static func defaultValueOrNil<T>(for type: T.Type) -> T? {
        return registeredTypes[ObjectIdentifier(type)] as? T
    }
    
    // Overloads for tuples.
    
    public static func defaultValue<P1, P2>(for type: (P1, P2).Type) -> (P1, P2) {
        if let registeredDefault = defaultValueOrNil(for: type) {
            return registeredDefault
        } else {
            return (defaultValue(for: P1.self), defaultValue(for: P2.self))
        }
    }
    
    public static func defaultValue<P1, P2, P3>(for type: (P1, P2, P3).Type) -> (P1, P2, P3) {
        if let registeredDefault = defaultValueOrNil(for: type) {
            return registeredDefault
        } else {
            return (defaultValue(for: P1.self), defaultValue(for: P2.self), defaultValue(for: P3.self))
        }
    }
    
    public static func defaultValue<P1, P2, P3, P4>(for type: (P1, P2, P3, P4).Type) -> (P1, P2, P3, P4) {
        if let registeredDefault = defaultValueOrNil(for: type) {
            return registeredDefault
        } else {
            return (defaultValue(for: P1.self), defaultValue(for: P2.self), defaultValue(for: P3.self), defaultValue(for: P4.self))
        }
    }
    
    public static func defaultValue<P1, P2, P3, P4, P5>(for type: (P1, P2, P3, P4, P5).Type) -> (P1, P2, P3, P4, P5) {
        if let registeredDefault = defaultValueOrNil(for: type) {
            return registeredDefault
        } else {
            return (defaultValue(for: P1.self), defaultValue(for: P2.self), defaultValue(for: P3.self), defaultValue(for: P4.self), defaultValue(for: P5.self))
        }
    }
    
    public static func defaultValue<P1, P2, P3, P4, P5, P6>(for type: (P1, P2, P3, P4, P5, P6).Type) -> (P1, P2, P3, P4, P5, P6) {
        if let registeredDefault = defaultValueOrNil(for: type) {
            return registeredDefault
        } else {
            return (defaultValue(for: P1.self), defaultValue(for: P2.self), defaultValue(for: P3.self), defaultValue(for: P4.self), defaultValue(for: P5.self), defaultValue(for: P6.self))
        }
    }
}
