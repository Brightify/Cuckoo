import Foundation

extension Templates {
    static let stubbingProxy = """
{{ container.accessibility|withSpace }}struct __StubbingProxy_{{ container.name }}: Cuckoo.StubbingProxy {
    private let cuckoo_manager: Cuckoo.MockManager

    {{ container.accessibility|withSpace }}init(manager: Cuckoo.MockManager) {
        self.cuckoo_manager = manager
    }
    {% for property in container.properties %}
    {{ property.unavailablePlatformsCheck }}
    {% for attribute in property.attributes %}
    {{ attribute }}
    {% endfor %}
    var {{property.name}}: Cuckoo.{{ property.stubType }}<{{ container.mockName }}, {% if property.isReadOnly %}{{property.type|genericSafe}}{% else %}{{property.nonOptionalType|genericSafe}}{% endif %}> {
        return .init(manager: cuckoo_manager, name: "{{property.name}}")
    }
    {% if property.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}
    {% for method in container.methods %}
    {{ method.unavailablePlatformsCheck }}
    {% for attribute in method.attributes %}
    {{ attribute }}
    {% endfor %}
    func {{method.name|escapeReservedKeywords}}{{method.self|matchableGenericNames}}({{method.parameters|matchableParameterSignature}}) -> {{method.stubFunction}}<({{method.genericInputTypes|genericSafe}}){%if method.returnType != "Void" %}, {{method.returnType|genericSafe}}{%endif%}>{{method.self|matchableGenericWhereClause}} {
        {{method.parameters|parameterMatchers}}
        return .init(stub: cuckoo_manager.createStub(for: {{ container.mockName }}.self,
            method: "{{method.fullyQualifiedName}}",
            parameterMatchers: matchers
        ))
    }
    {% if method.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}
}
"""
}
