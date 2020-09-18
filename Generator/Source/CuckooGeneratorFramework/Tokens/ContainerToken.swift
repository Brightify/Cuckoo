//
//  ContainerToken.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol ContainerToken: ParentToken, ChildToken {
    var initializers: [Initializer] { get }
    var implementation: Bool { get }
    var inheritedTypes: [InheritanceDeclaration] { get }
    var genericParameters: [GenericParameter] { get }
}

extension ContainerToken {
    public func serialize() -> [String : Any] {
        func withAdjustedAccessibility(token: Token & HasAccessibility) -> Token & HasAccessibility {
            // We only want to adjust tokens that are accessible and lower than the enclosing type
            guard token.accessibility.isAccessible && token.accessibility < accessibility else { return token }
            var mutableToken = token
            mutableToken.accessibility = accessibility
            return mutableToken
        }

        let accessibilityAdjustedChildren = children.map { child -> Token in
            guard let childWithAccessibility = child as? HasAccessibility & Token else { return child }
            return withAdjustedAccessibility(token: childWithAccessibility)
        }

        let properties = accessibilityAdjustedChildren.compactMap { $0 as? InstanceVariable }
            .filter { $0.accessibility.isAccessible }
            .map { $0.serializeWithType() }

        let methods = accessibilityAdjustedChildren.compactMap { $0 as? Method }
            .filter { $0.accessibility.isAccessible && !$0.isInit && !$0.isDeinit }
            .map { $0.serializeWithType() }

        let initializers = accessibilityAdjustedChildren.compactMap { $0 as? Method }
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
            "hasParent": parent != nil,
            "parentFullyQualifiedName": parent?.fullyQualifiedName ?? "",
            "children": accessibilityAdjustedChildren.map { $0.serializeWithType() },
            "properties": properties,
            "methods": methods,
            "initializers": implementation ? [] : initializers,
            "isImplementation": implementation,
            "mockName": "Mock\(name)",
            "inheritedTypes": inheritedTypes,
            "attributes": attributes.filter { $0.isSupported },
            "hasUnavailablePlatforms": hasUnavailablePlatforms,
            "unavailablePlatformsCheck": unavailablePlatformsCheck,
            "isGeneric": isGeneric,
            "genericParameters": isGeneric ? "<\(genericParametersString)>" : "",
            "genericArguments": isGeneric ? "<\(genericArgumentsString)>" : "",
            "genericProtocolIdentity": genericProtocolIdentity,
        ]
    }
}
