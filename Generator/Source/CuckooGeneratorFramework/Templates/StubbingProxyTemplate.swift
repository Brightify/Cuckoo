//
//  StubbingProxyTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

import Foundation

extension Templates {
    static let stubbingProxy = """
{{ container.accessibility }} struct __StubbingProxy_{{ container.name }}: Cuckoo.StubbingProxy {
    private let cuckoo_manager: Cuckoo.MockManager

    {{ container.accessibility }} init(manager: Cuckoo.MockManager) {
        self.cuckoo_manager = manager
    }
    {% for property in container.properties %}
    {% if property.unavailablePlatforms.count > 0 %}
    #if !os({{ property.unavailablePlatforms|join:") && !os(" }})
    {% endif %}
    {% for attribute in property.attributes %}
    {{ attribute.text }}
    {% endfor %}
    var {{property.name}}: Cuckoo.{{ property.stubType }}<{{ container.mockName }}, {% if property.isReadOnly %}{{property.type|genericSafe}}{% else %}{{property.nonOptionalType|genericSafe}}{% endif %}> {
        return .init(manager: cuckoo_manager, name: "{{property.name}}")
    }
    {% if property.unavailablePlatforms.count > 0 %}
    #endif
    {% endif %}
    {% endfor %}
    {% for method in container.methods %}
    {% if method.unavailablePlatforms.count > 0 %}
    #if !os({{ method.unavailablePlatforms|join:") && !os(" }})
    {% endif %}
    {% for attribute in method.attributes %}
    {{ attribute.text }}
    {% endfor %}
    func {{method.name|escapeReservedKeywords}}{{method.self|matchableGenericNames}}({{method.parameters|matchableParameterSignature}}) -> {{method.stubFunction}}<({{method.inputTypes|genericSafe}}){%if method.returnType != "Void" %}, {{method.returnType|genericSafe}}{%endif%}>{{method.self|matchableGenericWhereClause}} {
        {{method.parameters|parameterMatchers}}
        return .init(stub: cuckoo_manager.createStub(for: {{ container.mockName }}.self, method: "{{method.fullyQualifiedName}}", parameterMatchers: matchers))
    }
    {% if method.unavailablePlatforms.count > 0 %}
    #endif
    {% endif %}
    {% endfor %}
}
"""
}
