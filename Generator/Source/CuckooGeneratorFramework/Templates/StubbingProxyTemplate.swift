//
//  StubbingProxyTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

import Foundation

extension Templates {
    static let stubbingProxy = """
struct __StubbingProxy_{{ container.name }}: Cuckoo.StubbingProxy {
    private let cuckoo_manager: Cuckoo.MockManager

    init(manager: Cuckoo.MockManager) {
        self.cuckoo_manager = manager
    }
    {% for property in container.properties %}
    var {{property.name}}: Cuckoo.{{ property.stubType }}<{{ container.mockName }}, {{property.type|genericSafe}}> {
        return .init(manager: cuckoo_manager, name: "{{property.name}}")
    }
    {% endfor %}
    {% for method in container.methods %}
    func {{method.name}}{{method.parameters|matchableGenericNames}}({{method.parameters|matchableParameterSignature}}) -> {{method.stubFunction}}<({{method.inputTypes|genericSafe}}){%if method.returnType != "Void" %}, {{method.returnType|genericSafe}}{%endif%}>{{method.parameters|matchableGenericWhere}} {
        {{method.parameters|parameterMatchers}}
        return .init(stub: cuckoo_manager.createStub(for: {{ container.mockName }}.self, method: "{{method.fullyQualifiedName}}", parameterMatchers: matchers))
    }
    {% endfor %}
}
"""
}
