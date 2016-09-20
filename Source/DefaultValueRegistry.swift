//
//  DefaultValueRegistry.swift
//  Cuckoo
//
//  Created by Tadeáš Kříž on 20/09/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public class DefaultValueRegistry {

    private static var registeredTypes: [ObjectIdentifier: Any] = [
        ObjectIdentifier(Void): Void(),
        ObjectIdentifier(Int): Int(),
        ObjectIdentifier(String): String(),
        ObjectIdentifier(Bool): Bool(),
        ObjectIdentifier(Double): Double(),
        ObjectIdentifier(Float): Float(),
    ]

    public static func register<T>(value: T, forType type: T.Type) {
        registeredTypes[ObjectIdentifier(type)] = value
    }

    public static func defaultValue<T>(type: Set<T>.Type) -> Set<T> {
        return defaultValueOrNil(type) ?? []
    }

    public static func defaultValue<T>(type: Array<T>.Type) -> Array<T> {
        return defaultValueOrNil(type) ?? []
    }

    public static func defaultValue<K, V>(type: Dictionary<K, V>.Type) -> Dictionary<K, V> {
        return defaultValueOrNil(type) ?? [:]
    }

    public static func defaultValue<T>(type: Optional<T>.Type) -> Optional<T> {
        return defaultValueOrNil(type) ?? nil
    }

    public static func defaultValue<T>(type: T.Type) -> T {
        if let registeredDefault: T = defaultValueOrNil(type) {
            return registeredDefault
        }
        fatalError("Type \(T.self) does not have default return value registered.")
    }

    public static func defaultValueOrNil<T>(type: T.Type) -> T? {
        return registeredTypes[ObjectIdentifier(type)] as? T
    }
}
