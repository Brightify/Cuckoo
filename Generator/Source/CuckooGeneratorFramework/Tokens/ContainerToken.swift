//
//  ContainerToken.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol ContainerToken: Token, HasAccessibility {
    var name: String { get }
    var prefix: String { get }
    var range: CountableRange<Int> { get }
    var nameRange: CountableRange<Int> { get }
    var bodyRange: CountableRange<Int> { get }
    var initializers: [Initializer] { get }
    var children: [Token] { get }
    var implementation: Bool { get }
    var inheritedTypes: [InheritanceDeclaration] { get }
    var attributes: [Attribute] { get }
    var genericParameters: [GenericParameter] { get }
}

extension ContainerToken {
    public func serialize() -> [String : Any] {
        let properties = children.compactMap { $0 as? InstanceVariable }
            .filter { $0.accessibility.isAccessible }
            .map { $0.serializeWithType() }

        let methods = children.compactMap { $0 as? Method }
            .filter { $0.accessibility.isAccessible && !$0.isInit && !$0.isDeinit }
            .map { $0.serializeWithType() }

        let initializers = children.compactMap { $0 as? Method }
            .filter { $0.accessibility.isAccessible && $0.isInit && !$0.isDeinit }
            .map { $0.serializeWithType() }

        let genericParametersString = genericParameters.map { $0.description }.joined(separator: ", ")
        let genericArgumentsString = genericParameters.map { $0.name }.joined(separator: ", ")
        let genericProtocolIdentity = genericParameters.map { "\(Templates.staticGenericParameter).\($0.name) == \($0.name)" }.joined(separator: ", ")
        let isGeneric = !genericParameters.isEmpty

        return [
            "name": name,
            "accessibility": accessibility.sourceName,
            "isAccessible": accessibility.isAccessible,
            "children": children.map { $0.serializeWithType() },
            "properties": properties,
            "methods": methods,
            "initializers": implementation ? [] : initializers,
            "isImplementation": implementation,
            "mockName": "\(prefix)Mock\(name)",
            "stubName": "\(prefix)\(name)Stub",
            "inheritedTypes": inheritedTypes,
            "attributes": attributes.filter { $0.isSupported },
            "isGeneric": isGeneric,
            "genericParameters": isGeneric ? "<\(genericParametersString)>" : "",
            "genericArguments": isGeneric ? "<\(genericArgumentsString)>" : "",
            "genericProtocolIdentity": genericProtocolIdentity,
        ]
    }
}
