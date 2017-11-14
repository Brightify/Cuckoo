//
//  VerificationProxyTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

import Foundation

extension Templates {
    static let verificationProxy = """
struct __VerificationProxy_{{ container.name }}: Cuckoo.VerificationProxy {
    private let cuckoo_manager: Cuckoo.MockManager
    private let callMatcher: Cuckoo.CallMatcher
    private let sourceLocation: Cuckoo.SourceLocation

    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
        self.cuckoo_manager = manager
        self.callMatcher = callMatcher
        self.sourceLocation = sourceLocation
    }

    {% for property in container.properties %}
    var {{property.name}}: Cuckoo.Verify{% if property.isReadOnly %}ReadOnly{%endif%}Property<{{property.type|genericSafe}}> {
        return .init(manager: cuckoo_manager, name: "{{property.name}}", callMatcher: callMatcher, sourceLocation: sourceLocation)
    }
    {% endfor %}

    {% for method in container.methods %}
    @discardableResult
    func {{method.name}}{{method.parameters|matchableGenericNames}}({{method.parameters|matchableParameterSignature}}) -> Cuckoo.__DoNotUse<{{method.returnType|genericSafe}}>{{method.parameters|matchableGenericWhere}} {
        {{method.parameters|parameterMatchers}}
        return cuckoo_manager.verify("{{method.fullyQualifiedName}}", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
    }
    {% endfor %}
}
"""
}
