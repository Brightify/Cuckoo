//
//  VerificationProxyTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

import Foundation

extension Templates {
    static let verificationProxy = """
{{ container.accessibility }} struct __VerificationProxy_{{ container.name }}: Cuckoo.VerificationProxy {
    private let cuckoo_manager: Cuckoo.MockManager
    private let callMatcher: Cuckoo.CallMatcher
    private let sourceLocation: Cuckoo.SourceLocation

    {{ container.accessibility }} init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
        self.cuckoo_manager = manager
        self.callMatcher = callMatcher
        self.sourceLocation = sourceLocation
    }

    {% for property in container.properties %}
    {{ property.unavailablePlatformsCheck }}
    {% for attribute in property.attributes %}
    {{ attribute.text }}
    {% endfor %}
    var {{property.name}}: Cuckoo.{{property.verifyType}}<{% if property.isReadOnly %}{{property.type|genericSafe}}{% else %}{{property.nonOptionalType|genericSafe}}{% endif %}> {
        return .init(manager: cuckoo_manager, name: "{{property.name}}", callMatcher: callMatcher, sourceLocation: sourceLocation)
    }
    {% if property.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}

    {% for method in container.methods %}
    {{ method.unavailablePlatformsCheck }}
    {% for attribute in method.attributes %}
    {{ attribute.text }}
    {% endfor %}
    @discardableResult
    func {{method.name|escapeReservedKeywords}}{{method.self|matchableGenericNames}}({{method.parameters|matchableParameterSignature}}) -> Cuckoo.__DoNotUse<({{method.inputTypes|genericSafe}}), {{method.returnType|genericSafe}}>{{method.self|matchableGenericWhereClause}} {
        {{method.parameters|parameterMatchers}}
        return cuckoo_manager.verify(
\"\"\"
{{method.fullyQualifiedName}}
\"\"\", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
    }
    {% if method.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}
}
"""
}
