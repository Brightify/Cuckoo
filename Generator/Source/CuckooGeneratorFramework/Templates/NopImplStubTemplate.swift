//
//  NopImplStubTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

extension Templates {
    static let noImplStub = """
{{container.accessibility}} class {{ container.name }}Stub{{ container.genericParameters }}: {{ container.name }}{% if container.isImplementation %}{{ container.genericArguments }}{% endif %} {
    {% for property in container.properties %}
    {% for attribute in property.attributes %}
    {{ attribute.text }}
    {% endfor %}
    {{ property.accessibility }}{% if container.@type == "ClassDeclaration" %} override{% endif %} var {{ property.name }}: {{ property.type }} {
        get {
            return DefaultValueRegistry.defaultValue(for: ({{property.type|genericSafe}}).self)
        }
        {% ifnot property.isReadOnly %}
        set { }
        {% endif %}
    }
    {% endfor %}

    {% for initializer in container.initializers %}
    {{ initializer.accessibility }}{% if container.@type == "ClassDeclaration" %} override{% endif %}{% if initializer.@type == "ProtocolMethod" %} required{%endif%} init({{initializer.parameterSignature}}) {
        {% if container.@type == "ClassDeclaration" %}
        super.init({{initializer.call}})
        {% endif %}
    }
    {% endfor %}

    {% for method in container.methods %}
    {{ method.accessibility }}{% if container.@type == "ClassDeclaration" and method.isOverriding %} override{% endif %} func {{ method.name }}{{ method.genericParameters }}({{ method.parameterSignature }}) {{ method.returnSignature }} {{ method.whereClause }} {
        return DefaultValueRegistry.defaultValue(for: ({{method.returnType|genericSafe}}).self)
    }
    {% endfor %}
}
"""
}
