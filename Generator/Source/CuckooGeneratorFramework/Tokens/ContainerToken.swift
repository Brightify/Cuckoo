//
//  ContainerToken.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol ContainerToken: Token {
    var name: String { get }
    var accessibility: Accessibility { get }
    var range: CountableRange<Int> { get }
    var nameRange: CountableRange<Int> { get }
    var bodyRange: CountableRange<Int> { get }
    var initializers: [Initializer] { get }
    var children: [Token] { get }
    var implementation: Bool { get }
    var inheritedTypes: [InheritanceDeclaration] { get }
    var attributes: [Attribute] { get }
}

extension ContainerToken {
    public func serialize() -> [String : Any] {
        let properties = children.flatMap { $0 as? InstanceVariable }
            .filter { $0.accessibility.isAccessible }
            .map { $0.serializeWithType() }

        let methods = children.flatMap { $0 as? Method }
            .filter { $0.accessibility.isAccessible && !$0.isInit && !$0.isDeinit }
            .map { $0.serializeWithType() }

        let initializers = children.flatMap { $0 as? Method }
            .filter { $0.accessibility.isAccessible && $0.isInit && !$0.isDeinit }
            .map { $0.serializeWithType() }

        return [
            "name": name,
            "accessibility": accessibility,
            "isAccessible": accessibility.isAccessible,
            "children": children.map { $0.serializeWithType() },
            "properties": properties,
            "methods": methods,
            "initializers": implementation ? [] : initializers,
            "isImplementation": implementation,
            "mockName": "Mock\(name)"
        ]
    }
}
